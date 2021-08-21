import 'package:flutter/material.dart';

import 'colors.dart';

/// This clas [Themes] provides theme data for the common usage in the app
class Themes {
  static final ThemeData appTheme = ThemeData(
    primarySwatch: AppColors.primaryColor,
    primaryColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
  );
}
