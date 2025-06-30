import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';

class WaterPumpScreen extends StatefulWidget {
  const WaterPumpScreen({super.key});

  @override
  _WaterPumpScreenState createState() => _WaterPumpScreenState();
}

class _WaterPumpScreenState extends State<WaterPumpScreen> {
  bool isPumpOn = false;

  final DatabaseReference _pumpRef =
      FirebaseDatabase.instance.ref('devices/pump/control');

  @override
  void initState() {
    super.initState();
    _listenToPumpStatus();
  }

  void _listenToPumpStatus() {
    _pumpRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          isPumpOn = (value == 1 || value == true);
        });
      }
    });
  }

  void _togglePump() async {
    final newValue = isPumpOn ? 0 : 1;
    await _pumpRef.set(newValue);
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
          AppStrings.waterPump.tr(),
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
            // Water pump image
            Image.asset(
              'assets/images/pump.png',
              width: screenWidth * 1.2,
              height: screenHeight * 0.4,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.05),

            // Device status text
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.theDeviceNowIs.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  TextSpan(
                    text: isPumpOn
                        ? AppStrings.working.tr()
                        : AppStrings.notWorking.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: isPumpOn
                          ? AppColor.greenColor
                          : AppColor.redColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),

            // Toggle button
            GestureDetector(
              onTap: _togglePump,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: screenWidth * 0.3,
                height: screenWidth * 0.21,
                decoration: BoxDecoration(
                  color: isPumpOn ? AppColor.greenColor : AppColor.redColor,
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
