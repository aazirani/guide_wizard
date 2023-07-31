import 'dart:math' as math;
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextStageButton extends StatefulWidget {
  const NextStageButton({Key? key}) : super(key: key);

  @override
  State<NextStageButton> createState() => _NextStageButtonState();
}

class _NextStageButtonState extends State<NextStageButton> {
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late StepStore _stepStore;
  late CurrentStepStore _currentStepStore;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

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
    _currentStepStore = Provider.of<CurrentStepStore>(context);
  }


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: _buildQuestionsButtonStyle(AppColors.nextStepColor),
      onPressed: () {
        _dataStore.getTasks(_stepStore.currentStep);
        _currentStepStore.setStepNumber(1);
        Navigator.of(context)
            .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false)
            .then((value) => setState(() {}));
      },
      child: Text(
        AppLocalizations.of(context).translate('next_stage_button_text'),
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  ButtonStyle _buildQuestionsButtonStyle(Color color) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton()),
      backgroundColor: MaterialStateProperty.all<Color>(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Size sizeOfButton({scaleBy = 1}){
    return Size(math.max(_getScreenWidth() - (Dimens.buildQuestionsButtonStyle["pixels_smaller_than_screen_width"]!) / scaleBy, 0), Dimens.buildQuestionsButtonStyle["height"]!);
  }
}
