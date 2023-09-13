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
  final sliderContainerMargin = EdgeInsets.symmetric(horizontal: 10.0);
  final sliderContainerPadding = EdgeInsets.only(top: 10);
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
  // For Home Screen - step timeline
  final containerBorderRadius = BorderRadius.all(Radius.circular(30));
  final containerPadding = const EdgeInsets.only(left: 25, right: 25);
  final currentStepOuterCirclePadding = const EdgeInsets.all(2);
  final currentStepInnerCirclePadding = const EdgeInsets.all(8);
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
  final textOnlyListViewPadding = EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 20);
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
  final descriptionPadding = EdgeInsets.only(left: 23, right: 10, bottom: 10);
  final listTilePadding = EdgeInsets.only(bottom: 15);
  final Map<String, double> buildQuestionsButtonStyle = {
    "pixels_smaller_than_screen_width": 26,
    "height": 55,
  };
  final singleTextOptionPadding = const EdgeInsets.only(left: 15, right: 15, top: 10);

  // Question Info...................................................
  final infoButtonBorderRadius = BorderRadius.circular(7);
  final infoInsideDialogButtonsRadius = BorderRadius.circular(5);
  final infoBottomSheetPadding = const EdgeInsets.fromLTRB(20, 25, 20, 90);
  final infoButtonsPadding = const EdgeInsets.only(left: 10, right: 10, bottom: 10);
  final infoButtonContainerMargin = const EdgeInsets.only(left: 20);
  final infoButtonContainerPadding = const EdgeInsets.all(12);
}

class CompressedTaskListDimens {
  final double timeLineItemExtend = 70;
  final padding = const EdgeInsets.only(left: 20, top: 10, right: 25, bottom: 10);
  final contentPadding = const EdgeInsets.only(left: 10);
  final double contentRadius = 10;
  final timelineContainerPadding = EdgeInsets.only(left: 20, right: 20, top: 25);
  final timelineNodePosition = 0.009;
  final contentLeftMargin = EdgeInsets.only(left: 20, bottom: 10);
  final timelineIndicatorDimens = 8.0;
}

class HomeScreenDimens {
  // Home page
  final buttonRadius = 30.0;
  final bodyBorderRadius = 30.0;
  final placeHolderCompressedTaskListHeightRatio = 2.8;
  final placeHolderCarouselSliderHeightRatio = 3.2;
  final placeHolderCarouselSliderContainerPadding = EdgeInsets.only(top: 20);
  final placeHolderStepSliderBorderRadius = 20.0;
  final placeHolderCarouselHeightRatio = 4;
  final inProgressTextPadding = EdgeInsets.only(left: 20, top: 35, bottom: 10);
  final currentStepIndicatorPadding = EdgeInsets.only(top: 30, left: 15,);

  // Home page - shimmering place holders
  final StepTimelineProgressBarDistance = 25.0;
  final progressBarCompressedTaskListDistance = 10.0;
  final compressedTaskListBorderRadius = 15.0;

  // Question description.............................................
  final questionsStepDescMargin = const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 25);
  final questionsStepDescPadding = const EdgeInsets.all(20);
}

class ExpansionContentDimens {
  final padding = EdgeInsets.only(top: 5);
  final deadlineContainerPadding = EdgeInsets.only(left: 10, top: 10, right: 15);
  final deadlineContentPadding = EdgeInsets.all(10);
}

class SubTaskWidgetDimens {
  final listTilePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  final expansionTileBorderRadius = BorderRadius.circular(16);
  final expansionPadding = EdgeInsets.symmetric(horizontal: 20);
}

class TaskPageAppBarWidgetDimens {
  final doneUndoneButtonHeight = 25.0;
  final doneUndoneButtonWidth = 25.0;
  final doneUndoneButtonBorderRadius = 7.0;
  final doneButtonPadding = const EdgeInsets.only(right: 20, left: 20, top: 10);
}

class TaskListTimeLineDimens {
  final contentPadding = const EdgeInsets.all(16.0);
  final contentContainerPadding = const EdgeInsets.only(left: 20, top: 15, right: 20);
  final contentContainerBorderRadius = const BorderRadius.all(Radius.circular(16.0));
  final contentDeadlineTopPadding = EdgeInsets.only(top: 20);
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
  final progressBarPadding = EdgeInsets.only(right: 0, bottom: 15);
  final draggableScrollableSheetRadius = 25.0;
  final backButton = const EdgeInsets.only(left: 20.0);
  final taskProgressBarPadding = EdgeInsets.only(top: 50, bottom: 0);
  final numberOfTasksPadding = EdgeInsets.only(left: 10, bottom: 5);
  final distanceFromAppBar = 20.0;
}