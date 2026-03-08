import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // Display (Playfair)
  static const TextStyle display1 = TextStyle(
    fontFamily: 'Playfair',
    fontSize: 32, fontWeight: FontWeight.w900,
    color: AppColors.textPrimary, height: 1.15,
  );
  static const TextStyle display2 = TextStyle(
    fontFamily: 'Playfair',
    fontSize: 26, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );
  static const TextStyle display3 = TextStyle(
    fontFamily: 'Playfair',
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, height: 1.2,
  );

  // Heading (Sora)
  static const TextStyle h1 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle h3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  // Body
  static const TextStyle body1 = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.6);
  static const TextStyle body2 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.6);
  static const TextStyle bodySmall = TextStyle(fontSize: 11, color: AppColors.textMuted);

  // Label / Mono
  static const TextStyle label = TextStyle(
    fontFamily: 'monospace', fontSize: 9,
    fontWeight: FontWeight.w600, letterSpacing: 2.5,
    color: AppColors.textMuted,
  );
  static const TextStyle labelRed = TextStyle(
    fontFamily: 'monospace', fontSize: 9,
    fontWeight: FontWeight.w600, letterSpacing: 2.5,
    color: AppColors.primary,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700,
    letterSpacing: 0.5, color: Colors.white,
  );
  static const TextStyle buttonSm = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
