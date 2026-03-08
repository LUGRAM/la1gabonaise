import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';
import '../../../app/theme/app_colors.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Fond gradienté
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A0003), AppColors.bg],
              ),
            ),
          ),
          // Logo centré
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo avec animation pulsation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.85, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        maxLines: 1,
                        text: const TextSpan(children: [
                          TextSpan(text: 'LA',
                              style: TextStyle(fontFamily: 'Playfair', fontSize: 52,
                                  fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                          TextSpan(text: '1',
                              style: TextStyle(fontFamily: 'Playfair', fontSize: 52,
                                  fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 4)),
                          TextSpan(text: 'GABONAISE',
                              style: TextStyle(fontFamily: 'Playfair', fontSize: 52,
                                  fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ICI C\'EST MADE IN GABON',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11, letterSpacing: 4,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Loader en bas
          const Positioned(
            bottom: 60, left: 0, right: 0,
            child: Center(
              child: SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ),
          // Flag Gabon subtile en bas
          const Positioned(
            bottom: 32, left: 0, right: 0,
            child: Center(
              child: Text(
                '🇬🇦',
                style: TextStyle(fontSize: 18, letterSpacing: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}