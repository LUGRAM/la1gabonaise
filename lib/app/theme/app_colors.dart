import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary      = Color(0xFFD0021B);
  static const Color primaryLight = Color(0xFFE8031F);
  static const Color primaryDark  = Color(0xFF8B0000);
  static const Color primaryGlow  = Color(0x33D0021B);

  // Background
  static const Color bg           = Color(0xFF0A0A0A);
  static const Color surface      = Color(0xFF111111);
  static const Color surfaceVar   = Color(0xFF1C1C1C);
  static const Color surfaceHigh  = Color(0xFF252525);

  // Text
  static const Color textPrimary  = Color(0xFFF2F2F2);
  static const Color textMuted    = Color(0xFF888888);
  static const Color textSecondary = Color(0xFFBBBBBB);
  static const Color textDisabled = Color(0xFF444444);

  // Border
  static const Color border       = Color(0xFF2A2A2A);
  static const Color borderLight  = Color(0xFF1E1E1E);

  // Status
  static const Color success      = Color(0xFF27AE60);
  static const Color warning      = Color(0xFFF2994A);
  static const Color error        = Color(0xFFEB5757);
  static const Color info         = Color(0xFF2F80ED);

  // Plans
  static const Color gold         = Color(0xFFF5A623);

  // Overlay
  static const Color overlayDark  = Color(0xCC000000);

  // Gradients
  static const LinearGradient heroGrad = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xF50A0A0A)],
    stops: [0.35, 1.0],
  );

  static const LinearGradient redGrad = LinearGradient(
    colors: [Color(0xFFD0021B), Color(0xFFE8031F)],
  );
}