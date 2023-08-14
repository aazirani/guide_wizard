import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/image_slide.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/questions_list_page_appBar.dart';
import 'package:guide_wizard/widgets/sub_task_widget.dart';
import 'package:guide_wizard/widgets/task_page_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';
import 'dart:math' as math;

class TaskPageWithImage extends StatefulWidget {
  Task task;
  TaskPageWithImage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPageWithImage> createState() => _TaskPageWithImageState();
}

class _TaskPageWithImageState extends State<TaskPageWithImage> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
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

  double _getHeightOfDraggableScrollableSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight - (Dimens.blocksAppBarWidgetHeight + imageSlideSize.height) + MediaQuery.of(context).padding.top + 25) / (screenHeight);
  }

  double _getMaxHeightOfDraggableScrollableSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight - 20) / (screenHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        taskId: widget.task.id,
        title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text),
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
          child: _buildImageSlide()
        ),
        _buildDraggableScrollableSheet(),
      ],
    );
  }

  Widget _buildImageSlide() {
    List<String?> imagesList = [widget.task.image_1, widget.task.image_2];
    return ImageSlide(
        images: imagesList..removeWhere((element) => element == null),
        description: _technicalNameWithTranslationsStore.getTranslation(widget.task.description)
    );
  }

  Widget _buildDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: _getHeightOfDraggableScrollableSheet(),
        minChildSize: _getHeightOfDraggableScrollableSheet(),
        maxChildSize: math.max(_getMaxHeightOfDraggableScrollableSheet(), _getHeightOfDraggableScrollableSheet()),
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: Dimens.taskPageTextOnlyScaffoldBorder,
            color: AppColors.bright_foreground_color),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              controller: scrollController,
              itemCount: 1 + widget.task.subTaskCount,
              itemBuilder: _buildDraggableSheetItems,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableSheetItems(context, i) {
    if(i == 0) return _buildDescription();
    return SubTaskWidget(
      index: i - 1,
      subTasks: widget.task.sub_tasks,
      renderManager: renderManager,
    );
  }

  _buildDescription() {
    return Padding(
      padding: Dimens.taskPageTextOnlyListViewPadding,
      child: Observer(
        builder: (context) {
          return Text(
            _technicalNameWithTranslationsStore.getTranslation(widget.task.description),
            style: TextStyle(fontSize: Dimens.descriptionFontSize, color: AppColors.main_color),
          );
        },
      ),
    );
  }
}
