import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/widgets/shimmering_effect/place_holders/steps_text_place_holder_widget.dart';

class CurrentStepIndicatorPlaceHolderWidget extends StatelessWidget {
  const CurrentStepIndicatorPlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: Dimens.homeScreen.currentStepIndicatorPadding,
        child: Row(children: [
          StepsTextPlaceHolderWidget(),
        ]));
  }
}