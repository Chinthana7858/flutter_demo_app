import 'package:flutter/material.dart';

class ScreenSize {
  static late double width;
  static late double height;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
  }
}
