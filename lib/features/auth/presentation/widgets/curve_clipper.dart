import 'package:flutter/material.dart';

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
