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
            // width: 100,
            // height: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: 3,
                color: Color.fromARGB(255, 115, 213, 172),
              ),
            ),
            child: InkWell(
              splashColor: Colors.blueAccent,
              // onTap: () {},
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