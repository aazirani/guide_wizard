import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/questions/questions_list_page.dart';
import 'package:guide_wizard/ui/tasklist/tasklist.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class StepContinueButton extends StatefulWidget {
  final int step_index;
  const StepContinueButton({Key? key, required this.step_index}) : super(key: key);

  @override
  State<StepContinueButton> createState() => _StepContinueButtonState();
}

class _StepContinueButtonState extends State<StepContinueButton> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 3.5,
        ),
        child: TextButton(
          style: _buildButtonStyle(),
          onPressed: () async {
            if (_dataStore
                .isFirstStep(_dataStore.getStepByIndex(widget.step_index).id)) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionsListPage(
                            stepId: _dataStore.getStepByIndex(widget.step_index).id,
                          )));
              DataLoadHandler().loadDataAndCheckForUpdate();
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskList(
                            step: _dataStore.getStepByIndex(widget.step_index),
                          )));
            }
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _technicalNameWithTranslationsStore
                      .getTranslationByTechnicalName(LangKeys.continueKey),
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
                SizedBox(width: 1),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.primaryColor,
                  size: 16,
                )
              ]),
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(context.continueButtonColor),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => context.continueOverlayColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.stepSlider.buttonRadius),
            side: BorderSide(color: context.primaryColor)),
      ),
    );
  }
}