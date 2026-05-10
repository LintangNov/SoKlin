import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/routes/app_routes.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    _checkAuthAndNavigate();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.cleaning_services_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAuthAndNavigate() {
    Future.delayed(const Duration(seconds: 2), () {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    });
  }
}
