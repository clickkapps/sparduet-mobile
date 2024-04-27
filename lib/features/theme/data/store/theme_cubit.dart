import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/theme/data/repositories/theme_repository.dart';
import 'package:sparkduet/features/theme/data/store/enums.dart';
import 'package:sparkduet/features/theme/data/store/theme_state.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCubit extends Cubit<ThemeState> {

  final ThemeRepository themeRepository;
  ThemeCubit({required this.themeRepository}): super(ThemeState(
    themeData: _lightMode.copyWith(textTheme: _quicksandLightTextTheme),
    appFont: AppFont.quicksand
  ));

  void setDarkMode() {
    final fontType = state.appFont;
    late TextTheme selectedTextTheme;
    if(fontType == AppFont.spaceMono) {
      selectedTextTheme = _spaceMonoDarkTextTheme;
    }else if (fontType == AppFont.robotoSlab) {
      selectedTextTheme = _robotoSlabDarkTextTheme;
    }else  {
      selectedTextTheme = _quicksandDarkTextTheme;
    }
    emit(state.copyWith(themeData: _darkMode.copyWith(textTheme: selectedTextTheme)));
  }

  void setLightMode() {
    final fontType = state.appFont;
    late TextTheme selectedTextTheme;
    if(fontType == AppFont.spaceMono) {
      selectedTextTheme = _spaceMonoLightTextTheme;
    }else if (fontType == AppFont.robotoSlab) {
      selectedTextTheme = _robotoSlabLightTextTheme;
    }else  {
      selectedTextTheme = _quicksandLightTextTheme;
    }
    emit(state.copyWith(themeData: _lightMode.copyWith(textTheme: selectedTextTheme)));
  }

  //! light mode theme
  static ThemeData get _lightMode {
    return ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        colorScheme: AppColors.lightColorScheme.copyWith(
          primary: AppColors.desire,
          onPrimary: Colors.white,
          secondary: AppColors.buttonBlue,
          onSecondary: AppColors.white
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightColorScheme.background,
          foregroundColor: AppColors.lightColorScheme.onBackground
        ),
        scaffoldBackgroundColor: AppColors.lightColorScheme.background,

    );
  }

  //! dark mode theme
  static ThemeData get _darkMode {
    return ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        colorScheme: AppColors.darkColorScheme.copyWith(
          primary: AppColors.desire,
          onPrimary: Colors.white,
          secondary: AppColors.buttonBlue,
          onSecondary: AppColors.white
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkColorScheme.background,
          foregroundColor: AppColors.darkColorScheme.onBackground
        ),
        scaffoldBackgroundColor: AppColors.darkColorScheme.background,
    );
  }


  // //! Set the theme primary color to begonia, heliotrope, electricBlue
  // void setThemePrimaryColor(Color color) {
  //   emit(state.copyWith(
  //       themeData: state.themeData?.copyWith(colorScheme: state.themeData?.colorScheme.copyWith(primary: color))
  //   ));
  // }

  void setFont(AppFont font) {
    final inDarkMode = state.themeData?.brightness == Brightness.dark;
    if (font == AppFont.spaceMono) {
      emit(state.copyWith(themeData: state.themeData?.copyWith(textTheme: inDarkMode ? _spaceMonoDarkTextTheme : _spaceMonoLightTextTheme)));
    }else if (font == AppFont.robotoSlab) {
      emit(state.copyWith(themeData: state.themeData?.copyWith(textTheme: inDarkMode ? _robotoSlabDarkTextTheme : _robotoSlabLightTextTheme)));
    }else {
      emit(state.copyWith(themeData: state.themeData?.copyWith(textTheme: inDarkMode ? _quicksandDarkTextTheme : _quicksandLightTextTheme)));
    }
  }

  void setSystemUIOverlaysToDark({Color? androidSystemNavigationBarColor}) {
    setSystemUIOverlays(
        androidSystemNavigationBarColor: androidSystemNavigationBarColor ?? AppColors.darkColorScheme.background,
        androidSystemNavigationBarIconBrightness: Brightness.light,
        androidStatusBarIconBrightness: Brightness.light
    );
  }

  void setSystemUIOverlaysToLight({Color? androidSystemNavigationBarColor, Brightness? androidStatusBarIconBrightness}) {
    setSystemUIOverlays(
        androidSystemNavigationBarColor: androidSystemNavigationBarColor ?? AppColors.lightColorScheme.surface,
        androidSystemNavigationBarIconBrightness: Brightness.dark,
        androidStatusBarIconBrightness: androidStatusBarIconBrightness ?? Brightness.dark,
    );
  }

  void setSystemUIOverlaysToPrimary() {
    setSystemUIOverlays(
      androidSystemNavigationBarColor: state.themeData?.colorScheme.primary,
      androidSystemNavigationBarIconBrightness: Brightness.light,
      androidStatusBarIconBrightness: Brightness.light,
      iosStatusBarBrightness: Brightness.dark
    );
  }

  /// UI overlay -> Configure app status bar and android navigation bar here
  void setSystemUIOverlays({Color? androidSystemNavigationBarColor, Brightness? androidSystemNavigationBarIconBrightness, Brightness? androidStatusBarIconBrightness, Brightness? iosStatusBarBrightness}) {
    final brightness = state.themeData?.brightness;
    final  systemOverlayStyle = brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    SystemChrome.setSystemUIOverlayStyle(systemOverlayStyle.copyWith(
      statusBarColor: Colors.transparent, // android only
      // statusBarColor: brightness == Brightness.dark  ? kBlack : kWhite, // android only
      statusBarIconBrightness: androidStatusBarIconBrightness ?? (brightness == Brightness.dark ? Brightness.light : Brightness.dark), // android only
      systemNavigationBarColor: androidSystemNavigationBarColor ?? state.themeData?.colorScheme.background, // android only
      systemNavigationBarIconBrightness: androidSystemNavigationBarIconBrightness ?? (brightness == Brightness.dark ? Brightness.light : Brightness.dark), // android only
      statusBarBrightness: iosStatusBarBrightness ?? (brightness == Brightness.dark ? Brightness.dark : Brightness.light), // ios only
    ));
  }

  static TextTheme get _quicksandLightTextTheme {
    // final textTheme = GoogleFonts.kumbhSansTextTheme();
    final textTheme = GoogleFonts.latoTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color: _titleLargeColors.$1),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$1),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$1),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$1),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$1),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$1),
    );
  }

  static TextTheme get _quicksandDarkTextTheme {
    // final textTheme = GoogleFonts.kumbhSansTextTheme();
    final textTheme = GoogleFonts.latoTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color: _titleLargeColors.$2),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$2),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$2),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$2),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$2),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$2),
    );
  }

  static TextTheme get _spaceMonoLightTextTheme {
    final textTheme = GoogleFonts.spaceMonoTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color: _titleLargeColors.$1),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$1),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$1),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$1),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$1),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$1),
    );
  }

  static TextTheme get _spaceMonoDarkTextTheme {
    final textTheme = GoogleFonts.spaceMonoTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color: _titleLargeColors.$2),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$2),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$2),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$2),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$2),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$2),
    );
  }


  static TextTheme get _robotoSlabLightTextTheme {
    final textTheme = GoogleFonts.robotoSlabTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color:_titleLargeColors.$1),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$1),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$1),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$1),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$1),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$1),
    );
  }

  static TextTheme get _robotoSlabDarkTextTheme {
    final textTheme = GoogleFonts.robotoSlabTextTheme();
    return textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(color: _titleLargeColors.$2),
        titleMedium: textTheme.titleMedium?.copyWith(color: _titleMediumColors.$2),
        titleSmall: textTheme.titleSmall?.copyWith(color: _titleSmallColors.$2),

        bodyLarge: textTheme.bodyLarge?.copyWith(color: _bodyLargeColors.$2),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: _bodyMediumColors.$2),
        bodySmall: textTheme.bodySmall?.copyWith(color: _bodySmallColors.$2),
    );
  }


  static (Color, Color) get _titleLargeColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }
  static (Color, Color) get _titleMediumColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }

  static (Color, Color) get _titleSmallColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }

  static (Color, Color) get _bodyLargeColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }
  static (Color, Color) get _bodyMediumColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }

  static (Color, Color) get _bodySmallColors {
    return (AppColors.lightColorScheme.onBackground, AppColors.darkColorScheme.onBackground);
  }


}