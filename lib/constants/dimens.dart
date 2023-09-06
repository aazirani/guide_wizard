import 'package:flutter/material.dart';

class Dimens {
  Dimens._();

  // tasklist page
  static const double taskListProgressBarRadius = 10;
  static const taskListProgressBarPadding = EdgeInsets.only(right: 0, bottom: 15);
  static const double draggableScrollableSheetRadius = 25;
  static const back_button = const EdgeInsets.only(left: 20.0);
  static const taskProgressBarPadding = EdgeInsets.only(top: 50, bottom: 0);
  static const numberOfTasksPadding = EdgeInsets.only(left: 10, bottom: 5);
  static const contentPadding = const EdgeInsets.all(16.0);
  static const contentContainerPadding = const EdgeInsets.only(left: 20, top: 15, right: 20);
  static const contentContainerBorderRadius = const BorderRadius.all(Radius.circular(16.0));
  static const contentDeadlineTopPadding = EdgeInsets.only(top: 20);
  static const contentDeadlineBorderRadius = BorderRadius.all(Radius.circular(9));
  static const double taskListTimeLineContainerMinHeight = 120;
  static const taskListDistanceFromAppBar = 20.0;
  static const doneBadgeFontSize = 13.0;
  static const doneBadgeBorderRadius = 5.0;
  static const doneBadgeHeight = 30.0;
  static const doneBadgeWidth = 60.0;
  static const deadlineContainerHeight = 10.0;
  static const deadlineBorderWidth = 1.0;
  // Subtask: ------------------------------------------------------------
  static const listTilePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const deadlineContainerPadding = EdgeInsets.only(left: 10, top: 10, right: 15);
  static const deadlineContentPadding = EdgeInsets.all(10);

  // for Home Screen - step timeline
  static const stepTimelineContainerBorderRadius = BorderRadius.all(Radius.circular(30));
  static const stepTimelineContainerPadding = const EdgeInsets.only(left: 25, right: 25);
  static const stepTimelineCurrentStepOuterCirclePadding = const EdgeInsets.all(2);
  static const stepTimelineCurrentStepInnerCirclePadding = const EdgeInsets.all(8);
  static const double doneEndConnectorThickness = 3;
  static const double doneEndConnectorIndent = 10;

  // for Home screen - Carousel Slider
  static const sliderContainerMargin = EdgeInsets.symmetric(horizontal: 10.0);
  static const sliderContainerPadding = EdgeInsets.only(top: 10);
  static const contentHeightPaddingPercentage = 0.1;
  static const contentLeftPaddingPercentage = 0.1;
  static const contentRightPaddingPercentage = 0.01;
  static const contentBottomPaddingPercentage = 0.05;
  static const emptySpaceHeightPercentage = 0.1;
  static const spaceBetweenTitleAndNoOfTasksPercentage = 0.07;
  static const spaceBetweenNoOfTasksAndContinueButtonPercentage = 0.03;
  static const avatarRightPaddingPercentage = 0.05;

  // task page appbar widget
  static const doneButtonPadding = const EdgeInsets.only(right: 20, left: 20, top: 10);

  // step slider widget
  static const double pendingSliderBorder = 4;
  static const double doneSliderBorder = 2;
  static const double buttonRadius = 30;
  static const double progressBarRadius = 10;
  static const double minFontSizeForTextOverFlow = 16;

  // compressed taskList.........................................................
  static const double compressedTaskListTimeLineItemExtend = 70;
  static const compressedTaskListPadding = const EdgeInsets.only(left: 20, top: 10, right: 25, bottom: 10);
  static const compressedTaskListContentPadding = const EdgeInsets.only(left: 10);
  static const double contentRadius = 10;
  static const timelineContainerPadding = EdgeInsets.only(left: 20, right: 20, top: 25);
  static const timelineNodePosition = 0.009;
  static const contentLeftMargin = EdgeInsets.only(left: 20, bottom: 10);
  static const timelineIndicatorDimens = 8.0;

  // Question page...................................................
  static const questionDescriptionPadding = EdgeInsets.only(left: 23, right: 10, bottom: 10);
  static const questionWidgetListTilePadding = EdgeInsets.only(bottom: 15);
  static const Map<String, double> appBar = {
    "toolbarHeight": 60,
    "titleSpacing": 5,
    "logoHeight": 60,
  };
  static const Map<String, double> buildQuestionsButtonStyle = {
    "pixels_smaller_than_screen_width": 26,
    "height": 55,
  };
  static const expansionContentPadding = EdgeInsets.only(top: 5);

  static const singleTextOptionPadding = const EdgeInsets.only(left: 15, right: 15, top: 10);

  static const expansionPadding = EdgeInsets.symmetric(horizontal: 20);
  static BorderRadiusGeometry expansionTileBorderRadius = BorderRadius.circular(16);

  static const taskPageTextOnlyListViewPadding = EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 20);
  static const blocksAppBarWidgetHeight = 70.0;
  static const taskPageTextOnlyScaffoldBorder = BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  // Question List Page AppBar
  static const questionListPageAppBarHeight = 56.0;
  static const questionListPageAppBarFontSize = 20.0;

  // Home page
  static const homeBodyBorderRadius = 30.0;
  static const placeHolderCompressedTaskListHeightRatio = 2.8;
  static const placeHolderCarouselSliderHeightRatio = 3.2;
  static const placeHolderCarouselSliderContainerPadding = EdgeInsets.only(top: 20);
  static const placeHolderStepSliderBorderRadius = 20.0;
  static const placeHolderCarouselHeightRatio = 4;
  static const inProgressTextPadding = EdgeInsets.only(left: 20, top: 35, bottom: 10);
  static const currentStepIndicatorPadding = EdgeInsets.only(top: 30, left: 15,);

  //Task page appBar widget
  static const doneUndoneButtonHeight = 25.0;
  static const doneUndoneButtonWidth = 25.0;
  static const doneUndoneButtonBorderRadius = 7.0;

  // Question Info...................................................
  static final infoButtonBorderRadius = BorderRadius.circular(7);
  static final infoInsideDialogButtonsRadius = BorderRadius.circular(5);
  static const infoBottomSheetPadding = const EdgeInsets.fromLTRB(20, 25, 20, 90);
  static const infoButtonsPadding = const EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const infoButtonContainerMargin = const EdgeInsets.only(left: 20);
  static const infoButtonContainerPadding = const EdgeInsets.all(12);

  // Question description.............................................
  static const questionsStepDescMargin = const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 25);
  static const questionsStepDescPadding = const EdgeInsets.all(20);

  // Image Handler (Load Image With Cache)
  static double imageCouldNotLoadFontSize = 22;
  static const imageLoadingIndicatorSize = {"width": 60.0, "height": 60.0};

  // home page - shimmering place holders
  static const StepTimelineProgressBarDistance = 25.0;
  static const progressBarCompressedTaskListDistance = 10.0;
  static const compressedTaskListBorderRadius = 15.0;

  // Next Stage Button
  static const nextStageButtonRadius = 5.0;
  static const nextStageButtonPadding = EdgeInsets.all(8.0);
  static const nextStageDefaultHeight = 53.0;
}
