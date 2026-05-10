import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';

/// Placeholder view — will be fully replaced by Dev B
/// with TFLite-based price estimation logic.
class PriceEstimationView extends StatelessWidget {
  const PriceEstimationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimasi Harga'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 24),
            Text(
              AppStrings.calculatingPrice,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
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
