import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVar,
      highlightColor: AppColors.surfaceHigh,
      child: Container(
        width: width, height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVar,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class AppShimmerCard extends StatelessWidget {
  final double width;
  final double height;

  const AppShimmerCard({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVar,
      highlightColor: AppColors.surfaceHigh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width, height: height,
            decoration: BoxDecoration(
              color: AppColors.surfaceVar,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 6),
          Container(width: width * 0.7, height: 10, color: AppColors.surfaceVar),
          const SizedBox(height: 4),
          Container(width: width * 0.5, height: 8, color: AppColors.surfaceVar),
        ],
      ),
    );
  }
}
