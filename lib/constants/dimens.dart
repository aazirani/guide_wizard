import 'package:flutter/material.dart';

class Dimens {
  Dimens._();
  // Nested SubClasses
  static TaskListDimens taskList = TaskListDimens();
  static TaskListTimeLineDimens taskListTimeLine = TaskListTimeLineDimens();
  static TaskPageAppBarWidgetDimens taskPageAppBarWidget = TaskPageAppBarWidgetDimens();
  static SubTaskWidgetDimens subTaskWidget = SubTaskWidgetDimens();
  static HomeScreenDimens homeScreen = HomeScreenDimens();
  static CompressedTaskListDimens compressedTaskList = CompressedTaskListDimens();
  static QuestionWidgetDimens questionWidget = QuestionWidgetDimens();
  static NextStageButtonDimens nextStageButton = NextStageButtonDimens();
  static QuestionListPageAppBarDimens questionListPageAppBar = QuestionListPageAppBarDimens();
  static TaskPageDimens taskPage = TaskPageDimens();
  static LoadImageWithCacheDimens loadImageWithCache = LoadImageWithCacheDimens();
  static AppBarDimens appBar = AppBarDimens();
  static StepTimeLineDimens stepTimeLine = StepTimeLineDimens();
  static StepSliderDimens stepSlider = StepSliderDimens();
  static ExpansionContentDimens expansionContent = ExpansionContentDimens();
}

class StepSliderDimens {
  final sliderContainerMargin = EdgeInsetsDirectional.symmetric(horizontal: 10.0);
  final sliderContainerPadding = EdgeInsetsDirectional.only(top: 10);
  final contentHeightPaddingPercentage = 0.1;
  final contentLeftPaddingPercentage = 0.1;
  final contentRightPaddingPercentage = 0.01;
  final contentBottomPaddingPercentage = 0.05;
  final emptySpaceHeightPercentage = 0.1;
  final spaceBetweenTitleAndNoOfTasksPercentage = 0.07;
  final spaceBetweenNoOfTasksAndContinueButtonPercentage = 0.03;
  final avatarRightPaddingPercentage = 0.05;
  final pendingSliderBorder = 4.0;
  final doneSliderBorder = 2.0;
  final buttonRadius = 30.0;
  final progressBarRadius = 10.0;
  final minFontSizeForTextOverFlow = 16.0;
}

class StepTimeLineDimens {
  final containerBorderRadius = BorderRadius.all(Radius.circular(30));
  final containerPadding = const EdgeInsetsDirectional.only(start: 25, end: 25);
  final currentStepOuterCirclePadding = const EdgeInsetsDirectional.all(2);
  final currentStepInnerCirclePadding = const EdgeInsetsDirectional.all(8);
  final double doneEndConnectorThickness = 3;
  final double doneEndConnectorIndent = 10;
}

class AppBarDimens {
  final toolbarHeight = 60.0;
  final titleSpacing = 5.0;
  final logoHeight = 60.0;
}

class LoadImageWithCacheDimens {
  final imageCouldNotLoadFontSize = 22.0;
  final imageLoadingIndicatorSize = {"width": 60.0, "height": 60.0};
}

class TaskPageDimens {
  final textOnlyListViewPadding = EdgeInsetsDirectional.only(top: 25, start: 30, end: 30, bottom: 20);
  final blocksAppBarWidgetHeight = 70.0;
  final textOnlyScaffoldBorder = BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );
}

class QuestionListPageAppBarDimens {
  final height = 56.0;
  final fontSize = 20.0;
}

class NextStageButtonDimens {
  final radius = 5.0;
  final padding = EdgeInsets.all(8.0);
  final defaultHeight = 53.0;
}

class QuestionWidgetDimens {
  final descriptionPadding = EdgeInsetsDirectional.only(start: 23, end: 10, bottom: 10);
  final listTilePadding = EdgeInsetsDirectional.only(bottom: 15);
  final Map<String, double> buildQuestionsButtonStyle = {
    "pixels_smaller_than_screen_width": 26,
    "height": 55,
  };
  final singleTextOptionPadding = const EdgeInsetsDirectional.only(start: 15, end: 15, top: 10);

  // Question Info...................................................
  final infoButtonBorderRadius = BorderRadius.circular(7);
  final infoInsideDialogButtonsRadius = BorderRadius.circular(5);
  final infoBottomSheetPadding = const EdgeInsetsDirectional.fromSTEB(20, 25, 20, 90);
  final infoButtonsPadding = const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10);
  final infoButtonContainerMargin = const EdgeInsetsDirectional.only(start: 20);
  final infoButtonContainerPadding = const EdgeInsetsDirectional.all(12);
}

class CompressedTaskListDimens {
  final double timeLineItemExtend = 70;
  final padding = const EdgeInsetsDirectional.only(start: 20, top: 30, end: 25, bottom: 10);
  final contentPadding = const EdgeInsetsDirectional.only(start: 10);
  final double contentRadius = 10;
  final timelineContainerPadding = EdgeInsetsDirectional.only(start: 20, end: 20, top: 25);
  final timelineNodePosition = 0.009;
  final contentLeftMargin = EdgeInsetsDirectional.only(start: 20, bottom: 0);
  final timelineIndicatorDimens = 8.0;
}

class HomeScreenDimens {
  // Home page
  final buttonRadius = 30.0;
  final bodyBorderRadius = 30.0;
  final placeHolderCompressedTaskListHeightRatio = 2.8;
  final placeHolderCarouselSliderHeightRatio = 3.2;
  final placeHolderCarouselSliderContainerPadding = EdgeInsetsDirectional.only(top: 20);
  final placeHolderStepSliderBorderRadius = 20.0;
  final placeHolderCarouselHeightRatio = 4;
  final inProgressTextPadding = EdgeInsetsDirectional.only(start: 20, top: 35, bottom: 10);
  final currentStepIndicatorPadding = EdgeInsetsDirectional.only(top: 30, start: 15,);

  // Home page - shimmering place holders
  final StepTimelineProgressBarDistance = 25.0;
  final progressBarCompressedTaskListDistance = 10.0;
  final compressedTaskListBorderRadius = 15.0;

  // Question description.............................................
  final questionsStepDescMargin = const EdgeInsetsDirectional.only(start: 30, end: 30, top: 12, bottom: 25);
  final questionsStepDescPadding = const EdgeInsetsDirectional.all(20);
}

class ExpansionContentDimens {
  final padding = EdgeInsetsDirectional.only(top: 5);
  final deadlineContainerPadding = EdgeInsetsDirectional.only(start: 10, top: 10, end: 15);
  final deadlineContentPadding = EdgeInsetsDirectional.all(10);
}

class SubTaskWidgetDimens {
  final listTilePadding = EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5);
  final expansionTileBorderRadius = BorderRadius.circular(16);
  final expansionPadding = EdgeInsetsDirectional.symmetric(horizontal: 20);
}

class TaskPageAppBarWidgetDimens {
  final doneUndoneButtonHeight = 25.0;
  final doneUndoneButtonWidth = 25.0;
  final doneUndoneButtonBorderRadius = 7.0;
  final doneButtonPadding = const EdgeInsetsDirectional.only(end: 20, start: 20, top: 10);
}

class TaskListTimeLineDimens {
  final contentPadding = const EdgeInsetsDirectional.all(16.0);
  final contentContainerPadding = const EdgeInsetsDirectional.only(start: 20, top: 15, end: 20);
  final contentContainerBorderRadius = const BorderRadius.all(Radius.circular(16.0));
  final contentDeadlineTopPadding = EdgeInsetsDirectional.only(top: 20);
  final contentDeadlineBorderRadius = BorderRadius.all(Radius.circular(9));
  final doneBadgeFontSize = 13.0;
  final doneBadgeBorderRadius = 5.0;
  final doneBadgeHeight = 30.0;
  final doneBadgeWidth = 60.0;
  final deadlineContainerHeight = 10.0;
  final deadlineBorderWidth = 1.0;
  final containerMinHeight = 120.0;
}

class TaskListDimens {
  final progressBarRadius = 10.0;
  final progressBarPadding = EdgeInsetsDirectional.only(end: 0, bottom: 15);
  final draggableScrollableSheetRadius = 25.0;
  final backButton = const EdgeInsetsDirectional.only(start: 20.0);
  final taskProgressBarPadding = EdgeInsetsDirectional.only(top: 50, bottom: 0);
  final numberOfTasksPadding = EdgeInsetsDirectional.only(start: 10, bottom: 5);
  final distanceFromAppBar = 20.0;
}