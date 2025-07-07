import 'dart:io';

import 'package:aqua_sol/features/weed_detection/presentation/cubit/weed_detection_cubit.dart';
import 'package:aqua_sol/features/weed_detection/presentation/widgets/IconButton.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildInitialView(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    WeedDetectionCubit cubit,
    ) {
  final picker = ImagePicker();
  final fontSize = screenWidth * 0.05;

  return Column(
    children: [
      Stack(
        children: [
          Image.asset(
            'assets/images/weed_detection_background.png',
            width: screenWidth,
            height: screenHeight * 0.6,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              AppStrings.makeSureImageInFocus.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      const Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildIconButton(
            Icons.camera_alt,
            AppStrings.camera.tr(),
                () => _pickImage(context, ImageSource.camera, cubit),
            fontSize,
          ),
          SizedBox(width: screenWidth * 0.1),
          buildIconButton(
            Icons.photo_library,
            AppStrings.gallery.tr(),
                () => _pickImage(context, ImageSource.gallery, cubit),
            fontSize,
          ),
        ],
      ),
      SizedBox(height: screenHeight * 0.05),
    ],
  );
}
Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    WeedDetectionCubit cubit,
    ) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    cubit.detectFromImage(File(pickedFile.path));
  }
}