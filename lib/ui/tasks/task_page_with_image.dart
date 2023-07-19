import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/sub_task_widget.dart';
import 'package:boilerplate/widgets/task_page_appbar_widget.dart';
import 'package:boilerplate/widgets/image_slide.dart';
import 'package:boilerplate/widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageWithImage extends StatefulWidget {
  Task task;
  TaskPageWithImage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPageWithImage> createState() => _TaskPageWithImageState();
}

class _TaskPageWithImageState extends State<TaskPageWithImage> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  double appBarSize = Dimens.blocksAppBarWidgetHeight;
  var imageSlideSize = Size.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  void initState() {
    super.initState();
  }

    double _getHeightOfDraggableScrollableSheet(){
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight - (appBarSize + imageSlideSize.height * 0.44)) / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text)!,
        appBarSize: appBarSize,
        taskId: widget.task.id,
      ),
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    return Stack(
      children: [
        MeasureSize(
            onChange: (Size size) {
              setState(() {
                imageSlideSize = size;
              });
            },
            child: _buildImageSlide()),
        _buildDraggableScrollableSheet(),
      ],
    );
  }

  Widget _buildImageSlide() {
    return ImageSlide(
        images: [widget.task.image_1, widget.task.image_2],
        description: _technicalNameWithTranslationsStore.getTranslation(widget.task.description)!
    );
  }

  Widget _buildDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: _getHeightOfDraggableScrollableSheet(),
        minChildSize: _getHeightOfDraggableScrollableSheet(),
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: AppColors.main_color,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: AppColors.bright_foreground_color),
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: widget.task.subTaskCount,
                  itemBuilder: (context, i) {
                    return SubTaskWidget(
                      index: i,
                      subTasks: widget.task.sub_tasks,
                      renderManager: renderManager,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
