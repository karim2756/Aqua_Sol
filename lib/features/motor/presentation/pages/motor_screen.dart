import '../../../../injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import '../cubit/motor_cubit.dart';

class MotorScreen extends StatelessWidget {
  const MotorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MotorCubit>()..getInitialStatus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: Text(
            AppStrings.pivotMotor.tr(),
            style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<MotorCubit, MotorState>(
          listener: (context, state) {
            if (state is MotorError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.tr())),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<MotorCubit>();
            final isMotorOn = state is MotorLoaded ? state.motor.isOn : false;
            final isLoading = state is MotorLoading;
            final isError = state is MotorError;

            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            double fontSize = screenWidth * 0.06;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Motor image
                  Image.asset(
                    AppStrings.motorImage,
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.4,
                    fit: BoxFit.contain,
                    color: isError ? Colors.grey : null,
                    colorBlendMode: isError ? BlendMode.saturation : null,
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  if (isError)
                    Column(
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: screenWidth * 0.13,
                          color: AppColor.redColor,
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        ElevatedButton(
                          onPressed: () => cubit.getInitialStatus(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                          ),
                          child: Text(
                            AppStrings.retry.tr(),
                            style: TextStyle(color: AppColor.whiteColor),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        // Status text
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppStrings.motorNowIs.tr(),
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              TextSpan(
                                text: isMotorOn
                                    ? AppStrings.motorWorking.tr()
                                    : AppStrings.motorNotWorking.tr(),
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: isMotorOn
                                      ? AppColor.greenColor
                                      : AppColor.redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // Toggle button with loading indicator
                        SizedBox(
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.21,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!isLoading) {
                                    HapticFeedback.lightImpact();
                                    cubit.toggleMotor(!isMotorOn);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: isMotorOn
                                        ? AppColor.greenColor
                                        : AppColor.redColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.black,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.power_settings_new,
                                    size: screenWidth * 0.1,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
