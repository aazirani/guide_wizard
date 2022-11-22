import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';

class SubBlockModel{
  String title;
  late String markdown; //TODO implement
  late GlobalKey<AppExpansionTileState> globalKey;
  bool expanded;

  SubBlockModel({
    required this.title,
    required this.expanded,
  }){
    globalKey = GlobalKey<AppExpansionTileState>();
  }
}