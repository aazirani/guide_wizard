import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/image_slide.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/sub_task_widget.dart';
import 'package:guide_wizard/widgets/task_page_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  var imageSlideSize = Size.zero;
  final scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  double _getHeightOfDraggableScrollableSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    double widgetSize = (screenHeight - (Dimens.taskPage.blocksAppBarWidgetHeight + imageSlideSize.height) + MediaQuery.of(context).padding.top + 25) / (screenHeight);
    return math.min(widgetSize, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      appBar: BlocksAppBarWidget(
        task: widget.task,
        step: widget.step,
        title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text),
      ),
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    // ****************** Web and App Conflict Implementation ******************
    if (kIsWeb) {
      return _buildScaffoldBody_Web();
    } else {
      return _buildScaffoldBody_App();
    }
    // *************************************************************************
  }

  Widget _buildScaffoldBody_Web() {
    return SizedBox.expand(
      child: Container(
        color: context.primaryColor,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: Dimens.taskPage.textOnlyScaffoldBorder,
              color: context.lightBackgroundColor),
          child: _buildPageContent(),
        ),
      ),
    );
  }

  _buildPageContent() {
    return RawScrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.task.sub_tasks.length + 2,
        itemBuilder: _buildDraggableSheetItems_Web,
      ),
    );
  }

  Widget _buildDraggableSheetItems_Web(context, i) {
    if(i == 0) return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _buildImageSlide(),
    );
    if(i == 1) return _buildDescription();
    return SubTaskWidget(
      index: i - 2,
      task: widget.task,
      step: widget.step,
      renderManager: renderManager,
    );
  }

  Widget _buildScaffoldBody_App() {
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
              borderRadius: Dimens.taskPage.textOnlyScaffoldBorder,
            color: context.lightBackgroundColor),
            // child: RawScrollbar(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: scrollController,
                itemCount: widget.task.sub_tasks.length + 1,
                itemBuilder: _buildDraggableSheetItems_App,
              ),
            // ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableSheetItems_App(context, i) {
    if(i == 0) return _buildDescription();
    return SubTaskWidget(
      index: i - 1,
      task: widget.task,
      step: widget.step,
      renderManager: renderManager,
    );
  }

  _buildDescription() {
    if (_technicalNameWithTranslationsStore.getTranslation(widget.task.description) == "") return SizedBox(height: Dimens.taskPage.textOnlyListViewPadding.top,);
    return Padding(
      padding: Dimens.taskPage.textOnlyListViewPadding,
      child: Text(
        _technicalNameWithTranslationsStore.getTranslation(widget.task.description),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.textOnLightBackgroundColor)
      ),
    );
  }
}
