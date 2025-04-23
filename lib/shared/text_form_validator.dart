// Validation function
import 'package:easy_localization/easy_localization.dart';

import '../resources/app_strings.dart';

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.pleaseEnterYourUsername.tr();
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.pleaseEnterYourEmail.tr();
  }
  final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!regex.hasMatch(value)) {
    return AppStrings.pleaseEnterAValidEmail.tr();
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return AppStrings.pleaseEnterYourPass.tr();
  }
  if (value.length < 6) {
    return AppStrings.passwordMustBe.tr();
  }
  return null;
}
