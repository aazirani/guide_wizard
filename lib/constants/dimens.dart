import 'package:flutter/material.dart';

class Dimens {
  Dimens._();

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

  static const questionButtonPadding = EdgeInsets.only(bottom: 20, top: 15);
  static const questionDescriptionPadding =
      EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const listTilePadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const Map<String, double> appBar = {
    "toolbarHeight": 70,
    "titleSpacing": 5,
    "logoHeight": 60,
  };
  static const Map<String, double> buildQuestionsButtonStyle = {
    "pixels_smaller_than_screen_width": 26,
    "height": 55,
  };
}
