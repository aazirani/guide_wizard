import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/expansion_content.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class SubTaskWidget extends StatefulWidget {
  int index;
  List<SubTask> subTasks;
  RenderParametersManager renderManager;
  SubTaskWidget({
    Key? key,
    required this.index,
    required this.subTasks,
    required this.renderManager,
  }) : super(key: key);

  @override
  State<SubTaskWidget> createState() => SubTaskWidgetState();
}

class SubTaskWidgetState extends State<SubTaskWidget>
    with AutomaticKeepAliveClientMixin {
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  void _runAtExpanding() {
    setState(() {
      widget.subTasks.map((element) {
        if (element.expanded) {
          element.rebuildGlobalKey();
          element.expanded = false;
        }
      });
      widget.subTasks[widget.index].toggleExpanded();
    });
  }
    

    Widget _buildExpansionContent() {
    
    var markdown_id = widget.subTasks[widget.index].markdown.id;
      return ExpansionContent(renderManager: widget.renderManager, markdown: _technicalNameWithTranslationsStore
            .getTechnicalNames(markdown_id)!,);
    }

    Widget _buildAppExpansionTileWidget() {
    var sub_task_title_id = widget.subTasks[widget.index].title.id;
      return AppExpansionTile(
        onExpansionChanged: ((isNewState) {
          if (isNewState) {
            _runAtExpanding();
          }
        }),
        maintainState: true,
        textColor: AppColors.main_color,
        iconColor: AppColors.main_color,
        title: ScrollingOverflowText(text: _technicalNameWithTranslationsStore.getTechnicalNames(sub_task_title_id)!, textStyle: TextStyle(fontSize: 19),),
        key: widget.subTasks[widget.index].globalKey,
        children: <Widget>[
          _buildExpansionContent(),
        ],
      );
    }

  Widget _buildAppExpansionTileWidgetWithCustomTheme() {
    return ListTileTheme(
      selectedColor: AppColors.main_color,
      shape: RoundedRectangleBorder(
        borderRadius: Dimens.expansionTileBorderRadius,
        side: BorderSide(color: AppColors.main_color, width: 1),
      ),
      // tileColor: AppColors.button_background_color,
      // textColor: AppColors.main_color,
      contentPadding: Dimens.listTilePadding,
      dense: false,
      horizontalTitleGap: 0.0,
      minLeadingWidth: 0,
      child: _buildAppExpansionTileWidget(),
    );
  }

  Widget _buildRoundedExpansionTile() {
    return ClipRRect(
      borderRadius: Dimens.expansionTileBorderRadius,
      child: Card(
          elevation: 1,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: Dimens.expansionTileBorderRadius,
          ),
          child: _buildAppExpansionTileWidgetWithCustomTheme()),
    );
  }

  Widget _buildExpansionTile({required GlobalKey<AppExpansionTileState> key}) {
    return Padding(
      padding: Dimens.expansionPadding,
      child: _buildRoundedExpansionTile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildExpansionTile(key: widget.subTasks[widget.index].globalKey);
  }

  @override
  bool get wantKeepAlive => true;
}
