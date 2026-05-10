import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/widgets/custom_button.dart';
import 'package:bersih_in/app/features/booking/presentation/controllers/booking_controller.dart';
import 'package:bersih_in/app/features/booking/presentation/widgets/extra_service_chip.dart';
import 'package:bersih_in/app/features/booking/presentation/widgets/step_indicator.dart';

class BookingFormView extends GetView<BookingController> {
  const BookingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookingTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            const StepIndicator(
              currentStep: 0,
              totalSteps: 3,
              stepLabels: [
                AppStrings.step1,
                AppStrings.step2,
                AppStrings.step3,
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Room size section
            const Text(
              AppStrings.roomSize,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),

            // Room size card
            Card(
              elevation: 0,
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                child: Column(
                  children: [
                    // Current value display
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSM),
                        ),
                        child: Text(
                          '${controller.roomSizeM2.value.toInt()} m²',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Slider
                    Obx(
                      () => Slider(
                        value: controller.roomSizeM2.value,
                        min: AppDimensions.roomSizeMin,
                        max: AppDimensions.roomSizeMax,
                        divisions: 45,
                        label: '${controller.roomSizeM2.value.toInt()} m²',
                        onChanged: controller.setRoomSize,
                      ),
                    ),

                    // Min-max labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '5 m²',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                        Text(
                          '50 m²',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // Extra services
            const Text(
              AppStrings.extraServices,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            const Text(
              'Pilih layanan tambahan yang kamu butuhkan',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            Obx(
              () => Wrap(
                spacing: AppDimensions.spacingSM,
                runSpacing: AppDimensions.spacingSM,
                children: [
                  ExtraServiceChip(
                    label: AppStrings.extraBathroom,
                    value: 'extra_bathroom',
                    isSelected: controller.selectedExtras
                        .contains('extra_bathroom'),
                    onTap: () => controller.toggleExtra('extra_bathroom'),
                  ),
                  ExtraServiceChip(
                    label: AppStrings.extraDishes,
                    value: 'extra_dishes',
                    isSelected:
                        controller.selectedExtras.contains('extra_dishes'),
                    onTap: () => controller.toggleExtra('extra_dishes'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXL),

            // Continue button
            CustomButton(
              text: AppStrings.continueToCamera,
              onPressed: controller.proceedToCamera,
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
