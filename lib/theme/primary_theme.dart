import 'styled_colors.dart';
import 'package:flutter/material.dart';

abstract class PrimaryTheme {
  PrimaryTheme._();
  static ThemeData generateTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: StyledColors.PRIMARY_COLOR,
      backgroundColor: StyledColors.APP_BACKGROUND,
      scaffoldBackgroundColor: StyledColors.APP_BACKGROUND,
      dialogBackgroundColor: StyledColors.APP_BACKGROUND,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0x1e939393),
        hintStyle: TextStyle(
          color: Color(0x998E8E93),
          fontWeight: FontWeight.w400,
          fontSize: 16.5,
        ),
        filled: true,
        contentPadding: new EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        isDense: true,
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: StyledColors.APP_BACKGROUND,
        elevation: 0,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          indicator: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          )),
    );
  }
}
