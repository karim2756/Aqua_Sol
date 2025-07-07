import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/routes_manager.dart';
import '../../../../shared/custom_text_field.dart';
import '../../../../shared/text_form_validator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/curve_clipper.dart';
import '../widgets/title_field_style.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.homeRoute, (route) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColor.redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      height: screenHeight * 0.35, 
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/login image.png"),
                          fit: BoxFit.cover, 
                        ),
                      ),
                    ),
                  ),
                  Text(
                    AppStrings.welcomeBack.tr(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.email.tr(),
                              style: titleFieldStyle(screenWidth)),
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
                                  context.read<AuthCubit>().signIn(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                }
                              },
                              child: state is AuthLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
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
        },
      ),
    );
  }
}
