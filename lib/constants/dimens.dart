import 'package:flutter/material.dart';

class Dimens {
  Dimens._();

  //number of steps
  static const int stepNo = 4;
  //for all screens
  static const double horizontal_padding = 12.0;
  static const double vertical_padding = 12.0;
  //tasklist page
  static const back_button = const EdgeInsets.only(left: 20.0);
  static const taskProgressBarPadding = EdgeInsets.only(top: 50, bottom: 0);
  static const numberOfTasksPadding = EdgeInsets.only(left: 10, bottom: 5);
  static const contentPadding = const EdgeInsets.all(16.0);
  static const contentContainerPadding =
      const EdgeInsets.only(left: 20, top: 10);
  static const contentContainerBorderRadius =
      const BorderRadius.all(Radius.circular(16.0));
  static const contentDeadlineTopPadding = EdgeInsets.only(top: 20);
  static const contentDeadlineBorderRadius =
      BorderRadius.all(Radius.circular(20));
  //for Home Screen - step timeline
  static const stepTimelineContainerBorderRadius =
      BorderRadius.all(Radius.circular(30));
  static const stepTimelineContainerPadding =
      const EdgeInsets.only(left: 25, right: 25);
  static const stepTimelineCurrentStepOuterCirclePadding =
      const EdgeInsets.all(2);
  static const stepTimelineCurrentStepInnerCirclePadding =
      const EdgeInsets.all(8);
  //for Home screen - Carousel Slider
  static const sliderContainerMargin = EdgeInsets.symmetric(horizontal: 10.0);
  static const sliderContainerPadding = EdgeInsets.only(top: 10);
  static const avatarBoyPadding = EdgeInsets.only(left: 140, bottom: 70);
  static const avatarGirlPadding =
      EdgeInsets.only(left: 200, bottom: 40, top: 20);
  static const stepAvatar = EdgeInsets.only(left: 160, bottom: 40, top: 20);
  //compressed task list
  static const contentLeftMargin = EdgeInsets.only(left: 20);
  //task page appbar widget
  static const doneButtonPadding =
      const EdgeInsets.only(right: 20, left: 10, top: 10);

  //step slider widget
  static const stepSliderprogressBarPadding =
      EdgeInsets.only(right: 10, top: 10);
  static const questionButtonPadding = EdgeInsets.only(bottom: 20, top: 15);
  static const questionDescriptionPadding =
      EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const listTilePadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);
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
  static const expansionDottedLinePadding = EdgeInsets.only(left: 20, top: 5, right: 15,);

  static const expansionPadding = EdgeInsets.symmetric(horizontal: 20);
  static BorderRadiusGeometry expansionTileBorderRadius = BorderRadius.circular(16);
  static BorderRadiusGeometry blockPageAppBarButtonBorderRadius = BorderRadius.circular(10.0);

  static const taskPageTextOnlyListViewPadding = EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 20);
}
