import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';


class StepTimelinePlaceHolderWidget extends StatelessWidget {
  const StepTimelinePlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.stepTimeLine.containerPadding,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
            color: context.containerColor,
            borderRadius: Dimens.stepTimeLine.containerBorderRadius,
            boxShadow: [
              BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 0.3,
                  offset: Offset(0, 2))
            ]),
      ),
    );
  }
}