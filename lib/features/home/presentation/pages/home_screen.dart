import 'package:android_intent_plus/android_intent.dart';
import 'package:animate_do/animate_do.dart';
import 'package:aqua_sol/features/home/presentation/widgets/home_cards.dart';
import 'package:aqua_sol/features/home/presentation/widgets/soil_card.dart';
import 'package:flutter/services.dart';
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
    final Uri liveStreamUrl = Uri.parse('http://172.20.10.5:5000/viewer');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aqua Sol",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColor.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      drawer: Drawer(
        width: 250, // ✅ Reduce drawer width (default is 304 on phones)
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.whiteColor,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "${AppStrings.welcomeBack.tr()},\nKarim!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.whiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.translate),
              title: Text(
                context.locale.languageCode == 'en'
                    ? AppStrings.english
                    : AppStrings.arabic,
              ),
              onTap: () {
                final currentLocale = context.locale;
                final newLocale = currentLocale.languageCode == 'en'
                    ? Locale('ar')
                    : Locale('en');
                context.setLocale(newLocale);
                Navigator.of(context).pop(); // close the drawer
              },
            ),
          ],
        ),
      ),
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
                      subtitle: AppStrings.motorDescription.tr(),
                      icon: Icons.power_settings_new_rounded,
                      color: AppColor.redColor,
                      fontSize: fontSize,
                    ),
                  ),
                  FadeInUp(
                    delay: Duration(milliseconds: 200),
                    child: HomeCards(
                      onTap: () async {
                        try {
                          final intent = AndroidIntent(
                            action: 'action_view',
                            data: liveStreamUrl.toString(),
                            package: 'com.android.chrome',
                          );
                          await intent.launch();
                        } on PlatformException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColor.redColor,
                              content: Text(
                                "❌ Google Chrome غير مثبت على هذا الجهاز",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                      },
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
