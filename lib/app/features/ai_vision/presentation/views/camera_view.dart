import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';

/// Placeholder view — will be fully replaced by Dev B
/// with camera integration and AI room analysis.
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Kondisi Kamar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              size: 64,
              color: AppColors.textHint.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.cameraStub,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fitur ini akan diimplementasi oleh Dev B',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
