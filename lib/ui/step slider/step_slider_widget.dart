import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../models/step/step.dart' as s;
import '../../utils/enums/enum.dart';
import '../../constants/colors.dart';
import '../../stores/step/step_store.dart';

class StepSliderWidget extends StatefulWidget {
  final List<s.Step> steps;
  const StepSliderWidget({Key? key, required this.steps}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  int number = 10;

  @override
  Widget build(BuildContext context) {
    final stepStore = Provider.of<StepStore>(context);
    return _buildCarouselSlider(stepStore);
  }

  Border _buildPendingBorder() {
    return Border.all(width: 4, color: AppColors.main_color);
  }

  Border _buildDoneBorder() {
    return Border.all(width: 1, color: AppColors.main_color);
  }

  Border _buildNotStartedBorder() {
    return Border.all(width: 2, color: Color.fromARGB(255, 177, 182, 186));
  }

  Widget _buildSliderContainer(int i) {
    return Container(
        alignment: Alignment.topLeft,
        width: _getScreenWidth(),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: (widget.steps[i].status == StepStatus.isPending ||
                  widget.steps[i].status == StepStatus.isDone)
              ? Color.fromARGB(218, 206, 240, 229)
              : Color.fromARGB(255, 243, 241, 241),
          border: (widget.steps[i].status == StepStatus.isDone)
              ? _buildDoneBorder()
              : (widget.steps[i].status == StepStatus.isPending)
                  ? _buildPendingBorder()
                  : _buildNotStartedBorder(),
          // boxShadow: (widget.steps[i].status == StepStatus.isPending)
          // ? [BoxShadow(blurRadius: 1, offset: Offset(0, 1))]
          // : null,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            _buildAvatar(),
            _buildContent(i),
          ],
        ));
  }

  Widget _buildAvatar() {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(left: 140, bottom: 70),
        child: Image.asset("assets/images/avatar_boy.png", fit: BoxFit.contain),
      ),
      Padding(
          padding: EdgeInsets.only(left: 200, bottom: 40, top: 20),
          child:
              Image.asset("assets/images/avatar_girl.png", fit: BoxFit.cover))
    ]);
  }

  Widget _buildContent(i) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.steps[i].title}",
              style: TextStyle(fontSize: 17, color: AppColors.main_color),
            ),
            SizedBox(height: 10),
            Text("${widget.steps[i].numTasks} tasks",
                style: TextStyle(fontSize: 15, color: AppColors.main_color)),
            // SizedBox(height: 5),

            SizedBox(height: 20),
            _buildContinueButton(),
            SizedBox(height: 10),
            _buildProgressBar(widget.steps[i].percentage),
          ]),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      // decoration: BoxDecoration(color: Color.fromARGB(248, 203, 223, 245) ,borderRadius: BorderRadius.all(Radius.circular(18)) ,boxShadow: [BoxShadow(color: AppColors.hannover_blue.withOpacity(0.4), spreadRadius: 0, blurRadius: 7, offset: Offset(0,4)),]),
      child: TextButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
                Size.fromWidth(MediaQuery.of(context).size.width / 4)),
            backgroundColor:
                MaterialStateProperty.all(Colors.white.withOpacity(0.5)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.main_color)))),
        onPressed: () {},
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Continue",
              style: TextStyle(fontSize: 12, color: AppColors.main_color)),
          SizedBox(width: 1),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.main_color,
            size: 16,
          )
        ]),
      ),
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 20,
      child: Padding(
          padding: EdgeInsets.only(right: 10, top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
                // minHeight: 4,
                value: percentage,
                backgroundColor: Colors.white,
                valueColor:
                    AlwaysStoppedAnimation(Color.fromARGB(255, 47, 205, 144))),
          )),
    );
  }

  Widget _buildCarouselSlider(stepStore) {
    return Container(
      // color: Color.fromARGB(255, 95, 34, 139).withOpacity(1),
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 3.2,
      child: CarouselSlider(
        items: [0, 1, 2, 3].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {},
                child: _buildSliderContainer(i),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
            // onPageChanged: (index, reason) =>
            //   stepStore.increment,
            onPageChanged: (index, reson) {
              stepStore.increment(index + 1);
            },
            // onPageChanged: (index, reason) {
            //   print("${index} this is it");
            // },
            height: _getScreenHeight() / 4,
            enlargeCenterPage: false,
            enableInfiniteScroll: false),
      ),
    );
  }
}
