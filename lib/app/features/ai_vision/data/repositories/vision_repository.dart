import 'dart:io';
import 'dart:math';

import 'package:bersih_in/app/features/ai_vision/data/models/dirt_level_result.dart';

/// Handles classification of room cleanliness from an image.
///
/// **DUMMY IMPLEMENTATION** — This repository returns randomized results
/// to simulate a real AI vision model during the MVP phase.
///
/// TODO: replace with real TFLite inference when model is ready.
/// When replacing, only this class changes — all controllers, use cases,
/// and UI widgets remain untouched.
class VisionRepository {
  // Probability distribution: 40% Ringan, 40% Sedang, 20% Berat.
  static const _labels = ['Ringan', 'Sedang', 'Berat'];

  final _random = Random();

  /// Classifies the given image and returns a [DirtLevelResult].
  ///
  /// The 1.5 second delay mimics real inference latency.
  /// The random distribution mirrors expected real-world statistics.
  Future<DirtLevelResult> classifyImage(File imageFile) async {
    // Simulate model inference time.
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    // TODO: replace with real TFLite inference when model is ready.
    // Example integration point:
    //   final interpreter = await Interpreter.fromAsset('assets/models/vision_model.tflite');
    //   ... preprocess imageFile → input tensor ...
    //   interpreter.run(input, output);
    //   return DirtLevelResult.fromTensor(output);

    final r = _random.nextDouble();
    final int levelIndex;
    if (r < 0.40) {
      levelIndex = 0; // Ringan
    } else if (r < 0.80) {
      levelIndex = 1; // Sedang
    } else {
      levelIndex = 2; // Berat
    }

    // Confidence in range 0.72–0.97.
    final confidence = 0.72 + (_random.nextDouble() * 0.25);

    return DirtLevelResult(
      label: _labels[levelIndex],
      confidence: confidence,
      levelIndex: levelIndex,
    );
  }
}
