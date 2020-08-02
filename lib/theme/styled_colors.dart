import 'package:flutter/material.dart';

class StyledColors {
  static const PRIMARY_COLOR = const Color.fromRGBO(102, 0, 153, 1);
  static const BUTTON_TEXT_PRIMARY = const Color(0xEAFFFFFF);
  static const DIALOG_BACKGROUND_SEPARATOR = Color(0x90D1D1D1);
  static const APP_BACKGROUND = const Color(0xEAFFFFFF);
  static const APP_BAR_TEXT = const Color(0xff020202);
  static const NAVIGATION_BAR_ICON_INACTIVE = Color(0x66000000);

  static Color primaryColor(double opacity){
    return Color.fromRGBO(102, 0, 153, opacity);
  }

}
