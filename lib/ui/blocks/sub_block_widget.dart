import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/ui/blocks/expansion_content.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:boilerplate/models/sub_task_widget_state/sub_task_widget_state.dart';

class SubBlock extends StatefulWidget {
  int index;
  List<SubTask> subTasks;
  RenderParametersManager renderManager;
  SubBlock({Key? key,required this.index , required this.subTasks, required this.renderManager,}) : super(key: key);

  @override
  State<SubBlock> createState() => SubBlockState();
}

class SubBlockState extends State<SubBlock> with AutomaticKeepAliveClientMixin{

  late List<SubTaskWidgetState> subTaskWidgetsState;

  @override
  void initState() {
    super.initState();

    subTaskWidgetsState = [];
    for(int i=0; i<widget.subTasks.length; i++){
      subTaskWidgetsState.add(SubTaskWidgetState());
    }
  }
  void _runAtExpanding(){
    setState(() {
      subTaskWidgetsState.map((element){
        if(element.expanded){
          element.rebuildGlobalKey();
          element.expanded = false;
        }
      });

      subTaskWidgetsState[widget.index].toggleExpanded();
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
              title: Text(widget.subTasks[widget.index].title.technical_name,),
              key: subTaskWidgetsState[widget.index].globalKey,
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
  Widget build(BuildContext context) {
    super.build(context);
    return _buildExpansionTile(key: subTaskWidgetsState[widget.index].globalKey);
  }

  @override
  bool get wantKeepAlive => true;
}
