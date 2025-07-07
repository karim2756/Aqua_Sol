import 'dart:io';

import 'package:aqua_sol/features/weed_detection/domain/entities/weed_detection_entity.dart';
import 'package:aqua_sol/features/weed_detection/presentation/cubit/weed_detection_cubit.dart';
import 'package:aqua_sol/resources/app_color.dart';
import 'package:aqua_sol/resources/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildResultView(
    BuildContext context,
    WeedDetectionEntity detection,
    double screenWidth,
    double screenHeight,
    WeedDetectionCubit cubit,
    ) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final fontSize = screenWidth * 0.05;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (detection.imageFile != null)
        Image.file(
          detection.imageFile!,
          width: screenWidth,
          height: screenHeight * 0.4,
          fit: BoxFit.fitWidth,
        ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Text(
          detection.label.tr(),
          style: TextStyle(
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${isArabic ? 'الاسم العلمي' : 'Scientific name'}:",
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[700],
              ),
            ),
            Text(
              detection.scientificName.tr(),
              style: TextStyle(
                fontSize: fontSize * 0.94,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      Divider(color: AppColor.lightGreyColor, thickness: 5),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(
              Icons.energy_savings_leaf_rounded,
              color: Colors.green,
              size: fontSize * 1.4,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              AppStrings.description.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          detection.description.tr(),
          style: TextStyle(fontSize: fontSize * 0.9),
        ),
      ),
      Spacer(),
      Divider(color: AppColor.black, thickness: 0.5),
      Center(
        child: GestureDetector(
          onTap: () => _pickImage(context, ImageSource.gallery, cubit),
          child: Column(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: Colors.purple,
                size: fontSize * 1.4,
              ),
              Text(
                AppStrings.newText.tr(),
                style: TextStyle(color: Colors.purple),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
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