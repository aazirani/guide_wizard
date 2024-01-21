import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/widgets/shimmering_effect/place_holders/carousel_slider_place_holder_widget.dart';
import 'package:guide_wizard/widgets/shimmering_effect/place_holders/compressed_tasklist_place_holder_widget.dart';
import 'package:guide_wizard/widgets/shimmering_effect/place_holders/current_step_indicator_place_holder_widget.dart';
import 'package:guide_wizard/widgets/shimmering_effect/place_holders/step_timeline_place_holder_widget.dart';

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CurrentStepIndicatorPlaceHolderWidget(),
          CarouselSliderPlaceHolderWidget(),
          StepTimelinePlaceHolderWidget(),
          SizedBox(height: Dimens.homeScreen.StepTimelineProgressBarDistance),
          SizedBox(height: Dimens.homeScreen.progressBarCompressedTaskListDistance),
          CompressedTaskListPlaceHolderWidget(),
        ],
      ),
    );
  }
}