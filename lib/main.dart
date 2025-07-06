import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  // await dotenv.load(fileName: ".env");
  await di.init();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale("ar"),
      Locale("en"),
    ],
    fallbackLocale: const Locale('ar'),
    saveLocale: true,
    startLocale: const Locale('en'),
    path: 'assets/translations',
    child: const AquaSol(),
  ));
}
