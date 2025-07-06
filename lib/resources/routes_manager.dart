import '../features/motor/presentation/pages/motor_screen.dart';
import '../features/splash/splash_screen.dart';

import '../features/water_pump/presentation/pages/water_pump_screen.dart';
import 'app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../features/auth/presentation/pages/sign_in_screen.dart';
import '../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/weed_detection/presentation/pages/weed_detection_screen.dart';

class Routes {
  static const String splashScreen = "/";
  static const String onboardingRoute = "/onboarding";
  static const String signInRoute = "/signin";
  static const String signUpRoute = "/singup";
  static const String homeRoute = "/home";
  static const String waterPumpRoute = "/water_pump";
  static const String weedDetection = "/weed_detection";
  static const String motorRoute = "/motor_route";

static Map<String, dynamic> routesList = {
  onboardingRoute: const OnboardingScreen(),
  splashScreen: const SplashScreen(), 
  homeRoute: HomeScreen(),
  signInRoute: const SignInScreen(),
  signUpRoute: const SignUpScreen(),
  waterPumpRoute: WaterPumpScreen(),
  weedDetection: WeedDetectionScreen(),
  motorRoute:  MotorScreen(),
};

  static Scaffold get unDefinedRoute {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: Text(AppStrings.noRouteFound[NoRoute.title.index]),
      ),
      body: Center(child: Text(AppStrings.noRouteFound[NoRoute.body.index])),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    if (settings.name != null) {
      try {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => Routes.routesList[settings.name]);
      } on Exception {
        return _unDefinedRoute();
      }
    } else {
      return _unDefinedRoute();
    }
  }

  static MaterialPageRoute _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Routes.unDefinedRoute,
    );
  }
}
