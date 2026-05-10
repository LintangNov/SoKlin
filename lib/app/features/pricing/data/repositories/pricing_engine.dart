import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/pricing/data/repositories/pricing_repository_base.dart';

/// Pure-Dart pricing engine — contains all math but zero TFLite dependency.
///
/// Used directly in unit tests and as a delegate by [PricingRepository].
/// Exposed `@visibleForTesting` helpers allow granular unit testing.
class PricingEngine implements PricingRepositoryBase {
  // ---------------------------------------------------------------------------
  // StandardScaler constants from the Python training script.
  // UPDATE THESE after running the Colab training notebook (scaler.mean_ / scaler.scale_).
  // ---------------------------------------------------------------------------
  static const List<double> scalerMean = [14.5, 1.0, 0.5, 0.5];
  static const List<double> scalerStd = [6.3, 0.82, 0.5, 0.5];

  static const List<double> scalerYMean = [34605.9905, 60.4205]; 
  static const List<double> scalerYStd = [12821.9332, 21.023];

  // ---------------------------------------------------------------------------
  // PricingRepositoryBase implementation
  // ---------------------------------------------------------------------------

  double inverseTransformPrice(double normalizedPrice) {
    return (normalizedPrice * scalerYStd[0]) + scalerYMean[0];
  }

  double inverseTransformDuration(double normalizedDuration) {
    return (normalizedDuration * scalerYStd[1]) + scalerYMean[1];
  }

  @override
  Future<PriceEstimateModel> calculatePrice({
    required double roomSizeM2,
    required int dirtLevelIndex,
    required List<String> extras,
    required String dirtLevel,
  }) async {
    final bool extraBathroom = extras.contains('extra_bathroom');
    final bool extraDishes = extras.contains('extra_dishes');

    final price =
        fallbackPrice(roomSizeM2, dirtLevelIndex, extraBathroom, extraDishes);
    final duration = calculateDuration(
      roomSizeM2: roomSizeM2,
      dirtLevelIndex: dirtLevelIndex,
      extraBathroom: extraBathroom,
      extraDishes: extraDishes,
    );

    return PriceEstimateModel(
      roomSizeM2: roomSizeM2,
      dirtLevel: dirtLevel,
      dirtLevelIndex: dirtLevelIndex,
      extras: extras,
      estimatedPrice: price,
      estimatedMinutes: duration,
    );
  }

  // ---------------------------------------------------------------------------
  // Pure-math helpers (no TFLite) — used by PricingRepository as delegate
  // ---------------------------------------------------------------------------

  /// Normalizes a raw feature vector using the pre-trained StandardScaler constants.
  ///
  /// Formula: z = (x − μ) / σ
  List<double> normalizeInput(
    double roomSizeM2,
    int dirtLevelIndex,
    bool extraBathroom,
    bool extraDishes,
  ) {
    final raw = [
      roomSizeM2,
      dirtLevelIndex.toDouble(),
      extraBathroom ? 1.0 : 0.0,
      extraDishes ? 1.0 : 0.0,
    ];

    return List.generate(
      raw.length,
      (i) => (raw[i] - scalerMean[i]) / scalerStd[i],
    );
  }

  /// Deterministic fallback price when TFLite model is unavailable.
  double fallbackPrice(
    double roomSizeM2,
    int dirtLevelIndex,
    bool extraBathroom,
    bool extraDishes,
  ) {
    final raw = 20000 +
        (roomSizeM2 * 1200) +
        (dirtLevelIndex * 12000) +
        (extraBathroom ? 18000 : 0) +
        (extraDishes ? 10000 : 0);

    final rounded = (raw / 1000).round() * 1000.0;
    return rounded.clamp(20000.0, 70000.0);
  }

  /// Duration formula — also used directly by [PricingRepository].
  int calculateDuration({
    required double roomSizeM2,
    required int dirtLevelIndex,
    required bool extraBathroom,
    required bool extraDishes,
  }) {
    final d = 30 +
        (roomSizeM2 * 2.5).round() +
        (dirtLevelIndex * 20) +
        (extraBathroom ? 15 : 0) +
        (extraDishes ? 15 : 0);
    return d.clamp(30, 180);
  }

  /// Clamps and rounds a raw TFLite output price.
  double postProcessPrice(double rawPrice) {
    final clamped = rawPrice.clamp(20000.0, 70000.0);
    return (clamped / 1000).round() * 1000.0;
  }
}
