import 'package:animate_do/animate_do.dart';
import 'package:aqua_sol/features/home/presentation/widgets/home_cards.dart';
import 'package:aqua_sol/features/home/presentation/widgets/soil_card.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../resources/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.45;
    double fontSize = screenWidth * 0.045;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          final currentLocale = context.locale;
          final newLocale =
              currentLocale.languageCode == 'en' ? Locale('ar') : Locale('en');
          context.setLocale(newLocale);
        },
        icon: Icon(
          Icons.translate,
          color: AppColor.whiteColor,
        ),
        label: Text(
          context.locale.languageCode == 'en'
              ? AppStrings.english
              : AppStrings.arabic,
          style: TextStyle(color: AppColor.whiteColor),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Center(
          child: Text(
            "${AppStrings.welcomeBack.tr()}, Karim !",
            style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: fontSize * 1.5,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: cardWidth / 220,
                children: [
                  FadeInDown(
                    child: HomeCards(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.weedDetection);
                      },
                      title: AppStrings.weedDetection.tr(),
                      subtitle: AppStrings.weedCardDesc.tr(),
                      icon: Icons.eco,
                      color: AppColor.primaryColor,
                      fontSize: fontSize,
                    ),
                  ),
                  FadeInDown(
                    child: HomeCards(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.waterPumpRoute);
                      },
                      title: AppStrings.waterPump.tr(),
                      subtitle: AppStrings.pumpCardDesc.tr(),
                      icon: Icons.water_drop,
                      color: AppColor.blue,
                      fontSize: fontSize,
                    ),
                  ),
                  FadeInUp(
                    delay: Duration(milliseconds: 200),
                    child: HomeCards(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.motorRoute);
                      },
                      title: AppStrings.pivotMotor.tr(),
                      subtitle:
                          AppStrings.motorDescription.tr(),
                      icon: Icons.power_settings_new_rounded,
                      color: AppColor.redColor,
                      fontSize: fontSize,
                    ),
                  ),
                  FadeInUp(
                    delay: Duration(milliseconds: 200),
                    child: HomeCards(
                      onTap: () {},
                      title: AppStrings.farmMonitoring.tr(),
                      subtitle: AppStrings.farmMonitoringDescription.tr(),
                      icon: Icons.video_camera_back_outlined,
                      color: AppColor.black,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SoilCard(screenWidth: screenWidth, fontSize: fontSize),
          ],
        ),
      ),
    );
  }
}
