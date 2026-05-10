import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bersih_in/app/features/ai_vision/data/models/dirt_level_result.dart';
import 'package:bersih_in/app/features/ai_vision/domain/usecases/classify_image_usecase.dart';
import 'package:bersih_in/app/routes/app_routes.dart';

class AiVisionController extends GetxController {
  final ClassifyImageUseCase _classifyImageUseCase;

  AiVisionController(this._classifyImageUseCase);

  // ---------------------------------------------------------------------------
  // Observables
  // ---------------------------------------------------------------------------

  final isProcessing = false.obs;
  final capturedImage = Rxn<File>();
  final classificationResult = Rxn<DirtLevelResult>();

  // ---------------------------------------------------------------------------
  // Image capture
  // ---------------------------------------------------------------------------

  /// Opens the device camera to capture a new photo.
  Future<void> takePhoto() async {
    await _pickImage(ImageSource.camera);
  }

  /// Opens the gallery to select an existing photo.
  Future<void> pickFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? xFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1280,
      );

      if (xFile == null) return; // user cancelled

      // Reset previous result when a new image is selected.
      classificationResult.value = null;
      capturedImage.value = File(xFile.path);
    } catch (e) {
      debugPrint('[AiVisionController] Image picker error: $e');
      Get.snackbar(
        'Gagal',
        'Tidak dapat membuka kamera/galeri. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Classification
  // ---------------------------------------------------------------------------

  /// Sends [capturedImage] to the AI pipeline and stores the result.
  Future<void> analyzeImage() async {
    final image = capturedImage.value;
    if (image == null) return;

    isProcessing.value = true;
    try {
      final result = await _classifyImageUseCase(image);
      classificationResult.value = result;
    } catch (e) {
      debugPrint('[AiVisionController] Analysis error: $e');
      Get.snackbar(
        'Gagal Menganalisis',
        'Terjadi kesalahan saat menganalisis gambar. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Navigates to the price estimation screen.
  ///
  /// Only callable after [classificationResult] has been set.
  void proceedToPricing() {
    final result = classificationResult.value;
    if (result == null) {
      Get.snackbar(
        'Belum Dianalisis',
        'Harap analisis gambar terlebih dahulu.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF39C12),
        colorText: Colors.white,
      );
      return;
    }

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    Get.toNamed(
      AppRoutes.PRICE_RESULT,
      arguments: {
        'roomSize': args['roomSize'] as double? ?? 10.0,
        'extras': args['extras'] as List<String>? ?? <String>[],
        'dirtLevel': result.label,
        'dirtLevelIndex': result.levelIndex,
      },
    );
  }
}
