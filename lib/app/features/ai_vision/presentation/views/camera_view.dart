import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/widgets/loading_overlay.dart';
import 'package:bersih_in/app/features/ai_vision/presentation/controllers/ai_vision_controller.dart';
import 'package:bersih_in/app/features/ai_vision/presentation/views/widgets/dirt_level_indicator.dart';
import 'package:bersih_in/app/features/booking/presentation/widgets/step_indicator.dart';

/// Step 2 of 3 — Camera / Gallery capture + AI analysis screen.
///
/// Replaces the Dev A stub. Fully driven by [AiVisionController] observables;
/// no [setState] is used anywhere.
class CameraView extends GetView<AiVisionController> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isProcessing.value,
        message: 'Menganalisis kondisi kamar...',
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Foto Kondisi Kamar'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Get.back,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator — Step 2 of 3
                const StepIndicator(
                  currentStep: 1,
                  totalSteps: 3,
                  stepLabels: [
                    AppStrings.step1,
                    AppStrings.step2,
                    AppStrings.step3,
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingLG),

                // Section label
                const Text(
                  'Foto Kondisi Kamar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ambil foto yang jelas agar AI dapat menganalisis\ntingkat kekotoran kamar dengan akurat.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppDimensions.spacingLG),

                // Image preview area
                _ImagePreviewArea(controller: controller),
                const SizedBox(height: AppDimensions.spacingLG),

                // Camera / Gallery buttons
                Row(
                  children: [
                    Expanded(
                      child: _CaptureButton(
                        id: 'btn_take_photo',
                        icon: Icons.camera_alt_rounded,
                        label: 'Ambil Foto',
                        onTap: controller.takePhoto,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMD),
                    Expanded(
                      child: _CaptureButton(
                        id: 'btn_pick_gallery',
                        icon: Icons.photo_library_rounded,
                        label: 'Dari Galeri',
                        onTap: controller.pickFromGallery,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingMD),

                // Analyze button — shown only when image captured and not yet analyzed
                if (controller.capturedImage.value != null &&
                    controller.classificationResult.value == null) ...[
                  SizedBox(
                    height: AppDimensions.buttonHeight,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('btn_analyze'),
                      onPressed: controller.analyzeImage,
                      icon: const Icon(Icons.auto_fix_high_rounded, size: 20),
                      label: const Text('Analisis Kondisi'),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMD),
                ],

                // Result area — shown after classification
                if (controller.classificationResult.value != null) ...[
                  DirtLevelIndicator(
                    result: controller.classificationResult.value!,
                  ),
                  const SizedBox(height: AppDimensions.spacingLG),
                  SizedBox(
                    height: AppDimensions.buttonHeight,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('btn_proceed_pricing'),
                      onPressed: controller.proceedToPricing,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      label: const Text('Lanjut ke Estimasi Harga'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widget: Image preview area
// ---------------------------------------------------------------------------

class _ImagePreviewArea extends StatelessWidget {
  final AiVisionController controller;

  const _ImagePreviewArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    final image = controller.capturedImage.value;

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: image != null ? AppColors.primary : AppColors.divider,
          width: image != null ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null
          ? Image.file(image, fit: BoxFit.cover)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 56,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ambil foto kondisi kamar',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gunakan tombol di bawah',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widget: Capture / Gallery button
// ---------------------------------------------------------------------------

class _CaptureButton extends StatelessWidget {
  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _CaptureButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: OutlinedButton.icon(
        key: Key(id),
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
