import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_laod_handler.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/home/home.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

class NextStageButton extends StatefulWidget {
  double height;
  NextStageButton({this.height = Dimens.nextStageDefaultHeight, Key? key}) : super(key: key);

  @override
  State<NextStageButton> createState() => _NextStageButtonState();
}

class _NextStageButtonState extends State<NextStageButton> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  ButtonState buttonState = ButtonState.idle;
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late StepStore _stepStore;
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
    _stepStore = Provider.of<StepStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
  }


  @override
  Widget build(BuildContext context) {
    return newVersionButton();
  }


  Widget newVersionButton() {
    return ProgressButton(
      minWidth: _getScreenWidth() - 20,
      maxWidth: _getScreenWidth() - 20,
      height: widget.height,
      radius: Dimens.nextStageButtonRadius,
      stateWidgets: {
        ButtonState.idle: Text(
          _appSettingsStore.isFirstStep() ?  _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.next_step_button_text) : _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.update_steps),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.getting_updates),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.next_stage_check_internet),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.update_finished),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: AppColors.nextStepColor,
        ButtonState.loading: AppColors.nextStepColor,
        ButtonState.fail: AppColors.red[100]!,
        ButtonState.success: AppColors.nextStepColor,
      },
      minWidthStates: [],
      onPressed: onTapFunction,
      state: buttonState,
      padding: Dimens.nextStageButtonPadding,
    );
  }

  void onTapFunction() async {
    if(!await DataLoadHandler().hasInternet()) {
      setButtonState(ButtonState.fail);
      Future.delayed(Duration(milliseconds: 2000), (){
        setButtonState(ButtonState.idle);
      });
      return;
    }

    setButtonState(ButtonState.loading);

    await updateIfAnswersHasChanged();

    await _dataStore.getTasks(_stepStore.currentStep);
    await _appSettingsStore.setStepNumber(1);

    setButtonState(ButtonState.success);

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
    });
  }

  Future<void> updateIfAnswersHasChanged() async {
    bool mustUpdate = await _appSettingsStore.getMustUpdate() ?? false;
    if(mustUpdate) {
      await DataLoadHandler().checkForUpdate(forceUpdate: true);
      await _appSettingsStore.setMustUpdate(false);
    }
  }

  void setButtonState(ButtonState buttonState) {
    setState(() {
      this.buttonState = buttonState;
    });
  }

  // Size sizeOfButton({scaleBy = 1}){
  //   return Size(math.max(_getScreenWidth() - (Dimens.buildQuestionsButtonStyle["pixels_smaller_than_screen_width"]!) / scaleBy, 0), Dimens.buildQuestionsButtonStyle["height"]!);
  // }

// Widget oldVersionButton() {
//   return TextButton(
//     style: _buildQuestionsButtonStyle(AppColors.nextStepColor),
//     onPressed: onTapFunction,
//     child: Text(
//       _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.next_stage_button_text),
//       style: TextStyle(color: Colors.white, fontSize: 15),
//     ),
//   );
// }

// ButtonStyle _buildQuestionsButtonStyle(Color color) {
//   return ButtonStyle(
//     minimumSize: MaterialStateProperty.all(sizeOfButton()),
//     backgroundColor: MaterialStateProperty.all<Color>(color),
//     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//       RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//     ),
//   );
// }
}
