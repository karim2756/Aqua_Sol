import 'package:aqua_sol/resources/app_color.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:aqua_sol/resources/routes_manager.dart';
import 'package:aqua_sol/shared/custom_text_field.dart';
import 'package:aqua_sol/shared/text_form_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../signup/presentation/widgets/title_field_style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
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
              context,
              Routes.homeRoute,
              (route) => false,
            );
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.16),
                    Text(
                      AppStrings.register.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      AppStrings.singupDescription.tr(),
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: AppColor.greyColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.username.tr(),
                              style: titleFieldStyle(screenWidth)),
                          SizedBox(height: screenHeight * 0.008),
                          CustomTextField(
                            hintText: AppStrings.yourName.tr(),
                            prefixIcon: Icons.person,
                            controller: nameController,
                            validator: validateUsername,
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          Text(AppStrings.email.tr(),
                              style: titleFieldStyle(screenWidth)),
                          SizedBox(height: screenHeight * 0.008),
                          CustomTextField(
                            hintText: AppStrings.yourEmail.tr(),
                            prefixIcon: Icons.email,
                            controller: emailController,
                            validator: validateEmail,
                          ),
                          SizedBox(height: screenHeight * 0.02),

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

                          // Sign Up Button
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
                                  context.read<AuthCubit>().signUp(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        nameController.text.trim(),
                                      );
                                }
                              },
                              child: state is AuthLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      AppStrings.signup.tr(),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: AppColor.whiteColor,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Already have account?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.haveAccount.tr(),
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.signInRoute);
                                },
                                child: Text(
                                  AppStrings.login.tr(),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
