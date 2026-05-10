import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/pricing/data/repositories/pricing_engine.dart';
import 'package:bersih_in/app/features/pricing/data/repositories/pricing_repository_base.dart';

/// Handles dynamic price estimation using a TFLite model.
///
/// Delegates all pure-math operations to [PricingEngine].
/// Falls back to [PricingEngine.fallbackPrice] when the model is missing.
class PricingRepository implements PricingRepositoryBase {
  final PricingEngine _engine;

  PricingRepository({PricingEngine? engine})
      : _engine = engine ?? PricingEngine();

  Interpreter? _interpreter;

  // ---------------------------------------------------------------------------
  // PricingRepositoryBase implementation
  // ---------------------------------------------------------------------------

  @override
  Future<PriceEstimateModel> calculatePrice({
    required double roomSizeM2,
    required int dirtLevelIndex,
    required List<String> extras,
    required String dirtLevel,
  }) async {
    final bool extraBathroom = extras.contains('extra_bathroom');
    final bool extraDishes = extras.contains('extra_dishes');

    await _loadModel();

    double estimatedPrice;

    if (_interpreter != null) {
      estimatedPrice =
          _runInference(roomSizeM2, dirtLevelIndex, extraBathroom, extraDishes);
    } else {
      estimatedPrice = _engine.fallbackPrice(
          roomSizeM2, dirtLevelIndex, extraBathroom, extraDishes);
    }

    final int estimatedMinutes = _engine.calculateDuration(
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
      estimatedPrice: estimatedPrice,
      estimatedMinutes: estimatedMinutes,
    );
  }

  // ---------------------------------------------------------------------------
  // Internal — model loading (lazy singleton)
  // ---------------------------------------------------------------------------

  Future<void> _loadModel() async {
    if (_interpreter != null) return;
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/pricing_model.tflite',
      );
      debugPrint('[PricingRepository] TFLite model loaded successfully.');
    } catch (e) {
      debugPrint(
        '[PricingRepository] Model unavailable — using fallback formula. Error: $e',
      );
      _interpreter = null;
    }
  }

  // ---------------------------------------------------------------------------
  // Internal — TFLite inference
  // ---------------------------------------------------------------------------

  double _runInference(
    double roomSizeM2,
    int dirtLevelIndex,
    bool extraBathroom,
    bool extraDishes,
  ) {
    final normalized = _engine.normalizeInput(
        roomSizeM2, dirtLevelIndex, extraBathroom, extraDishes);

    final input = [normalized]; // shape [1, 4]
    
    final output = List.generate(1, (_) => List.filled(2, 0.0));

    _interpreter!.run(input, output);

    double rawNormalizedPrice = output[0][0];

    double realPrice = _engine.inverseTransformPrice(rawNormalizedPrice);

    return _engine.postProcessPrice(realPrice);
  }
}
