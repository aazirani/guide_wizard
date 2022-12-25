import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';

class SubTaskWidgetState{
  late GlobalKey<AppExpansionTileState> globalKey;
  late bool expanded;

  SubBlockModel(){
    _buildGlobalKey();
    expanded = false;
  }

  void _buildGlobalKey() {
    globalKey = GlobalKey<AppExpansionTileState>();
  }

  void rebuildGlobalKey() {
    _buildGlobalKey();
  }

  void setExpanded(bool value) {
    expanded = value;
  }

  void toggleExpanded() {
    expanded = !expanded;
  }
}