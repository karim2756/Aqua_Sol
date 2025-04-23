import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WaterPumpScreen extends StatefulWidget {
  const WaterPumpScreen({super.key});

  @override
  _WaterPumpScreenState createState() => _WaterPumpScreenState();
}

class _WaterPumpScreenState extends State<WaterPumpScreen> {
  double waterLevel = 0.73; 
  bool isDeviceOn = true;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.075; // Adjust text size dynamically

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          AppStrings.waterPump.tr(),
          style: TextStyle(
              fontSize: fontSize * 0.7,
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Circular Indicator
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: waterLevel),
              duration: Duration(seconds: 1),
              builder: (context, value, child) {
                return CircularPercentIndicator(
                  radius: screenWidth * 0.35,
                  lineWidth: screenWidth * 0.05,
                  percent: value,
                  center: Text(
                    "${(value * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blue,
                    ),
                  ),
                  progressColor: AppColor.blue,
                  backgroundColor: AppColor.lightBlue,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  animationDuration: 1000,
                );
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            // Water Tank Label
            Text(
              AppStrings.waterTank.tr(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColor.blue,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Device Status Text
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:AppStrings.theDeviceNowIs.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.7,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  TextSpan(
                    text: isDeviceOn
                        ? AppStrings.working.tr()
                        : AppStrings.notWorking.tr(),
                    style: TextStyle(
                      fontSize: fontSize * 0.7,
                      fontWeight: FontWeight.bold,
                      color:
                          isDeviceOn ? AppColor.greenColor : AppColor.redColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Power Button
            GestureDetector(
              onTap: () {
                setState(() {
                  isDeviceOn = !isDeviceOn;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: screenWidth * 0.18,
                height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  color: isDeviceOn ? AppColor.greenColor : AppColor.redColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
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
