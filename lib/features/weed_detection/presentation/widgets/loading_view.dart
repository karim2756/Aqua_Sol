import 'dart:math';

import 'package:flutter/cupertino.dart';

Widget buildLoadingView(screenHeight) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spinning logo animation
        RotationTransition(
          turns: AlwaysStoppedAnimation(0), // Initial state
          child: TweenAnimationBuilder(
            tween:
            Tween(begin: 0.0, end: 1.0), // 1.0 = 360 degrees
            duration: const Duration(seconds: 2),
            curve: Curves.linear,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * pi, // Convert to radians
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/logo.png',
              height: screenHeight * 0.15,
            ),
          ),
        )
      ],
    ),
  );  }