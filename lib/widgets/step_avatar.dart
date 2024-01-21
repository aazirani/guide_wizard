import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/widgets/load_image_with_cache.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class StepAvatar extends StatelessWidget {
  final BoxConstraints constraints;
  final int step_index; 
  const StepAvatar({Key? key, required this.constraints, required this.step_index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataStore _dataStore = Provider.of<DataStore>(context);
    var heightConstraint = constraints.maxHeight;
    if (_dataStore.getStepByIndex(step_index).image == null) return Container();
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            right: heightConstraint *
                Dimens.stepSlider.avatarRightPaddingPercentage),
        child: LoadImageWithCache(
          imageUrl: Endpoints.stepsImageBaseUrl +
              _dataStore.getStepByIndex(step_index).image!,
          color: context.primaryColor,
        ),
      ),
    );
  }
}