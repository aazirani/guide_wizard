import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/image_slide.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/sub_task_widget.dart';
import 'package:guide_wizard/widgets/task_page_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageWithImage extends StatefulWidget {
  final Task task;
  final AppStep step;
  TaskPageWithImage({Key? key, required this.task, required this.step}) : super(key: key);

  @override
  State<TaskPageWithImage> createState() => _TaskPageWithImageState();
}

class _TaskPageWithImageState extends State<TaskPageWithImage> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  var imageSlideSize = Size.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  double _getHeightOfDraggableScrollableSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    double widgetSize = (screenHeight - (Dimens.blocksAppBarWidgetHeight + imageSlideSize.height) + MediaQuery.of(context).padding.top + 25) / (screenHeight);
    return math.min(widgetSize, 1);
  }

  double _getMaxHeightOfDraggableScrollableSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    double widgetSize = (screenHeight - 20) / (screenHeight);
    return math.min(widgetSize, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: BlocksAppBarWidget(
              task: widget.task,
              step: widget.step,
              title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text),
            ), // Your custom widget goes here
          ),
          SliverFillRemaining(
            child: _buildScaffoldBody()
          ),
        ],
      ),
    );
  }
  
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        task: widget.task,
        step: widget.step,
        title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text),
      ),
      body: _buildScaffoldBody(),
    );
  }
   */

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
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: Dimens.taskPageTextOnlyScaffoldBorder,
            color: AppColors.bright_foreground_color),
            child: RawScrollbar(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: scrollController,
                itemCount: widget.task.sub_tasks.length + 1,
                itemBuilder: _buildDraggableSheetItems,
              ),
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
      task: widget.task,
      step: widget.step,
      renderManager: renderManager,
    );
  }

  _buildDescription() {
    if (_technicalNameWithTranslationsStore.getTranslation(widget.task.description) == "") return SizedBox(height: Dimens.taskPageTextOnlyListViewPadding.top,);
    return Padding(
      padding: Dimens.taskPageTextOnlyListViewPadding,
      child: Text(
        _technicalNameWithTranslationsStore.getTranslation(widget.task.description),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.text_color)
      ),
    );
  }
}
