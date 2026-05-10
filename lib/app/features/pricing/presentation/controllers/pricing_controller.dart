import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/pricing/domain/usecases/calculate_price_usecase.dart';
import 'package:bersih_in/app/routes/app_routes.dart';

class PricingController extends GetxController {
  final CalculatePriceUseCase _calculatePriceUseCase;

  PricingController(this._calculatePriceUseCase);

  // ---------------------------------------------------------------------------
  // Observables
  // ---------------------------------------------------------------------------

  final isCalculating = true.obs;
  final priceResult = Rxn<PriceEstimateModel>();

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _runCalculation();
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  Future<void> _runCalculation() async {
    final args = Get.arguments;

    if (args == null || args is! Map) {
      debugPrint('[PricingController] No arguments received — cannot calculate.');
      isCalculating.value = false;
      return;
    }

    final map = args as Map<String, dynamic>;

    final roomSize = (map['roomSize'] as num?)?.toDouble() ?? 10.0;
    final extras =
        (map['extras'] as List?)?.cast<String>() ?? <String>[];
    final dirtLevel = map['dirtLevel'] as String? ?? 'Sedang';
    final dirtLevelIndex = map['dirtLevelIndex'] as int? ?? 1;

    try {
      final result = await _calculatePriceUseCase(
        roomSizeM2: roomSize,
        dirtLevelIndex: dirtLevelIndex,
        extras: extras,
        dirtLevel: dirtLevel,
      );
      priceResult.value = result;
    } catch (e) {
      debugPrint('[PricingController] Calculation error: $e');
      Get.snackbar(
        'Estimasi Gagal',
        'Terjadi kesalahan. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Passes the computed [PriceEstimateModel] to [OrderConfirmationView].
  void confirmAndProceed() {
    final result = priceResult.value;
    if (result == null) return;
    Get.toNamed(AppRoutes.ORDER_CONFIRM, arguments: result);
  }
}
