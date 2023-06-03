import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/widgets/sub_task_widget.dart';
import 'package:boilerplate/widgets/task_page_appbar_widget.dart';
import 'package:boilerplate/widgets/image_slide.dart';
import 'package:boilerplate/widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageWithImage extends StatefulWidget {
  Task task;
  TaskPageWithImage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPageWithImage> createState() => _TaskPageWithImageState();
}

class _TaskPageWithImageState extends State<TaskPageWithImage> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();

  double appBarSize = 70.0;
  var imageSlideSize = Size.zero;

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
        title: widget.task.text.string,
        appBarSize: appBarSize,
        isDone: widget.task.isDone,
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
        description: widget.task.description.string
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
