import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:provider/provider.dart';

class InfoStepDescription extends StatefulWidget {
  const InfoStepDescription({Key? key}) : super(key: key);

  @override
  State<InfoStepDescription> createState() => _InfoStepDescriptionState();
}

class _InfoStepDescriptionState extends State<InfoStepDescription> {
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: Dimens.homeScreen.inProgressTextPadding,
              child: Text(
                  _technicalNameWithTranslationsStore
                      .getTranslationByTechnicalName(LangKeys.description),
                  style: Theme.of(context).textTheme.titleSmall)),
          Flexible(
            child: Container(
              margin: Dimens.homeScreen.questionsStepDescMargin,
              padding: Dimens.homeScreen.questionsStepDescPadding,
              decoration: BoxDecoration(
                color: context.containerColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.compressedTaskList.contentRadius)),
              ),
              child: RawScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                            _technicalNameWithTranslationsStore.getTranslation(
                                _dataStore
                                    .getStepById(
                                        _appSettingsStore.currentStepId)
                                    .description),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}