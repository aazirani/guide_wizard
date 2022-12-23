import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/models/block/sub_block.dart';
import 'package:boilerplate/ui/blocks/sub_block_widget.dart';
import 'package:boilerplate/widgets/blocks_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:render_metrics/render_metrics.dart';

List<SubBlockModel> subBlocks= [
  SubBlockModel(title: "Title",),
  SubBlockModel(title: "Title",),
  SubBlockModel(title: "Title",),
];

class BlockPageTextOnly extends StatefulWidget {

  bool isDone = false;
  BlockPageTextOnly({Key? key}) : super(key: key);

  @override
  State<BlockPageTextOnly> createState() => _BlockPageTextOnlyState();
}

class _BlockPageTextOnlyState extends State<BlockPageTextOnly> {

  RenderParametersManager renderManager = RenderParametersManager<dynamic>();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildScaffoldBody() {
    return SizedBox.expand(
      child: Container(
        color: AppColors.main_color,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),),
              color: AppColors.bright_foreground_color
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: subBlocks.length,
              itemBuilder: (context, i){
                return SubBlock(index: i, subBlockModelsList: subBlocks, renderManager: renderManager, );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(isDone: widget.isDone,) as PreferredSizeWidget?,
      body: _buildScaffoldBody(),
    );
  }
}