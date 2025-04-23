import 'package:aqua_sol/resources/app_color.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:aqua_sol/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _toggleLanguage() {
    String currentLang = context.locale.toString();
    if (currentLang == 'en') {
      context.setLocale(Locale('ar'));
    } else {
      context.setLocale(Locale('en'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    List<Map<String, String>> onboardingData = [
      {
        "image": "assets/images/onboarding1.png",
        "title": AppStrings.onboardingOneTitle.tr(),
        "description": AppStrings.onboardingOneDescription.tr()
      },
      {
        "image": "assets/images/onboarding2.png",
        "title": AppStrings.onboardingTwoTitle.tr(),
        "description": AppStrings.onboardingTwoDescription.tr()
      },
      {
        "image": "assets/images/onboarding3.png",
        "title": AppStrings.onboardingThreeTitle.tr(),
        "description": AppStrings.onboardingThreeDescription.tr()
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: GestureDetector(
              onTap: _toggleLanguage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.translate,
                    color: AppColor.primaryColor,
                    size: screenWidth * 0.07,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    context.locale.toString() == AppStrings.en
                        ? AppStrings.english
                        : AppStrings.arabic,
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onboardingData[index]["image"]!,
                        height: screenHeight * 0.4,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text(
                        onboardingData[index]["title"]!,
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        onboardingData[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: AppColor.greyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => buildDot(index),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (_currentIndex < onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      } else {
                        Navigator.pushNamed(context, Routes.loginRoute);
                      }
                    },
                    child: Text(
                      _currentIndex == onboardingData.length - 1
                          ? AppStrings.getStarted.tr()
                          : AppStrings.next.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: _currentIndex == index ? 12 : 8,
      height: _currentIndex == index ? 12 : 8,
      decoration: BoxDecoration(
        color:
            _currentIndex == index ? AppColor.primaryColor : AppColor.greyColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
