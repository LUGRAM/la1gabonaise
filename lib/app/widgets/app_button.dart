import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { filled, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool loading;
  final Widget? prefixIcon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.filled,
    this.loading = false,
    this.prefixIcon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == AppButtonVariant.filled;
    final isOutline = variant == AppButtonVariant.outline;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: isFilled ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isOutline ? Border.all(color: AppColors.border) : null,
            ),
            alignment: Alignment.center,
            child: loading
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 8)],
                      Text(
                        label,
                        style: AppTextStyles.button.copyWith(
                          color: isFilled
                              ? Colors.white
                              : isOutline
                                  ? AppColors.textMuted
                                  : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
