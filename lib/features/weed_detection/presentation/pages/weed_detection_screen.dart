
import 'package:aqua_sol/features/weed_detection/presentation/widgets/InitialView.dart';
import 'package:aqua_sol/features/weed_detection/presentation/widgets/LoadingView.dart';
import 'package:aqua_sol/features/weed_detection/presentation/widgets/ResultView.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_color.dart';
import '../../../../injection_container.dart';
import '../cubit/weed_detection_cubit.dart';

class WeedDetectionScreen extends StatelessWidget {
  const WeedDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeedDetectionCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          title: Text(
            AppStrings.weedDetection.tr(),
            style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<WeedDetectionCubit, WeedDetectionState>(
          listener: (context, state) {
            if (state is WeedDetectionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.tr())),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<WeedDetectionCubit>();
            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;

            if (state is WeedDetectionLoading) {
            return  buildLoadingView(screenHeight);
            } else if (state is WeedDetectionLoaded) {
              return buildResultView(
                context,
                state.detection,
                screenWidth,
                screenHeight,
                cubit,
              );
            } else {
              return buildInitialView(
                context,
                screenWidth,
                screenHeight,
                cubit,
              );
            }
          },
        ),
      ),
    );
  }








}