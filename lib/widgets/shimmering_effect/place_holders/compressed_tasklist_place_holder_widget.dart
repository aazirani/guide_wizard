import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';

class CompressedTaskListPlaceHolderWidget extends StatelessWidget {
  const CompressedTaskListPlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.stepTimeLine.containerPadding,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.homeScreen.compressedTaskListBorderRadius))),
        padding: Dimens.compressedTaskList.timelineContainerPadding,
        height:  _getScreenHeight(context) /
            Dimens.homeScreen.placeHolderCompressedTaskListHeightRatio,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }

  _getScreenHeight(context) => MediaQuery.of(context).size.height;
}