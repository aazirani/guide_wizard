import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:boilerplate/constants/colors.dart';

class DiamondIndicator extends StatelessWidget {
  const DiamondIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationZ(
            math.pi / 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.diamondColor,
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
