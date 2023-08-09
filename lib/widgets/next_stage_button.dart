import 'dart:io';
import 'dart:math' as math;
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/stores/app_settings/app_settings_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

class NextStageButton extends StatefulWidget {
  double height;
  NextStageButton({this.height = 53, Key? key}) : super(key: key);

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
  }


  @override
  Widget build(BuildContext context) {
    return newVersionButton();
  }


  Widget newVersionButton() {
    return ProgressButton(
      height: widget.height,
      radius: Dimens.nextStageButtonRadius,
      stateWidgets: {
        ButtonState.idle: Text(
          _appSettingsStore.isFirstStep() ?  AppLocalizations.of(context).translate("next_step_button_text") : AppLocalizations.of(context).translate("update_steps"),
          style: TextStyle(color: AppColors.white,),
        ),
        ButtonState.loading: Text(
          AppLocalizations.of(context).translate("getting_updates"),
          style: TextStyle(color: AppColors.white,),
        ),
        ButtonState.fail: Text(
          AppLocalizations.of(context).translate("next_stage_check_internet"),
          style: TextStyle(color: AppColors.white,),
        ),
        ButtonState.success: Text(
          AppLocalizations.of(context).translate("update_finished"),
          style: TextStyle(color: AppColors.white,),
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
//       AppLocalizations.of(context).translate('next_stage_button_text'),
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
