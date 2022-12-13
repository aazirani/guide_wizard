import 'dart:math' as math;
import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';

class DiamondIndicator extends StatelessWidget {
  final bool fill;
  const DiamondIndicator({Key? key, this.fill = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(
            math.pi / 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: (fill) ? AppColors.diamondColor : AppColors.transparent,
              border: Border.all(
                width: 2,
                color: AppColors.diamondBorderColor,
              ),
            ),
            child: InkWell(
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                    -math.pi / 4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
