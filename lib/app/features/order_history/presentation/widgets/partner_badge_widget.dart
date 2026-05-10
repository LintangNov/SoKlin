import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';

class PartnerBadgeWidget extends StatelessWidget {
  final String partnerName;
  final bool partnerVerified;

  const PartnerBadgeWidget({
    super.key,
    required this.partnerName,
    required this.partnerVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: partnerVerified
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: partnerVerified
                    ? AppColors.success
                    : AppColors.textHint,
                size: 28,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMD),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.partnerInfo,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    partnerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (partnerVerified) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '✓ ${AppStrings.partnerVerified}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
