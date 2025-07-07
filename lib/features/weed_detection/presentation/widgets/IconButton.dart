import 'package:aqua_sol/resources/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildIconButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    double fontSize,
    ) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.whiteColor,
          child: Icon(icon, color: AppColor.greenColor, size: 30),
        ),
      ),
      SizedBox(height: 10),
      Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
      ),
    ],
  );
}