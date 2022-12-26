import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/test/step.dart' as s;
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/utils/enums/enum.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepSliderWidget extends StatefulWidget {
  final List<s.Step> steps;
  const StepSliderWidget({Key? key, required this.steps}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {
  late StepStore stepStore;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    stepStore = Provider.of<StepStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    // final stepStore = Provider.of<StepStore>(context);
    return _buildCarouselSliderContainer();
  }

  Widget _buildCarouselSliderContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 3.2,
      child: _buildCarouselSlider(),
    );
  }

  _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
          onPageChanged: (index, reason) {
            stepStore.increment(index);
          },
          height: _getScreenHeight() / 4,
          enlargeCenterPage: false,
          enableInfiniteScroll: false),
      items: List<int>.generate(Dimens.stepNo, (index) => index).map((index) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {},
              child: _buildSliderContainer(index),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSliderContainer(index) {
    return Container(
        alignment: Alignment.topLeft,
        width: _getScreenWidth(),
        margin: Dimens.sliderContainerMargin,
        padding: Dimens.sliderContainerPadding,
        decoration: BoxDecoration(
          color: _buildSliderColor(index),
          border: _buildSliderBorder(index),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            _buildAvatar(),
            _buildContent(index),
          ],
        ));
  }

  BoxBorder _buildSliderBorder(index) {
    switch (widget.steps[index].status) {
      case StepStatus.isDone:
        return _buildDoneBorder();
      case StepStatus.isPending:
        return _buildPendingBorder();
      case StepStatus.notStarted:
        return _buildNotStartedBorder();
    }
  }

  Color _buildSliderColor(index) {
    switch (widget.steps[index].status) {
      case StepStatus.isPending:
      case StepStatus.isDone:
        return AppColors.stepSliderAvailableColor;
      default:
        return AppColors.stepSliderUnavailableColor;
    }
  }

  Widget _buildAvatar() {
    return Stack(children: [
      _buildBoyAvatar(),
      _buildGirlAvatar(),
    ]);
  }

  Widget _buildBoyAvatar() {
    return Padding(
      padding: Dimens.avatarBoyPadding,
      child: Image.asset("assets/images/avatar_boy.png", fit: BoxFit.contain),
    );
  }

  Widget _buildGirlAvatar() {
    return Padding(
        padding: Dimens.avatarGirlPadding,
        child: Image.asset("assets/images/avatar_girl.png", fit: BoxFit.cover));
  }

  Widget _buildContent(currentStepNo) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepTitle(currentStepNo),
            SizedBox(height: 10),
            _buildStepNoOfTasks(currentStepNo),
            SizedBox(height: 20),
            _buildContinueButton(),
            SizedBox(height: 10),
            _buildProgressBar(widget.steps[currentStepNo].percentage),
          ]),
    );
  }

  Widget _buildStepTitle(currentStepNo) {
    return Text(
      "${widget.steps[currentStepNo].title}",
      style: TextStyle(fontSize: 17, color: AppColors.main_color),
    );
  }

  Widget _buildStepNoOfTasks(currentStepNo) {
    return Text("${widget.steps[currentStepNo].numTasks} tasks",
        style: TextStyle(fontSize: 15, color: AppColors.main_color));
  }

  Widget _buildContinueButton() {
    return Container(
      child: TextButton(
        style: _buildButtonStyle(),
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

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
        fixedSize: MaterialStateProperty.all(
            Size.fromWidth(MediaQuery.of(context).size.width / 4)),
        backgroundColor: MaterialStateProperty.all(
            AppColors.stepSliderContinueButton.withOpacity(0.5)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColors.main_color))));
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
                backgroundColor: AppColors.progressBarBackgroundColor,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
          )),
    );
  }

  Border _buildPendingBorder() {
    return Border.all(width: 4, color: AppColors.main_color);
  }

  Border _buildDoneBorder() {
    return Border.all(width: 1, color: AppColors.main_color);
  }

  Border _buildNotStartedBorder() {
    return Border.all(width: 2, color: AppColors.stepSliderUnavailableBorder);
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
