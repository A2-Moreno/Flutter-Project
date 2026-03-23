import 'package:flutter/material.dart';

//Metodo para crear una curva decorativa en la parte superior de la pantalla
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

  // Altura donde empieza la curva
    double startY = size.height * 0.6;

    // Qué tan profunda es la curva
    double curveDepth = size.height * 0.45;

    path.lineTo(0, startY);

    path.quadraticBezierTo(
      size.width / 2,
      startY + curveDepth,
      size.width,
      startY,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}