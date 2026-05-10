import 'dart:io';

import 'package:bersih_in/app/features/ai_vision/data/models/dirt_level_result.dart';
import 'package:bersih_in/app/features/ai_vision/data/repositories/vision_repository.dart';

/// Domain use case that delegates image classification to [VisionRepository].
///
/// Keeps the presentation layer decoupled from the data layer.
class ClassifyImageUseCase {
  final VisionRepository _repository;

  const ClassifyImageUseCase(this._repository);

  Future<DirtLevelResult> call(File imageFile) {
    return _repository.classifyImage(imageFile);
  }
}
