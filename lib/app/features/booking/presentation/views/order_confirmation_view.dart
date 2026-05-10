import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/utils/formatters.dart';
import 'package:bersih_in/app/core/widgets/custom_button.dart';
import 'package:bersih_in/app/core/widgets/loading_overlay.dart';
import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/booking/presentation/controllers/booking_controller.dart';
import 'package:bersih_in/app/features/booking/presentation/widgets/step_indicator.dart';

class OrderConfirmationView extends GetView<BookingController> {
  const OrderConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive PriceEstimateModel from arguments
    final PriceEstimateModel? estimate =
        Get.arguments as PriceEstimateModel?;

    if (estimate != null) {
      controller.setPriceEstimate(estimate);
    }

    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.orderConfirmTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: estimate == null
              ? const Center(
                  child: Text('Data estimasi tidak tersedia'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator
                      const StepIndicator(
                        currentStep: 2,
                        totalSteps: 3,
                        stepLabels: [
                          AppStrings.step1,
                          AppStrings.step2,
                          AppStrings.step3,
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingLG),

                      // Price card
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingLG),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMD),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              AppStrings.estimatedPrice,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatRupiah(
                                  estimate.estimatedPrice),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingLG),

                      // Details card
                      Card(
                        elevation: 0,
                        color: AppColors.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              AppDimensions.paddingMD),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                AppStrings.dirtLevel,
                                estimate.dirtLevel,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                AppStrings.roomSize,
                                '${estimate.roomSizeM2.toInt()} m²',
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                AppStrings.extraServices,
                                estimate.extras.isEmpty
                                    ? 'Tidak ada'
                                    : estimate.extras
                                        .map((e) =>
                                            _extraLabel(e))
                                        .join(', '),
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                AppStrings.estimatedDuration,
                                Formatters.formatDuration(
                                    estimate.estimatedMinutes),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingLG),

                      // Partner info
                      Card(
                        elevation: 0,
                        color: AppColors.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              AppDimensions.paddingMD),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.success
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Siti Rahayu',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified_rounded,
                                          size: 14,
                                          color: AppColors.success,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          AppStrings.partnerVerified,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),

                      // Confirm button
                      CustomButton(
                        text: AppStrings.confirmOrder,
                        onPressed: controller.submitOrder,
                        icon: const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
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
