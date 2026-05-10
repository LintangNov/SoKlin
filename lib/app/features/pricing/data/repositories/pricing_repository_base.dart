import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';

/// Abstract contract for price calculation.
///
/// [PricingRepository] is the real implementation (uses TFLite).
/// [FallbackPricingRepository] can be used in tests without native binaries.
abstract class PricingRepositoryBase {
  Future<PriceEstimateModel> calculatePrice({
    required double roomSizeM2,
    required int dirtLevelIndex,
    required List<String> extras,
    required String dirtLevel,
  });
}
