import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class StepTimeLine extends StatefulWidget {
  StepTimeLine({Key? key}) : super(key: key);

  @override
  State<StepTimeLine> createState() => _StepTimeLineState();
}

class _StepTimeLineState extends State<StepTimeLine> {
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Padding(
      padding: Dimens.stepTimeLine.containerPadding,
      child: Container(
        width: _getScreenWidth(),
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
        child: Observer(builder: (_) => _buildTimeline()),
      ),
    );
  }

  Widget _buildTimeline() {
    return FixedTimeline.tileBuilder(
      direction: Axis.horizontal,
      builder: TimelineTileBuilder(
        itemCount: _dataStore.getAllSteps.length,
        itemExtent: (_getScreenWidth() - 50) / _dataStore.getAllSteps.length,
        indicatorBuilder: (context, index) =>
            Observer(builder: (_) => _buildIndicator(index)),
        startConnectorBuilder: (context, index) => _buildStartConnector(index),
        endConnectorBuilder: (context, index) => _buildEndConnector(index),
      ),
    );
  }

  Widget _buildIndicator(index) {
    if (_dataStore.getStepByIndex(index).id !=
        _appSettingsStore.currentStepId) {
      return _buildNotSelectedIndicator(index);
    }
    return _buildSelectedIndicator(index);
  }

  Widget _buildSelectedIndicator(int index) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
              color: context.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: context.primaryColor, width: 4),
            ),
            child: Container(
                padding: Dimens.stepTimeLine.currentStepOuterCirclePadding,
                child: Container(
                    padding: Dimens.stepTimeLine.currentStepInnerCirclePadding,
                    decoration: BoxDecoration(
                      color: (_dataStore
                              .stepIsDone(_dataStore.getStepByIndex(index).id)
                          ? context.secondaryColor
                          : context.primaryColor),
                      shape: BoxShape.circle,
                    )))));
  }

  Widget _buildNotSelectedIndicator(int index) {
    if (_dataStore.stepIsDone(_dataStore.getStepByIndex(index).id)) {
      return DotIndicator(size: 10, color: context.secondaryColor);
    }
    return DotIndicator(size: 10, color: context.primaryColor);
  }

  Widget _buildDoneStartConnector() {
    return SolidLineConnector(
        thickness: 3, color: context.primaryColor, endIndent: 10);
  }

  Widget _buildDoneEndConnector() {
    return SolidLineConnector(
      thickness: Dimens.stepTimeLine.doneEndConnectorThickness,
      color: context.primaryColor,
      indent: Dimens.stepTimeLine.doneEndConnectorIndent,
    );
  }

  Widget? _buildStartConnector(index) {
    if (_dataStore.isFirstStep(_dataStore.getStepByIndex(index).id)) {
      return null;
    }
    return _buildDoneStartConnector();
  }

  Widget? _buildEndConnector(int index) {
    if (_dataStore.isLastStep(_dataStore.getStepByIndex(index).id)) {
      return null;
    }
    return _buildDoneEndConnector();
  }

  //logic methods : ..............................................................
  double _getScreenWidth() => kIsWeb ? _appSettingsStore.currentMinDimension : MediaQuery.of(context).size.width;
}
