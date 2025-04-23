import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/routes_manager.dart';
import '../../../../shared/custom_text_field.dart';
import '../../../../shared/text_form_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../signup/presentation/widgets/title_field_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ClipPath with Image
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                height: screenHeight * 0.35, // Responsive height
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login image.png"),
                    fit: BoxFit.cover, // Ensures full coverage
                  ),
                ),
              ),
            ),
            Text(
              AppStrings.welcomeBack.tr(),
              style: TextStyle(
                fontSize: screenWidth * 0.07, // Responsive font size
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              AppStrings.loginDescription.tr(),
              style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Form with validation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.email.tr(),
                      style: titleFieldStyle(screenWidth),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    CustomTextField(
                      hintText: AppStrings.yourEmail.tr(),
                      prefixIcon: Icons.email,
                      controller: emailController,
                      validator: validateEmail,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(AppStrings.password.tr(),
                        style: titleFieldStyle(screenWidth)),
                    SizedBox(height: screenHeight * 0.008),
                    CustomTextField(
                      isPassword: true,
                      hintText: AppStrings.yourPassword.tr(),
                      prefixIcon: Icons.lock_rounded,
                      controller: passwordController,
                      validator: validatePassword,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.homeRoute,
                              (route) => false,
                            );
                          } 
                        }, // Calls validation
                        child: Text(
                          AppStrings.login.tr(),
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccount.tr(),
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.signUpRoute);
                          },
                          child: Text(
                            AppStrings.signup.tr(),
                            style: TextStyle(
                              color: AppColor.greenColor,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for the Curved Image
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80); // Lower dip
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 80, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
