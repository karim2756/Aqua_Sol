
// ignore_for_file: unrelated_type_equality_checks

import 'package:animate_do/animate_do.dart';
import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SoilCard extends StatefulWidget {
  final double screenWidth;
  final double fontSize;

  const SoilCard({
    super.key,
    required this.screenWidth,
    required this.fontSize,
  });

  @override
  State<SoilCard> createState() => _SoilCardState();
}

class _SoilCardState extends State<SoilCard> {
  double moistureValue = 0.0;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _listenToMoisture();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        hasInternet = result != ConnectivityResult.none;
      });
    });
  }

  void _listenToMoisture() {
    FirebaseDatabase.instance
        .ref('devices/sensor/soil_moisture')
        .onValue
        .listen((event) {
      final val = event.snapshot.value;
      if (val != null && mounted) {
        setState(() {
          moistureValue =
              (val is int ? val.toDouble() : double.tryParse(val.toString()) ?? 0.0);
        });
      }
    }, onError: (error) {
      print("Error reading soil_moisture: $error");
    });
  }

  String getSoilStatus() {
    if (moistureValue <= 30) {
      return AppStrings.bad.tr();
    } else if (moistureValue <= 60) {
      return AppStrings.stable.tr();
    } else {
      return AppStrings.good.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      animate: true,
      delay: const Duration(seconds: 1),
      child: Container(
        width: widget.screenWidth,
        margin: const EdgeInsets.only(top: 10),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: hasInternet
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.statisticsAndResults.tr(),
                              style: TextStyle(
                                  fontSize: widget.fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.greenColor)),
                          Icon(Icons.bar_chart,
                              color: AppColor.greenColor,
                              size: widget.fontSize * 1.5),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("${AppStrings.status.tr()}: ${getSoilStatus()}",
                          style: TextStyle(
                              fontSize: widget.fontSize * 0.9,
                              color: AppColor.black)),
                      Text("${AppStrings.moisture.tr()}: ${moistureValue.toInt()}%",
                          style: TextStyle(
                              fontSize: widget.fontSize * 0.9,
                              color: AppColor.primaryColor)),
                      const SizedBox(height: 15),
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: (moistureValue.clamp(0, 100)) / 100,
                          ),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: widget.screenWidth * 0.2,
                                  height: widget.screenWidth * 0.2,
                                  child: CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 8,
                                    backgroundColor: AppColor.lightGreenColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.primaryColor),
                                  ),
                                ),
                                Text("${moistureValue.toInt()}%",
                                    style: TextStyle(
                                        fontSize: widget.fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.black)),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        Icon(Icons.wifi_off,
                            color: Colors.red, size: widget.fontSize * 2),
                        const SizedBox(height: 8),
                        Text("No Internet",
                            style: TextStyle(
                                fontSize: widget.fontSize,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
