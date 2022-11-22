import 'dart:math' as math;

import 'package:flutter/material.dart';

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
              color: Color.fromARGB(255, 115, 213, 172),
              border: Border.all(
                width: 2,
                color: Color.fromARGB(255, 115, 213, 172),
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