import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';

class StepsTextPlaceHolderWidget extends StatelessWidget {
  const StepsTextPlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
    return Text(
        _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.steps),
        style: Theme.of(context).textTheme.titleSmall);
  }
}