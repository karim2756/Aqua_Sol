
import 'package:animate_do/animate_do.dart';
import 'package:aqua_sol/features/home/domain/entities/soil_entity.dart';
import 'package:aqua_sol/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../resources/app_color.dart';
import '../../../../resources/app_strings.dart';
import '../cubit/soil_cubit.dart';

class SoilCard extends StatelessWidget {
  final double screenWidth;
  final double fontSize;

  const SoilCard({
    super.key,
    required this.screenWidth,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SoilCubit>()..getSoilStatus(), // auto-fetch soil data
      child: BlocBuilder<SoilCubit, SoilState>(
        builder: (context, state) {
          if (state is SoilLoaded) {
            return _buildSoilCard(context, state.soil);
          } else if (state is SoilError) {
            return _buildErrorCard(context);
          }
          return _buildLoadingCard();
        },
      ),
    );
  }

  Widget _buildSoilCard(BuildContext context, SoilEntity soil) {
    return FadeInLeft(
      animate: true,
      delay: const Duration(seconds: 1),
      child: Container(
        width: screenWidth,
        margin: const EdgeInsets.only(top: 10),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: soil.hasInternet
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.statisticsAndResults.tr(),
                        style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColor.greenColor)),
                    Icon(Icons.bar_chart,
                        color: AppColor.greenColor,
                        size: fontSize * 1.5),
                  ],
                ),
                const SizedBox(height: 10),
                Text("${AppStrings.status.tr()}: ${soil.status.tr()}",
                    style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: AppColor.black)),
                Text("${AppStrings.moisture.tr()}: ${soil.moistureValue.toInt()}%",
                    style: TextStyle(
                        fontSize: fontSize * 0.9,
                        color: AppColor.primaryColor)),
                const SizedBox(height: 15),
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: (soil.moistureValue.clamp(0, 100)) / 100,
                    ),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 8,
                              backgroundColor: AppColor.lightGreenColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.primaryColor),
                            ),
                          ),
                          Text("${soil.moistureValue.toInt()}%",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            )
                : _buildNoInternetCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildNoInternetCard() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.wifi_off, color: Colors.red, size: fontSize * 2),
          const SizedBox(height: 8),
          Text(AppStrings.noInternet.tr(),
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: fontSize * 2),
          const SizedBox(height: 8),
          Text(AppStrings.noInternet.tr(),
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.red,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>context.read<SoilCubit>().reset()
            ,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
            ),
            child: Text(
              AppStrings.retry.tr(),
              style: TextStyle(color: AppColor.whiteColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Center(
      child: CircularProgressIndicator(color: AppColor.primaryColor),
    );
  }
}