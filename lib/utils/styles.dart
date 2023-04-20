import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primary,
    useMaterial3: true,
    fontFamily: 'ProductRegular',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.black,
      ),
      headlineMedium: TextStyle(
        color: AppColors.black,
      ),
      headlineSmall: TextStyle(
        color: AppColors.black,
      ),
      displayLarge: TextStyle(
        color: AppColors.black,
      ),
      displayMedium: TextStyle(
        color: AppColors.black,
      ),
      displaySmall: TextStyle(
        color: AppColors.black,
      ),
      titleLarge: TextStyle(
        color: AppColors.black,
      ),
      titleMedium: TextStyle(
        color: AppColors.black,
      ),
      titleSmall: TextStyle(
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(
        color: AppColors.black,
      ),
      bodyMedium: TextStyle(
        color: AppColors.black,
      ),
      bodySmall: TextStyle(
        color: AppColors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(error: AppColors.errorColor),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.black,
    primaryColor: AppColors.white,
    useMaterial3: true,
    primarySwatch: AppColors.primarySwatch,
    fontFamily: 'ProductRegular',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(error: AppColors.errorColor),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.white,
      ),
      headlineMedium: TextStyle(
        color: AppColors.white,
      ),
      headlineSmall: TextStyle(
        color: AppColors.white,
      ),
      bodyLarge: TextStyle(
        color: AppColors.white,
      ),
      displayLarge: TextStyle(
        color: AppColors.white,
      ),
      displayMedium: TextStyle(
        color: AppColors.white,
      ),
      displaySmall: TextStyle(
        color: AppColors.white,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        color: AppColors.white,
      ),
      titleSmall: TextStyle(
        color: AppColors.white,
      ),
      bodyMedium: TextStyle(
        color: AppColors.white,
      ),
      bodySmall: TextStyle(
        color: AppColors.white,
      ),
    ),
  );
}

class StaticComponent{

  static heightSizedBox(int height){
    return SizedBox(
      height: ScreenUtil().setHeight(height),
    );
  }
}