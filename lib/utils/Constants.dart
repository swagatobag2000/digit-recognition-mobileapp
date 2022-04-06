import 'package:flutter/material.dart';

class Constants {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double borderSize = 4;
  static int mnistImageSize = 28;
  static double strokeWidth = 15;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth * 0.9;
    blockSizeVertical = screenHeight * 0.6;
  }
}