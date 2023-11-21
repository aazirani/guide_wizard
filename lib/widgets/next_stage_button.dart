import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/home/home.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NextStageButton extends StatefulWidget {
  double height = Dimens.nextStageButton.defaultHeight;

  NextStageButton({Key? key})
      : super(key: key);

  @override
  State<NextStageButton> createState() => _NextStageButtonState();
}

class _NextStageButtonState extends State<NextStageButton> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  ButtonState buttonState = ButtonState.idle;

  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return newVersionButton(context);
  }

  Widget newVersionButton(BuildContext context) {
    return ProgressButton(
      minWidth: _getScreenWidth() - 20,
      maxWidth: _getScreenWidth() - 20,
      height: widget.height,
      radius: Dimens.nextStageButton.radius,
      stateWidgets: {
        ButtonState.idle: Text(
          _dataStore.isFirstStep(_appSettingsStore.currentStepId)
              ? _technicalNameWithTranslationsStore
                  .getTranslationByTechnicalName(LangKeys.next_step_button_text)
              : _technicalNameWithTranslationsStore
                  .getTranslationByTechnicalName(LangKeys.update_steps),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.lightBackgroundColor, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          _technicalNameWithTranslationsStore
              .getTranslationByTechnicalName(LangKeys.getting_updates),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.lightBackgroundColor, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          _technicalNameWithTranslationsStore.getTranslationByTechnicalName(
              LangKeys.next_stage_check_internet),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.lightBackgroundColor, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          _technicalNameWithTranslationsStore
              .getTranslationByTechnicalName(LangKeys.update_finished),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.lightBackgroundColor, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: context.secondaryContainerColor,
        ButtonState.loading: context.secondaryContainerColor,
        ButtonState.fail: context.errorColor,
        ButtonState.success: context.secondaryContainerColor,
      },
      minWidthStates: [],
      onPressed: (){
        onTapFunction(context);
      },
      state: buttonState,
      padding: Dimens.nextStageButton.padding,
    );
  }

  void onTapFunction(BuildContext context) async {
    setButtonState(ButtonState.loading);

    if (!await DataLoadHandler().hasInternet()) {
      setButtonState(ButtonState.fail);
      Future.delayed(Duration(milliseconds: 2000), () {
        setButtonState(ButtonState.idle);
      });
      return;
    }

    await updateIfAnswersHasChanged();

    /*
    _appSettingsStore.setCurrentStepId(
        _dataStore.getAllSteps.reduce((curr, next) => curr.order < next.order ? curr : next).id
    );
     */

    setButtonState(ButtonState.success);

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);
    });

    if (_dataStore.stepIsDone(_dataStore.getStepByIndex(0).id)) {
      _appSettingsStore.setCurrentStepId(_dataStore.getStepByIndex(1).id);
    }
  }

  Future<void> updateIfAnswersHasChanged() async {
    bool answerWasUpdated = await _appSettingsStore.getAnswerWasUpdated() ?? false;
    if (answerWasUpdated) {
      await DataLoadHandler().loadDataAndCheckForUpdate();
    }
  }

  void setButtonState(ButtonState buttonState) {
    setState(() {
      this.buttonState = buttonState;
    });
  }
}
