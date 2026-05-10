import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/features/booking/presentation/widgets/step_indicator.dart';
import 'package:bersih_in/app/features/pricing/data/repositories/pricing_repository.dart';
import 'package:bersih_in/app/features/pricing/domain/usecases/calculate_price_usecase.dart';
import 'package:bersih_in/app/features/pricing/presentation/controllers/pricing_controller.dart';
import 'package:bersih_in/app/features/pricing/presentation/views/widgets/price_breakdown_card.dart';

/// Step 3 of 3 — Dynamic price estimation screen.
///
/// Replaces the Dev A stub. Self-registers [PricingController] because
/// app_pages.dart does not attach a binding to the PRICE_RESULT route.
/// Dev A can optionally add `binding: PricingBinding()` there to follow
/// the standard project pattern.
class PriceEstimationView extends StatelessWidget {
  const PriceEstimationView({super.key});

  // ---------------------------------------------------------------------------
  // Controller self-registration
  // ---------------------------------------------------------------------------

  PricingController _obtainController() {
    if (Get.isRegistered<PricingController>()) {
      return Get.find<PricingController>();
    }

    final repo = Get.isRegistered<PricingRepository>()
        ? Get.find<PricingRepository>()
        : Get.put(PricingRepository());

    final useCase = Get.isRegistered<CalculatePriceUseCase>()
        ? Get.find<CalculatePriceUseCase>()
        : Get.put(CalculatePriceUseCase(repo));

    return Get.put(PricingController(useCase));
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final controller = _obtainController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimasi Harga'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: Column(
        children: [
          // Step indicator — Step 3 of 3
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.paddingLG,
              AppDimensions.paddingMD,
              AppDimensions.paddingLG,
              0,
            ),
            child: const StepIndicator(
              currentStep: 2,
              totalSteps: 3,
              stepLabels: [
                AppStrings.step1,
                AppStrings.step2,
                AppStrings.step3,
              ],
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isCalculating.value) {
                return const _LoadingBody();
              }

              final result = controller.priceResult.value;
              if (result == null) {
                return const Center(
                  child: Text(
                    'Data estimasi tidak tersedia.\nSilakan kembali dan coba lagi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return PriceBreakdownCard(model: result);
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widget: Loading state
// ---------------------------------------------------------------------------

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          const Text(
            'Menghitung estimasi...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'AI sedang menganalisis data booking Anda',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
