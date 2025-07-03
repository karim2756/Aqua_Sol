import 'dart:async';
import 'package:aqua_sol/resources/app_color.dart';
import 'package:aqua_sol/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to home after 3 seconds
    Timer(const Duration(seconds: 3), () {
Navigator.of(context).pushReplacementNamed(Routes.onboardingRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: AppColor.greenColor,
              highlightColor: AppColor.primaryColor,
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
             Text(
              "Aqua Sol",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
