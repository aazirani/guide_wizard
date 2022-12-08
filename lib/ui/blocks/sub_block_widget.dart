import 'package:flutter/material.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/rendering.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:boilerplate/ui/blocks/expansion_content.dart';
import 'package:boilerplate/models/block/sub_block.dart';

class SubBlock extends StatefulWidget {
  int index;
  List<SubBlockModel> subBlockModelsList;
  RenderParametersManager renderManager;
  SubBlock({Key? key,required this.index , required this.subBlockModelsList, required this.renderManager,}) : super(key: key);

  @override
  State<SubBlock> createState() => SubBlockState();
}

class SubBlockState extends State<SubBlock> with AutomaticKeepAliveClientMixin{


  void _runAtExpanding(){
    setState(() {
      widget.subBlockModelsList.map((element){
        if(element.expanded){
          element.rebuildGlobalKey();
          element.expanded = false;
        }
      });

      widget.subBlockModelsList[widget.index].toggleExpanded();
    });
  }

  Widget _getExpansionContent() {
    return ExpansionContent(renderManager: widget.renderManager);
  }

  Widget _buildExpansionTile({required GlobalKey<AppExpansionTileState> key}) {
    return Padding(
      padding: Dimens.expansionPadding,
      child: ClipRRect(
        borderRadius: Dimens.expansionTileBorderRadius,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.expansionTileBorderRadius,
          ),
          child: ListTileTheme(
            shape: RoundedRectangleBorder(
              borderRadius: Dimens.expansionTileBorderRadius,
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
                  _runAtExpanding();
                }
              }),
              maintainState: true,
              textColor: AppColors.main_color,
              iconColor: AppColors.main_color,
              title: Text(widget.subBlockModelsList[widget.index].title,),
              key: widget.subBlockModelsList[widget.index].globalKey,
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
    return _buildExpansionTile(key: widget.subBlockModelsList[widget.index].globalKey);
  }

  @override
  bool get wantKeepAlive => true;
}
