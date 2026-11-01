/// GharHold Design Tokens.
/// Exact palette, typography, spacing and radii from system_design.md.
library;

import 'package:flutter/material.dart';

abstract final class GharHoldColors {
  static const Color forestInk = Color(0xFF163300);
  static const Color limeVoltage = Color(0xFF9FE870);
  static const Color spruce = Color(0xFF054D28);
  static const Color linenMist = Color(0xFFE2F6D5);
  static const Color signalBlue = Color(0xFF0B4C72);
  static const Color alarmRed = Color(0xFFCB272F);
  static const Color charcoal = Color(0xFF454745);
  static const Color obsidian = Color(0xFF0E0F0C);
  static const Color pebble = Color(0xFF868685);
  static const Color slate = Color(0xFF6A6C6A);
  static const Color fog = Color(0xFFE8EBE6);
  static const Color paper = Color(0xFFFFFFFF);
}

abstract final class GharHoldSpacing {
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s56 = 56.0;
  static const double s64 = 64.0;
}

abstract final class GharHoldRadii {
  static const double pill = 9999.0;
  static const double card = 10.0;
  static const double input = 10.0;
  static const double largeCard = 28.0;

  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(input),
  );
  static const BorderRadius largeCardRadius = BorderRadius.all(
    Radius.circular(largeCard),
  );
}

abstract final class GharHoldTypography {
  static const TextStyle micro = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.63,
    color: GharHoldColors.slate,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.55,
    color: GharHoldColors.slate,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: GharHoldColors.charcoal,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.50,
    color: GharHoldColors.charcoal,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25,
    fontWeight: FontWeight.w600,
    height: 1.30,
    color: GharHoldColors.forestInk,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: GharHoldColors.obsidian,
  );
}
