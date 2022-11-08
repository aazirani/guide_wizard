import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../step slider/step_slider_widget.dart';
import '../step timeline/step_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    print(_getScreenHeight());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        titleSpacing: 5,
        backgroundColor: AppColors.main_color,
        title: Padding(
            padding: EdgeInsets.only(left: 10),
            child:
                Text("Welcome Guide", style: TextStyle(color: Colors.white))),
      ),
      body: _buildBody(context),
    );
  }

/* timline */

  // Widget _buildScrollableTimeline() {
  //   return Container(
  //     height: _getScreenHeight() / 3,
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: StepTimeLineWidget(),
  //     ),
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      color: AppColors.main_color,
      // height: 160.0,
      child: Stack(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 251, 251, 251),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 15, left: 15),
                      child: Row(children: [Text("Steps"), Text("4/4")])),
                  StepSliderWidget(),
                  SizedBox(height: 1),
                  StepTimeLine(),
                  SizedBox(height: 20),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("In Progress",
                              style: TextStyle(fontSize: 18)))),
                  SizedBox(height: 20),
                  // _buildScrollableTimeline(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
