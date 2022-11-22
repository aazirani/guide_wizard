import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import '../../widgets/diamond_indicator.dart';
import '../../constants/colors.dart';
import '../../stores/step/step_store.dart';
import '../../models/step/step.dart' as s;

class CompressedBlocklistTimeline extends StatefulWidget {
  final List<s.Step> steps;
  CompressedBlocklistTimeline({Key? key, required this.steps})
      : super(key: key);

  @override
  State<CompressedBlocklistTimeline> createState() =>
      _CompressedBlocklistTimelineState();
}

class _CompressedBlocklistTimelineState
    extends State<CompressedBlocklistTimeline> {
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final stepStore = Provider.of<StepStore>(context);
    return _buildTimelineContainer(stepStore);
  }

  Widget _buildTimelineContainer(stepStore) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 25),
      // padding: EdgeInsets.only(top: 25),
      height: _getScreenHeight() / 2.8,
      width: double.infinity,
      // color: Colors.green,
      child: Align(
        alignment: Alignment.topLeft,
        child: _buildTimeline(stepStore),
      ),
    );
  }

  Widget _buildTimeline(stepStore) {
    print("${stepStore.currentStep}, ${widget.steps[stepStore.currentStep - 1].numTasks} is this shit");
    return Observer(
      builder: (_) => Align(
        alignment: Alignment.topLeft,
        child: Timeline.tileBuilder(
              theme: TimelineThemeData(
                direction: Axis.vertical,
                color: Colors.blue,
                // nodeItemOverlap: true,
                // indicatorPosition: ,
                nodePosition: 0.009,
                // indicatorTheme: IndicatorThemeData(position: 100)),
              ),
              // scrollDirection: Axis.vertical,
              builder: TimelineTileBuilder(
                itemCount: widget.steps[(stepStore.currentStep) - 1].numTasks,
                // itemCount: 20,
                itemExtent: 70,
                contentsBuilder: (context, index) =>
                    _buildContents(index, stepStore),
                indicatorBuilder: (context, index) => _buildIndicator(),
                startConnectorBuilder: (context, index) => _buildConnector(),
                endConnectorBuilder: (context, index) => _buildConnector(),
                // scrollDirection:
              )),
        
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
        color: Colors.transparent,
        width: 8,
        height: 8,
        child: DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: Color.fromARGB(255, 115, 213, 172));
  }

  Widget _buildContents(index, stepStore) {
    print("this is index $index, ${widget.steps[stepStore.currentStep -1].numTasks}");
    return Container(
        margin: EdgeInsets.only(left: 20),
        // color: Colors.white,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 246, 246),
            // border:
            //     Border.all(width: 1, color: Color.fromARGB(255, 222, 224, 225)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 224, 222, 222),
                blurRadius: 2,
                offset: Offset(1, 2),
                spreadRadius: 1,
              )
            ]),
        width: _getScreenWidth() / 1.23,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                        "${widget.steps[stepStore.currentStep - 1].tasks[index].title}",
                        style: TextStyle(
                          color: AppColors.main_color,
                          fontSize: 16,
                        )),
                  ),
                  // child: Text("hi")
              
              Spacer(),
              Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert, color: AppColors.main_color)),
            ],
          ),
        ));
  }

  Widget _buildNodeTimeline() {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder(
          itemCount: 30,
          itemExtent: 40,
          // contentsBuilder: (context, index) => _buildContents(),
          indicatorBuilder: (context, index) =>
              DotIndicator(size: 15, color: Colors.blue)),
      // itemCount:20,
      // itemExtent: 40,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
          left: 10, top: 10, bottom: 10, right: (_getScreenWidth() / 2) - 50),
      // itemBuilder: (context, index) => DotIndicator(size: 15, color: Colors.yellow),
      // mainAxisSize: MainAxisSize.min,
      // direction: Axis.vertical,
      // children: [
      //   DotIndicator(size: 15, color: Colors.blue),
      //   DotIndicator(size: 15, color: Colors.blue),
      //   DotIndicator(size: 15, color: Colors.blue),
      //   DotIndicator(size: 15, color: Colors.blue),
      // ],
    );
  }
}
