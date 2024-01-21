import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/widgets/current_step_number_text_widget.dart';
import 'package:guide_wizard/widgets/steps_text_widget.dart';

class CurrentStepIndicatorWidget extends StatelessWidget {
  const CurrentStepIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: Dimens.homeScreen.currentStepIndicatorPadding,
        child: Row(children: [
          StepsTextWidget(),
          SizedBox(width: 10),
          CurrentStepNumberTextWidget(),
        ]));
  }
}