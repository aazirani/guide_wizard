import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class CompressedBlocklistTimeline extends StatefulWidget {
  final StepList stepList;
  CompressedBlocklistTimeline({Key? key, required this.stepList})
      : super(key: key);

  @override
  State<CompressedBlocklistTimeline> createState() =>
      _CompressedBlocklistTimelineState();
}

class _CompressedBlocklistTimelineState
    extends State<CompressedBlocklistTimeline> {
  late StepStore _stepStore; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepStore = Provider.of<StepStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 25),
      height: _getScreenHeight() / 2.8,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topLeft,
        child: _buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return Observer(
      builder: (_) => Align(
        alignment: Alignment.topLeft,
        child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              direction: Axis.vertical,
              nodePosition: 0.009,
            ),
            builder: TimelineTileBuilder(
              itemCount: widget.stepList.steps[(_stepStore.currentStep) - 1].numTasks,
              itemExtent: 70,
              contentsBuilder: (context, index) =>
                  _buildContents(index, _stepStore),
              indicatorBuilder: (context, index) => _buildIndicator(),
              startConnectorBuilder: (context, index) => _buildConnector(),
              endConnectorBuilder: (context, index) => _buildConnector(),
            )),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical,
        color: AppColors.timelineCompressedConnectorColor);
  }

  Widget _buildContents(index, stepStore) {
    return Container(
      width: _getScreenWidth() / 1.23,
      height: 60,
      // margin: EdgeInsets.only(left: 20),
      margin: Dimens.contentLeftMargin,
      decoration: BoxDecoration(
          color: AppColors.timelineCompressedContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.timelineCompressedContainerShadowColor,
              blurRadius: 2,
              offset: Offset(1, 2),
              spreadRadius: 1,
            )
          ]),
      child: _buildContentElements(index, stepStore),
    );
  }

  Widget _buildContentElements(index, stepStore) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          _buildContentTitle(index, stepStore),
          Spacer(),
          _buildContentMoreButton(),
        ],
      ),
    );
  }

  Widget _buildContentTitle(index, stepStore) {
    return Align(
      alignment: Alignment.centerLeft,
      child:
          Text("${widget.stepList.steps[stepStore.currentStep - 1].tasks[index].text.technical_name}",
              style: TextStyle(
                color: AppColors.main_color,
                fontSize: 16,
              )),
    );
  }

  Widget _buildContentMoreButton() {
    return Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.more_vert, color: AppColors.main_color));
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
