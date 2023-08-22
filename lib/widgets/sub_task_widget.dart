import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/app_expansiontile.dart';
import 'package:guide_wizard/widgets/expansion_content.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class SubTaskWidget extends StatefulWidget {
  final int index;
  final int taskId;
  final int stepId;
  RenderParametersManager renderManager;
  SubTaskWidget({
    Key? key,
    required this.index,
    required this.taskId,
    required this.renderManager,
    required this.stepId
  }) : super(key: key);

  @override
  State<SubTaskWidget> createState() => SubTaskWidgetState();
}

class SubTaskWidgetState extends State<SubTaskWidget> with AutomaticKeepAliveClientMixin {
  get task => _dataStore.getStepById(widget.stepId).tasks.firstWhere((task) => task.id == widget.taskId);

  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  void _runAtExpanding() {
    setState(() {
      task.subTasks.map((element) {
        if (element.expanded) {
          element.rebuildGlobalKey();
          element.expanded = false;
        }
      });
      task.subTasks[widget.index].toggleExpanded();
    });
  }

  Widget _buildExpansionContent() {
    var markdown_id = task.subTasks[widget.index].markdown;
    return ExpansionContent(
            renderManager: widget.renderManager,
            markdown: _technicalNameWithTranslationsStore.getTranslation(markdown_id)!,
            deadline: _technicalNameWithTranslationsStore.getTranslation(task.subTasks[widget.index].deadline));
  }


  Widget _buildAppExpansionTileWidget() {
    var sub_task_title_id = task.subTasks[widget.index].title;
      return AppExpansionTile(
        onExpansionChanged: ((isNewState) {
          if (isNewState) {
            _runAtExpanding();
          }
        }),
        maintainState: true,
        textColor: AppColors.main_color,
        iconColor: AppColors.main_color,
        title: Text(
          _technicalNameWithTranslationsStore.getTranslation(sub_task_title_id)!,
          style: TextStyle(fontSize: Dimens.subtaskTitleFontSize),
        ),
        key: task.subTasks[widget.index].globalKey,
        children: <Widget>[
          _buildExpansionContent(),
        ],
      );
    }

  Widget _buildAppExpansionTileWidgetWithCustomTheme() {
    return ListTileTheme(
      shape: RoundedRectangleBorder(
        borderRadius: Dimens.expansionTileBorderRadius,
      ),
      tileColor: AppColors.button_background_color,
      textColor: AppColors.main_color,
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
          elevation: 4,
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
    return _buildExpansionTile(key: task.subTasks[widget.index].globalKey);
  }

  @override
  bool get wantKeepAlive => true;
}
