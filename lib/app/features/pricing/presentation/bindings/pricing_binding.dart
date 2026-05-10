import 'package:get/get.dart';

import 'package:bersih_in/app/features/pricing/data/repositories/pricing_repository.dart';
import 'package:bersih_in/app/features/pricing/domain/usecases/calculate_price_usecase.dart';
import 'package:bersih_in/app/features/pricing/presentation/controllers/pricing_controller.dart';

/// Registers all Pricing dependencies.
///
/// NOTE: This binding is not yet wired in app_pages.dart for the PRICE_RESULT
/// route. [PriceEstimationView] self-registers via [Get.put] as a workaround.
/// Dev A can optionally add `binding: PricingBinding()` to that route.
class PricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PricingRepository>(() => PricingRepository());
    Get.lazyPut<CalculatePriceUseCase>(
      () => CalculatePriceUseCase(Get.find()),
    );
    Get.lazyPut<PricingController>(
      () => PricingController(Get.find()),
    );
  }
}
