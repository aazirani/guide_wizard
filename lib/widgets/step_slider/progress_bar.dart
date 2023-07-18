import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ProgressBar extends StatefulWidget {
  final double percentage;

  const ProgressBar({Key? key, required this.percentage}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  double _percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _percentage = widget.percentage;
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _percentage,
      backgroundColor: AppColors.progressBarBackgroundColor,
      valueColor: AlwaysStoppedAnimation(AppColors.progressBarValueColor),
    );
  }
}