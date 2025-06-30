import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';

class MotorScreen extends StatefulWidget {
  const MotorScreen({super.key});

  @override
  _MotorScreenState createState() => _MotorScreenState();
}

class _MotorScreenState extends State<MotorScreen> {
  bool isMotorOn = false;
  final DatabaseReference _motorRef =
      FirebaseDatabase.instance.ref('devices/motor/control');

  @override
  void initState() {
    super.initState();
    _listenToMotorStatus();
  }

  void _listenToMotorStatus() {
    _motorRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          isMotorOn = (value == 1 || value == true);
        });
      }
    });
  }

  void _toggleMotor() async {
    final newValue = isMotorOn ? 0 : 1;
    await _motorRef.set(newValue);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.075;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          AppStrings.pivotMotor.tr(),
          style: TextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Motor image
            Image.asset(
              AppStrings.motorImage,
              width: screenWidth * 0.8,
              height: screenHeight * 0.4,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.04),

            // Motor status
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.motorNowIs.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  TextSpan(
                    text: isMotorOn
                        ? AppStrings.motorWorking.tr()
                        : AppStrings.motorNotWorking.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: isMotorOn
                          ? AppColor.greenColor
                          : AppColor.redColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Power toggle button
            GestureDetector(
              onTap: _toggleMotor,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: screenWidth * 0.3,
                height: screenWidth * 0.21,
                decoration: BoxDecoration(
                  color: isMotorOn ? AppColor.greenColor : AppColor.redColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.power_settings_new,
                  size: screenWidth * 0.1,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}