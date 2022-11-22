import 'package:flutter/material.dart';

class Dimens {
  Dimens._();

  //for all screens
  static const double horizontal_padding = 12.0;
  static const double vertical_padding = 12.0;


  static const questionButtonPadding = EdgeInsets.only(bottom: 20, top: 15);
  static const questionDescriptionPadding = EdgeInsets.only(left: 10, right: 10, bottom: 10);
  static const listTilePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const Map<String, double> appBar = {"toolbarHeight" : 80, "titleSpacing" : 10, "logoHeight" : 60,};
  static const Map<String, double> buildQuestionsButtonStyle = {"pixels_smaller_than_screen_width" : 26, "height" : 55,};
  static const expansionContentPadding = EdgeInsets.only(top: 5);
  static const expansionDottedLinePadding = EdgeInsets.only(left: 20, top: 5, right: 15,);

  static const expansionPadding = EdgeInsets.symmetric(horizontal: 20);
  static BorderRadiusGeometry expansionTileBorderRadius = BorderRadius.circular(16);
  static BorderRadiusGeometry blockPageAppBarButtonBorderRadius = BorderRadius.circular(10.0);

}