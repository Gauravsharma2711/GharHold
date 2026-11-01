/// GharHold theme configuration matching system_design.md.
library;

import 'package:flutter/material.dart';
import 'tokens.dart';

class GharHoldTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: GharHoldColors.paper,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: GharHoldColors.forestInk,
        onPrimary: GharHoldColors.paper,
        secondary: GharHoldColors.limeVoltage,
        onSecondary: GharHoldColors.forestInk,
        error: GharHoldColors.alarmRed,
        onError: GharHoldColors.paper,
        surface: GharHoldColors.paper,
        onSurface: GharHoldColors.charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: GharHoldColors.paper,
        foregroundColor: GharHoldColors.forestInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: GharHoldColors.forestInk,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: GharHoldColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: GharHoldRadii.cardRadius,
          side: BorderSide(color: GharHoldColors.fog, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: GharHoldColors.paper,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: GharHoldRadii.inputRadius,
          borderSide: BorderSide(color: GharHoldColors.pebble, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: GharHoldRadii.inputRadius,
          borderSide: BorderSide(color: GharHoldColors.pebble, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GharHoldRadii.inputRadius,
          borderSide: BorderSide(color: GharHoldColors.forestInk, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: GharHoldRadii.inputRadius,
          borderSide: BorderSide(color: GharHoldColors.alarmRed, width: 1.5),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: GharHoldColors.slate,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: GharHoldColors.pebble,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: GharHoldColors.paper,
        selectedItemColor: GharHoldColors.forestInk,
        unselectedItemColor: GharHoldColors.slate,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 4,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
