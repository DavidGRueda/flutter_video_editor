import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appThemeData = ThemeData(
  // -----------------------------------------------
  //                  Colors
  // -----------------------------------------------
  primaryColor: CustomColors.primary,
  primaryColorLight: CustomColors.primaryLight,
  hintColor: CustomColors.hint,
  disabledColor: CustomColors.disabled,

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: CustomColors.primary,
    onPrimary: Colors.white,
    secondary: CustomColors.hint,
    onSecondary: Colors.white,
    error: CustomColors.error,
    onError: Colors.white,
    background: CustomColors.backgroundLight,
    onBackground: CustomColors.textLight,
    surface: CustomColors.backgroundLight,
    onSurface: CustomColors.textLight,
  ),

  // -----------------------------------------------
  //                  Widget Styles
  // -----------------------------------------------
  scaffoldBackgroundColor: CustomColors.backgroundLight,

  appBarTheme: AppBarTheme(
    color: CustomColors.backgroundLight,
    elevation: 0.0,
    actionsIconTheme: IconThemeData(
      color: CustomColors.textLight,
    ),
    shape: Border(
      bottom: BorderSide(
        color: CustomColors.backgroundDark.withOpacity(0.1),
        width: 1.0,
      ),
    ),
  ),

  tabBarTheme: TabBarTheme(
    labelColor: CustomColors.textLight,
    tabAlignment: TabAlignment.start,
    unselectedLabelColor: CustomColors.textLight.withOpacity(0.75),
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: CustomColors.primary,
        width: 4.0,
      ),
    ),
  ),

  sliderTheme: SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CustomColors.primaryLight,
    foregroundColor: Colors.white,
    iconSize: 30.0,
  ),

  // -----------------------------------------------
  //                  Text Styles
  // -----------------------------------------------
  fontFamily: 'Century Gothic',
  textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textLight,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textLight,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textLight,
      ),
      bodySmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textLight,
      ),
      labelSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textLight,
      )),
);

final ThemeData appThemeDataDark = ThemeData(
  // -----------------------------------------------
  //                  Colors
  // -----------------------------------------------
  primaryColor: CustomColors.primary,
  primaryColorLight: CustomColors.primaryLight,
  hintColor: CustomColors.hint,
  disabledColor: CustomColors.disabled,

  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: CustomColors.primary,
    onPrimary: Colors.white,
    secondary: CustomColors.hint,
    onSecondary: Colors.white,
    error: CustomColors.error,
    onError: Colors.white,
    background: CustomColors.backgroundDark,
    onBackground: CustomColors.textDark,
    surface: CustomColors.backgroundDark,
    onSurface: CustomColors.textDark,
  ),

  // -----------------------------------------------
  //                  Widget Styles
  // -----------------------------------------------
  scaffoldBackgroundColor: CustomColors.backgroundDark,

  appBarTheme: AppBarTheme(
    color: CustomColors.backgroundDark,
    elevation: 0.0,
    actionsIconTheme: IconThemeData(
      color: CustomColors.textLight,
    ),
    shape: Border(
      bottom: BorderSide(
        color: CustomColors.textDark.withOpacity(0.1),
        width: 1.0,
      ),
    ),
  ),

  tabBarTheme: TabBarTheme(
    labelColor: CustomColors.textDark,
    tabAlignment: TabAlignment.start,
    unselectedLabelColor: CustomColors.textDark.withOpacity(0.75),
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: CustomColors.primary,
        width: 4.0,
      ),
    ),
  ),

  sliderTheme: SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: CustomColors.primaryLight,
    foregroundColor: Colors.white,
    iconSize: 30.0,
  ),

  // -----------------------------------------------
  //                  Text Styles
  // -----------------------------------------------
  fontFamily: 'Century Gothic',
  textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textDark,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: CustomColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textDark,
      ),
      bodySmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textDark,
      ),
      labelSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: CustomColors.textDark,
      )),
);
