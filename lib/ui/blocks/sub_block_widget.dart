import 'package:flutter/material.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/rendering.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:boilerplate/ui/blocks/expansion_content.dart';
import 'package:boilerplate/models/block/sub_block.dart';

class SubBlock extends StatefulWidget {
  SubBlockModel subBlockModel;
  RenderParametersManager renderManager;
  SubBlock({Key? key, required this.subBlockModel, required this.renderManager}) : super(key: key);

  @override
  State<SubBlock> createState() => SubBlockState();
}

class SubBlockState extends State<SubBlock> with AutomaticKeepAliveClientMixin{
  Widget _getExpansionContent() {
    return ExpansionContent(renderManager: widget.renderManager);
  }

  Widget _buildExpansionTile({required GlobalKey<AppExpansionTileState> key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // side: BorderSide(color: AppColors.main_color)
          ),
          child: ListTileTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.main_color, width: 2),
            ),
            tileColor: AppColors.button_background_color,
            textColor: AppColors.main_color,
            contentPadding: Dimens.listTilePadding,
            dense: false,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: AppExpansionTile(
              onExpansionChanged: ((isNewState) {
                if(isNewState){
                  setState(() {
                    // widget.subBlockModel.expanded=!widget.subBlockModel.expanded;
                  });
                }
              }),
              // initiallyExpanded: widget.subBlockModel.expanded,
              maintainState: true,
              textColor: AppColors.main_color,
              iconColor: AppColors.main_color,
              title: Text("Title",),
              key: key,
              children: <Widget>[
                _getExpansionContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildExpansionTile(key: widget.subBlockModel.globalKey);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
