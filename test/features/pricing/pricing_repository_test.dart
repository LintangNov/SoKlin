// Tests for the pricing logic use [PricingEngine], which is a pure-Dart class
// with no TFLite dependency. This avoids the native FFI compilation issue that
// tflite_flutter has in the host-side test VM.
//
// The TFLite-specific code path (Interpreter loading) is exercised at runtime
// on a real device/emulator where native libs are available.

import 'package:flutter_test/flutter_test.dart';

import 'package:bersih_in/app/features/pricing/data/repositories/pricing_engine.dart';

void main() {
  late PricingEngine engine;

  setUp(() {
    engine = PricingEngine();
  });

  // ---------------------------------------------------------------------------
  // 1. Ringan + 10m² + no extras → fallback price in Rp 20.000–Rp 35.000
  // ---------------------------------------------------------------------------
  test(
    'Ringan + 10m² + no extras → price between Rp 20.000 and Rp 35.000',
    () {
      // Fallback: 20000 + (10 * 1200) + (0 * 12000) + 0 + 0 = 32.000
      final price = engine.fallbackPrice(10.0, 0, false, false);

      expect(
        price,
        inInclusiveRange(20000.0, 35000.0),
        reason: 'Ringan + 10m² should give a light cleaning price',
      );
      expect(price, equals(32000.0), reason: 'Exact formula: 20000 + 12000');
    },
  );

  // ---------------------------------------------------------------------------
  // 2. Berat + 25m² + both extras → price clamped to Rp 70.000
  // ---------------------------------------------------------------------------
  test(
    'Berat + 25m² + both extras → price between Rp 50.000 and Rp 70.000',
    () {
      // Raw: 20000 + 30000 + 24000 + 18000 + 10000 = 102.000 → clamped to 70.000
      final price = engine.fallbackPrice(25.0, 2, true, true);

      expect(
        price,
        inInclusiveRange(50000.0, 70000.0),
        reason: 'Must stay within max cap of Rp 70.000',
      );
      expect(price, equals(70000.0), reason: 'Should be clamped at max cap');
    },
  );

  // ---------------------------------------------------------------------------
  // 3. Duration for 15m² Sedang (no extras) → between 60 and 90 minutes
  // ---------------------------------------------------------------------------
  test(
    'Duration for 15m² Sedang + no extras is between 60 and 90 minutes',
    () {
      // duration = 30 + (15 * 2.5).round() + (1 * 20) + 0 + 0
      //          = 30 + 38 + 20 = 88 minutes
      final duration = engine.calculateDuration(
        roomSizeM2: 15.0,
        dirtLevelIndex: 1,
        extraBathroom: false,
        extraDishes: false,
      );

      expect(
        duration,
        inInclusiveRange(60, 90),
        reason: 'Medium room with Sedang dirt should take 60–90 min',
      );
      expect(duration, equals(88), reason: 'Exact: 30 + 38 + 20 = 88');
    },
  );

  // ---------------------------------------------------------------------------
  // 4. Normalization: mean values → components normalize to 0
  // ---------------------------------------------------------------------------
  test(
    'Normalization of mean values: room_size and dirt_level normalize to 0',
    () {
      // scalerMean = [14.5, 1.0, 0.5, 0.5]
      // scalerStd  = [6.3,  0.82, 0.5, 0.5]
      // z[0] = (14.5 - 14.5) / 6.3  = 0.0
      // z[1] = (1.0  - 1.0)  / 0.82 = 0.0
      // z[2] = (0.0  - 0.5)  / 0.5  = -1.0  (extraBathroom = false → 0.0)
      // z[3] = (0.0  - 0.5)  / 0.5  = -1.0  (extraDishes   = false → 0.0)
      final normalized = engine.normalizeInput(14.5, 1, false, false);

      expect(
        normalized[0],
        closeTo(0.0, 1e-9),
        reason: 'room_size at mean should normalize to 0',
      );
      expect(
        normalized[1],
        closeTo(0.0, 1e-9),
        reason: 'dirt_level_index at mean should normalize to 0',
      );
      expect(
        normalized[2],
        closeTo(-1.0, 1e-9),
        reason: 'extra_bathroom=false normalizes to (0-0.5)/0.5 = -1',
      );
      expect(
        normalized[3],
        closeTo(-1.0, 1e-9),
        reason: 'extra_dishes=false normalizes to (0-0.5)/0.5 = -1',
      );
    },
  );

  // ---------------------------------------------------------------------------
  // 5. Fallback formula exact arithmetic
  // ---------------------------------------------------------------------------
  test(
    'Fallback formula produces correct Rp values for various inputs',
    () {
      // Ringan + 8m² + no extras: 20000 + 9600 = 29600 → rounded 30000
      expect(engine.fallbackPrice(8.0, 0, false, false), equals(30000.0));

      // Sedang + 12m² + bathroom only: 20000 + 14400 + 12000 + 18000 = 64400 → 64000
      expect(engine.fallbackPrice(12.0, 1, true, false), equals(64000.0));

      // Berat + 5m² + no extras: 20000 + 6000 + 24000 = 50000
      expect(engine.fallbackPrice(5.0, 2, false, false), equals(50000.0));
    },
  );

  // ---------------------------------------------------------------------------
  // 6. calculatePrice end-to-end (uses fallback path via PricingEngine)
  // ---------------------------------------------------------------------------
  test(
    'calculatePrice returns valid PriceEstimateModel with fallback formula',
    () async {
      final result = await engine.calculatePrice(
        roomSizeM2: 10.0,
        dirtLevelIndex: 0,
        extras: <String>[],
        dirtLevel: 'Ringan',
      );

      expect(result.estimatedPrice, inInclusiveRange(20000.0, 70000.0));
      expect(result.estimatedMinutes, inInclusiveRange(30, 180));
      expect(result.dirtLevel, equals('Ringan'));
      expect(result.roomSizeM2, equals(10.0));
      expect(result.dirtLevelIndex, equals(0));
      expect(result.extras, isEmpty);
    },
  );
}
