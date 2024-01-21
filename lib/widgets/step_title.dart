import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';

class StepTitle extends StatelessWidget {
  final int step_index;
  const StepTitle({Key? key, required this.step_index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataStore _dataStore = Provider.of<DataStore>(context);
    TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    ;
    return AutoSizeText(
      "${_technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepByIndex(step_index).name)}",
      style: Theme.of(context).textTheme.titleMedium!,
      maxLines: 3,
      softWrap: true,
      wrapWords: true,
      minFontSize: Dimens.stepSlider.minFontSizeForTextOverFlow,
    );
  }
}