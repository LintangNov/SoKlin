/// Represents the classification output from the AI vision pipeline.
///
/// In the MVP implementation this is populated with randomized values.
/// When the TFLite model is ready, this model remains unchanged — only
/// the inference code inside [VisionRepository] is swapped.
class DirtLevelResult {
  /// Human-readable label: 'Ringan' | 'Sedang' | 'Berat'
  final String label;

  /// Inference confidence in the range 0.0–1.0.
  final double confidence;

  /// Numeric index: 0 = Ringan, 1 = Sedang, 2 = Berat.
  final int levelIndex;

  const DirtLevelResult({
    required this.label,
    required this.confidence,
    required this.levelIndex,
  });

  @override
  String toString() =>
      'DirtLevelResult(label: $label, confidence: $confidence, levelIndex: $levelIndex)';
}
