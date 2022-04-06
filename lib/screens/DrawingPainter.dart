import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/models/DrawingArea.dart';
import 'package:mnistdigitrecognizer/utils/Constants.dart';

import 'DrawScreen.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingArea> points;
  List<Offset> offsetPoints = [];

  DrawingPainter(this.points);

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.black
    ..strokeWidth = Constants.strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        //Drawing line when two consecutive points are available
        canvas.drawLine(
            points[i].point, points[i + 1].point, points[i].areaPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[i].point);
        offsetPoints
            .add(Offset(points[i].point.dx + 0.1, points[i].point.dy + 0.1));

        //Draw points when two points are not next to each other
        canvas.drawPoints(PointMode.points, offsetPoints, points[i].areaPaint);
      }
    }
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
