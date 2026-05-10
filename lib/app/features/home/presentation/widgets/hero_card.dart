import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';

class HeroCard extends StatelessWidget {
  final VoidCallback onOrderPressed;

  const HeroCard({super.key, required this.onOrderPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cleaning_services_rounded,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),

          // Headline
          const Text(
            AppStrings.heroHeadline,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSM),

          // Subtitle
          Text(
            AppStrings.heroSubtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: onOrderPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.flash_on_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(AppStrings.orderNow),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
