import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';

class SubBlockModel{
  String title;
  late String markdown; //TODO implement
  late GlobalKey<AppExpansionTileState> globalKey;
  late bool expanded;

  SubBlockModel({
    required this.title,
  }){
    _buildGlobalKey();
    expanded = false;
  }

  void _buildGlobalKey(){
    globalKey = GlobalKey<AppExpansionTileState>();
  }

  void rebuildGlobalKey(){
    _buildGlobalKey();
  }

  void setExpanded(bool value){
    expanded = value;
  }

  void toggleExpanded(){
    expanded = !expanded;
  }
}