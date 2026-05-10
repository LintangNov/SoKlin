import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/utils/formatters.dart';
import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/pricing/presentation/controllers/pricing_controller.dart';

/// Displays the full price breakdown for a booking estimate.
///
/// Shows dirt level badge, booking details, duration, price, and action buttons.
class PriceBreakdownCard extends StatelessWidget {
  final PriceEstimateModel model;

  const PriceBreakdownCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PricingController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dirt level badge
          _buildDirtBadge(),
          const SizedBox(height: AppDimensions.spacingLG),

          // Details card
          Card(
            elevation: AppDimensions.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              child: Column(
                children: [
                  _DetailRow(
                    label: AppStrings.roomSize,
                    value: '${model.roomSizeM2.toInt()} m²',
                  ),
                  const Divider(height: 28, color: AppColors.divider),
                  _DetailRow(
                    label: AppStrings.dirtLevel,
                    value: model.dirtLevel,
                    valueColor: _colorForLevel(model.dirtLevelIndex),
                  ),
                  const Divider(height: 28, color: AppColors.divider),
                  _DetailRow(
                    label: AppStrings.extraServices,
                    value: model.extras.isEmpty
                        ? 'Tidak ada'
                        : model.extras.map(_extraLabel).join(', '),
                  ),
                  const Divider(height: 28, color: AppColors.divider),
                  _DetailRow(
                    label: AppStrings.estimatedDuration,
                    value: Formatters.formatDuration(model.estimatedMinutes),
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),

          // Price highlight card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  AppStrings.estimatedPrice,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(model.estimatedPrice),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSM),

          // Disclaimer note
          const Text(
            '* Harga dapat berbeda berdasarkan kondisi aktual',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),

          // Confirm button
          SizedBox(
            height: AppDimensions.buttonHeight,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.confirmAndProceed,
              icon: const Icon(Icons.check_circle_rounded, size: 20),
              label: const Text(AppStrings.confirmOrder),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),

          // Back to camera button
          SizedBox(
            height: AppDimensions.buttonHeightSM,
            width: double.infinity,
            child: TextButton.icon(
              onPressed: Get.back,
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text('Ulangi Foto'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets
  // ---------------------------------------------------------------------------

  Widget _buildDirtBadge() {
    final color = _colorForLevel(model.dirtLevelIndex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconForLevel(model.dirtLevelIndex), color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            model.dirtLevel,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Color _colorForLevel(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF27AE60);
      case 1:
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFFE74C3C);
    }
  }

  IconData _iconForLevel(int index) {
    switch (index) {
      case 0:
        return Icons.check_circle_rounded;
      case 1:
        return Icons.warning_amber_rounded;
      default:
        return Icons.cancel_rounded;
    }
  }

  String _extraLabel(String extra) {
    switch (extra) {
      case 'extra_bathroom':
        return AppStrings.extraBathroom;
      case 'extra_dishes':
        return AppStrings.extraDishes;
      default:
        return extra;
    }
  }
}

// ---------------------------------------------------------------------------
// Private helper widget
// ---------------------------------------------------------------------------

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
