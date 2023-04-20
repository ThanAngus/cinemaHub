import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF1D1E18);
  static const Color grey = Color(0xFF808D8E);
  static const Color primary = Color(0xFFF28482);
  static const Color white = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF1D4E89);
  static const Color errorColor = Color(0xFF720E07);
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF1A3517,
    <int, Color>{
      50: Color(0xFFFDF0F0),
      100: Color(0xFFFBDADA),
      200: Color(0xFFF9C2C1),
      300: Color(0xFFF6A9A8),
      400: Color(0xFFF49695),
      500: Color(0xFFF28482),
      600: Color(0xFFF07C7A),
      700: Color(0xFFEE716F),
      800: Color(0xFFEC6765),
      900: Color(0xFFE85452),
    },
  );
}

class MyBehavior extends ScrollBehavior {

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;

  }
}