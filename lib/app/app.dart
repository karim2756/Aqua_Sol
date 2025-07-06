import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_screen.dart';
import '../resources/routes_manager.dart';

class AquaSol extends StatelessWidget {
  const AquaSol({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: DevicePreview.appBuilder,
      initialRoute: Routes.splashScreen, 
      home: HomeScreen(),
      onGenerateRoute:
          RouteGenerator.getRoute, // Use RouteGenerator for navigation
    );
  }
}
