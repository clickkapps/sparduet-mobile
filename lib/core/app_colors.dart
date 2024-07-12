import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color desire = Color(0xFFE93354);
  static const Color buttonBlue = Color(0xFF29B6F6);
  static const Color navyBlue = Color(0xFF1a73e8);
  static const Color oldSilver = Color(0xFF828282);
  static const Color onlineGreen = Color(0xFF0ff446);

  static const MaterialColor black = MaterialColor(
    darkColor,
    <int, Color>{
      200: Color(0xff383d40),
      300: Color(0xff1d2226),
      400: Color(0xff202021),
      500: Color(darkColor),
    },
  );
  static const int darkColor = 0xff101010;


  static const MaterialColor white = MaterialColor(
    lightColor,
    <int, Color>{
      200: Color(0xffEDF0F5),
      300: Color(0xFFCCCCCC),
      400: Color(0xfff2f1f6),
      500: Color(lightColor),
    },
  );
  static const int lightColor = 0xFFFFFFFF;


  //! Color Scheme for Dark Mode
  static ColorScheme get darkColorScheme {
    return   ColorScheme.dark(
        background: AppColors.black,
        onBackground: AppColors.white,
        surface: AppColors.black.shade300,
        onSurface: oldSilver,
        outline: black.shade200,
        outlineVariant: black.shade200,
    );
  }

  //! Color Scheme for Light Mode
  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      background: AppColors.white.shade400,
      onBackground: AppColors.black,
      surface: AppColors.white,
      onSurface: oldSilver,
      outline: white.shade300,
      outlineVariant: white.shade200
    );
  }

}