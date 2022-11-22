import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';

abstract class SubBlock{
  late String title, markdown;
  // late GlobalKey<AppExpansionTileState> expansionKey;
  SubBlock({
    required this.title,
    // required this.markdown,
    // required this.expansionKey
  });
}