import 'package:aqua_sol/core/network_info.dart';
import 'package:aqua_sol/features/water_pump/domain/usecases/get_pump_status_usecase.dart';
import 'package:aqua_sol/features/water_pump/domain/usecases/toggle_pump_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import '../cubit/water_pump_cubit.dart';
import '../../data/repositories/water_pump_repository_impl.dart';
import '../../data/datasources/water_pump_remote_data_source.dart';

class WaterPumpScreen extends StatelessWidget {
  const WaterPumpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WaterPumpCubit(
        getPumpStatus: GetPumpStatus(
          WaterPumpRepositoryImpl(
            remoteDataSource: WaterPumpRemoteDataSource(),
            networkInfo: NetworkInfoImpl(
              Connectivity(),
              InternetConnectionChecker.createInstance(),
            ),
          ),
        ),
        togglePump: TogglePump(
          WaterPumpRepositoryImpl(
            remoteDataSource: WaterPumpRemoteDataSource(),
            networkInfo: NetworkInfoImpl(
              Connectivity(),
              InternetConnectionChecker.createInstance(),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: Text(
            AppStrings.waterPump.tr(),
            style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<WaterPumpCubit, WaterPumpState>(
          listener: (context, state) {
            if (state is WaterPumpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.locNetworkError.tr())));
            }
          },
          builder: (context, state) {
            final cubit = context.read<WaterPumpCubit>();
            final isPumpOn = state is WaterPumpLoaded ? state.pump.isOn : false;
            final isLoading = state is WaterPumpLoading;
            final isError = state is WaterPumpError;

            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;
            double fontSize = screenWidth * 0.075;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/pump.png',
                    width: screenWidth * 1.2,
                    height: screenHeight * 0.4,
                    fit: BoxFit.contain,
                    color: isError ? Colors.grey : null,
                    colorBlendMode: isError ? BlendMode.saturation : null,
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.theDeviceNowIs.tr(),
                          style: TextStyle(
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold,
                            color: AppColor.lightBlack,
                          ),
                        ),
                        TextSpan(
                          text: isPumpOn
                              ? AppStrings.working.tr()
                              : AppStrings.notWorking.tr(),
                          style: TextStyle(
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.bold,
                            color: isPumpOn
                                ? AppColor.greenColor
                                : AppColor.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Toggle button with error handling
                  if (isError)
                    ElevatedButton(
                      onPressed: () => cubit.getInitialStatus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                      ),
                      child: Text(
                        AppStrings.retry.tr(),
                        style: TextStyle(color: AppColor.whiteColor),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        if (!isLoading) {
                          cubit.togglePumpStatus(!isPumpOn);
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.21,
                            decoration: BoxDecoration(
                              color: isPumpOn ? AppColor.greenColor : AppColor.redColor,
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

                        ],
                      ),
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