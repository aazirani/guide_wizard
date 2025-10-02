import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:provider/provider.dart';

class TaskStepDescription extends StatelessWidget {
  const TaskStepDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
    return Flexible(
      child: Column(
        children: [
          Flexible(
            child: Padding(
              padding: Dimens.compressedTaskList.padding,
              child: CompressedTaskListTimeline(),
            ),
          ),
        ],
      ),
    );
  }
}