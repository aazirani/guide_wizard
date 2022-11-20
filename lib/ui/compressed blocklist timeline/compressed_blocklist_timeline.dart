import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import '../../widgets/diamond_indicator.dart';

class CompressedBlocklistTimeline extends StatefulWidget {
  const CompressedBlocklistTimeline({Key? key}) : super(key: key);

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
    return Container(
      // padding: EdgeInsets.only(left: 15),
      height: _getScreenHeight() / 2.5,
      width: double.infinity,
      // color: Colors.green,
      child: Align(
        alignment: Alignment.topLeft,
        child: _buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return Align(
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
            itemCount: 20,
            itemExtent: 90,
            contentsBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 15),
                color: Colors.white,
                width: 200,
                height: 40,
                child: Align(
                    alignment: Alignment.center,
                    child: Text("this shit is pretty big"))),
            indicatorBuilder: (context, index) => _buildIndicator(),
            startConnectorBuilder: (context, index) => SolidLineConnector(
                direction: Axis.vertical, color: Colors.amber),
            endConnectorBuilder: (context, index) => SolidLineConnector(
                direction: Axis.vertical, color: Colors.amber),
            // scrollDirection:
          )),
    );
  }

  Widget _buildIndicator() {
    return Container(color: Colors.transparent, width: 10, height: 10, child: DiamondIndicator());
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

  Widget _buildContents() {
    // print(_getScreenWidth());
    return Container(
        width: 100, height: 30, child: Text("zoha"), color: Colors.amber);
  }
}
