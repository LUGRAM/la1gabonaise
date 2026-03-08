import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingProgressDots extends StatelessWidget {
  final int total;
  final int current;

  const OnboardingProgressDots({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isDone = i <= current;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 3,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
