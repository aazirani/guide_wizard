import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:guide_wizard/widgets/progress_bar.dart';
import 'package:guide_wizard/widgets/step_avatar.dart';
import 'package:guide_wizard/widgets/step_continue_button_widget.dart';
import 'package:guide_wizard/widgets/step_counter_widget.dart';
import 'package:guide_wizard/widgets/step_title.dart';
import 'package:provider/provider.dart';

class StepContent extends StatefulWidget {
  final int step_index;
  const StepContent({Key? key, required this.step_index}) : super(key: key);

  @override
  State<StepContent> createState() => _StepContentState();
}

class _StepContentState extends State<StepContent> {
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var heightConstraint = constraints.maxHeight;
      return Observer(
        builder: (_) => Container(
          alignment: Alignment.topLeft,
          width: _getScreenWidth(),
          margin: Dimens.stepSlider.sliderContainerMargin,
          decoration: BoxDecoration(
            color: _buildSliderColor(widget.step_index),
            border: _buildSliderBorder(widget.step_index),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Flexible(
              flex: 80,
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: heightConstraint *
                                Dimens
                                    .stepSlider.contentHeightPaddingPercentage,
                            start: heightConstraint *
                                Dimens.stepSlider.contentLeftPaddingPercentage,
                            end: heightConstraint *
                                Dimens.stepSlider.contentRightPaddingPercentage,
                            bottom: heightConstraint *
                                Dimens
                                    .stepSlider.contentBottomPaddingPercentage),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            flex: 4,
                                            child: StepTitle(
                                                step_index: widget.step_index)),
                                        SizedBox(
                                            height: heightConstraint *
                                                Dimens.stepSlider
                                                    .spaceBetweenTitleAndNoOfTasksPercentage),
                                        Flexible(
                                            flex: 2,
                                            child:
                                                StepCounterWidget(step_index: widget.step_index)),
                                        SizedBox(
                                            height: heightConstraint *
                                                Dimens.stepSlider
                                                    .spaceBetweenNoOfTasksAndContinueButtonPercentage),
                                      ])),
                              Expanded(
                                  flex: 2, child: widget.step_index == 0 ? StepContinueButton(step_index: widget.step_index) : SizedBox.shrink()),
                            ]))),
                (_dataStore.getStepByIndex(widget.step_index).image != null)
                    ? Expanded(
                        flex: 1,
                        child: StepAvatar(
                            step_index: widget.step_index,
                            constraints: constraints))
                    : Container(
                        width: heightConstraint *
                            Dimens.stepSlider.emptySpaceHeightPercentage)
              ]),
            ),
            (_dataStore.getStepByIndex(widget.step_index).tasks.isNotEmpty)
                ? Flexible(
                    flex: 10, child: ProgressBar(step_index: widget.step_index))
                : Container(
                    height: heightConstraint *
                        Dimens.stepSlider.emptySpaceHeightPercentage),
          ]),
        ),
      );
    });
  }

  Color _buildSliderColor(index) {
    if (_dataStore.stepIsDone(_dataStore.getStepByIndex(index).id)) {
      return context.doneStepColor;
    }
    return context.unDoneStepColor;
  }

  BoxBorder _buildSliderBorder(index) {
    if (index == _dataStore.getIndexOfStep(_appSettingsStore.currentStepId)) {
      return _buildPendingBorder();
    }
    if (_isStepDone(index)) {
      return _buildDoneBorder();
    }
    return _buildPendingBorder();
  }

  Border _buildPendingBorder() {
    return Border.all(
        width: Dimens.stepSlider.pendingSliderBorder,
        color: context.primaryColor);
  }

  Border _buildDoneBorder() {
    return Border.all(
        width: Dimens.stepSlider.doneSliderBorder, color: context.primaryColor);
  }

  //general methods ............................................................
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  bool _isStepDone(index) {
    return _dataStore.stepIsDone(_dataStore.getStepByIndex(index).id);
  }
}