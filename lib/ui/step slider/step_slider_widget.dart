import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/step/step.dart' as s;
import '../../utils/enums/enum.dart';
import '../../constants/colors.dart';

class StepSliderWidget extends StatefulWidget {

  final List<s.Step> steps;

  const StepSliderWidget({Key? key, required this.steps}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {

  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return _buildCarouselSlider();
  }

  Widget _buildSliderContainer(int i) {
    return Container(
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 205, 243, 231),
          border: (i == 1)
              ? Border.all(width: 4, color: AppColors.main_color)
              : Border.all(width: 2, color: AppColors.main_color),
          boxShadow: (i == 1)
              ? [BoxShadow(blurRadius: 1, offset: Offset(0, 1))]
              : null,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            _buildAvatar(),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'text $i',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10),
                    Text("text2"),
                    // SizedBox(height: 5),

                    SizedBox(height: 20),
                    _buildContinueButton(),
                    SizedBox(height: 10),
                    _buildProgressBar(),
                  ]),
            )
          ],
        ));
  }

  Widget _buildAvatar() {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.only(left: 140, bottom: 60),
        child: Image.asset("assets/images/avatar_boy.png", fit: BoxFit.contain),
      ),
      Padding(
          padding: EdgeInsets.only(left: 200, bottom: 40, top: 20),
          child:
              Image.asset("assets/images/avatar_girl.png", fit: BoxFit.cover))
    ]);
  }

  Widget _buildContinueButton() {
    return Container(
      // decoration: BoxDecoration(color: Color.fromARGB(248, 203, 223, 245) ,borderRadius: BorderRadius.all(Radius.circular(18)) ,boxShadow: [BoxShadow(color: AppColors.hannover_blue.withOpacity(0.4), spreadRadius: 0, blurRadius: 7, offset: Offset(0,4)),]),
      child: TextButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
                Size.fromWidth(MediaQuery.of(context).size.width / 4)),
            backgroundColor: MaterialStateProperty.all(
                AppColors.main_color.withOpacity(0)),
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

  Widget _buildProgressBar() {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: LinearProgressIndicator(
            value: 0.2,
            backgroundColor: Colors.white,
            valueColor:
                AlwaysStoppedAnimation(Color.fromARGB(255, 47, 205, 144))));
  }

  Widget _buildCarouselSlider() {
    print(_getScreenHeight() / 3);
    return Container(
      color: Color.fromARGB(255, 95, 34, 139).withOpacity(0),
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 3.2,
      child: CarouselSlider(
        options: CarouselOptions(
            height: _getScreenHeight() / 4, enlargeCenterPage: true, enableInfiniteScroll: false),
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {},
                child: _buildSliderContainer(i),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}