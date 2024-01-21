import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:guide_wizard/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';

class TaskStepDescription extends StatelessWidget {
  const TaskStepDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: Dimens.homeScreen.inProgressTextPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _technicalNameWithTranslationsStore
                    .getTranslationByTechnicalName(LangKeys.in_progress),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
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