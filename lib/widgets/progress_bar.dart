import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class ProgressBar extends StatefulWidget {
  final int step_index;
  const ProgressBar({Key? key, required this.step_index}) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late DataStore _dataStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.3,
      child: Container(
        child: Observer(
          builder: (_) => ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.stepSlider.progressBarRadius)),
            child: LinearProgressIndicator(
                value: _dataStore
                        .getDoneTasks(_dataStore.getStepByIndex(widget.step_index).id)
                        .length /
                    _dataStore.getStepByIndex(widget.step_index).tasks.length,
                backgroundColor: context.lightBackgroundColor,
                valueColor: AlwaysStoppedAnimation(context.secondaryColor)),
          ),
        ),
      ),
    );
  }
}