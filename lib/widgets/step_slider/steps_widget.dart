import 'package:flutter/material.dart';
import 'package:guide_wizard/widgets/step_slider/step_slider_widget.dart';

class StepsWidget extends StatefulWidget {
  StepsWidget({Key? key}) : super(key: key);

  @override
  State<StepsWidget> createState() => _StepsWidget();
}

class _StepsWidget extends State<StepsWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsetsDirectional.only(top: 20,),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.2,
      child: StepSliderWidget(),
    );
  }
}