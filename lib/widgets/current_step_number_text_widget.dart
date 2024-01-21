import 'package:flutter/material.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:provider/provider.dart';

class CurrentStepNumberTextWidget extends StatelessWidget {
  const CurrentStepNumberTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataStore _dataStore = Provider.of<DataStore>(context);
    AppSettingsStore _appSettingsStore = Provider.of<AppSettingsStore>(context);
    
    return Text(
        "${_dataStore.getAllSteps.indexWhere((step) => step.id == _appSettingsStore.currentStepId) + 1}/${_dataStore.getAllSteps.length}",
        style: Theme.of(context).textTheme.titleSmall);
  }
}