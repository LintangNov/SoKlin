import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/utils/validators.dart';
import 'package:bersih_in/app/core/widgets/custom_button.dart';
import 'package:bersih_in/app/core/widgets/custom_text_field.dart';
import 'package:bersih_in/app/core/widgets/loading_overlay.dart';
import 'package:bersih_in/app/routes/app_routes.dart';
import 'package:bersih_in/app/features/auth/presentation/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimensions.spacingXL),

                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cleaning_services_rounded,
                        size: 40,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // App name
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXS),
                    const Text(
                      AppStrings.appTagline,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacingXL),

                    // Email field
                    CustomTextField(
                      label: AppStrings.email,
                      hint: 'contoh@email.com',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Password field
                    Obx(
                      () => CustomTextField(
                        label: AppStrings.password,
                        hint: 'Minimal 6 karakter',
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        onToggleObscure: controller.togglePasswordVisibility,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        validator: Validators.validatePassword,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),

                    // Login button
                    CustomButton(
                      text: AppStrings.login,
                      onPressed: controller.loginWithEmail,
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMD,
                          ),
                          child: Text(
                            'atau',
                            style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Google Sign-In button
                    CustomButton(
                      text: AppStrings.loginWithGoogle,
                      isOutlined: true,
                      onPressed: controller.loginWithGoogle,
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.noAccount,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                          child: const Text(AppStrings.register),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
