import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/utils/validators.dart';
import 'package:bersih_in/app/core/widgets/custom_button.dart';
import 'package:bersih_in/app/core/widgets/custom_text_field.dart';
import 'package:bersih_in/app/core/widgets/loading_overlay.dart';
import 'package:bersih_in/app/features/auth/presentation/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(AppStrings.register),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Header
                    const Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXS),
                    const Text(
                      'Isi data diri kamu untuk mulai menggunakan BersihIn',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),

                    // Full name
                    CustomTextField(
                      label: AppStrings.fullName,
                      hint: 'Masukkan nama lengkap',
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Email
                    CustomTextField(
                      label: AppStrings.email,
                      hint: 'contoh@email.com',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Password
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
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Confirm password
                    Obx(
                      () => CustomTextField(
                        label: AppStrings.confirmPassword,
                        hint: 'Ulangi password',
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        onToggleObscure:
                            controller.toggleConfirmPasswordVisibility,
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          controller.passwordController.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),

                    // Register button
                    CustomButton(
                      text: AppStrings.register,
                      onPressed: controller.register,
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.hasAccount,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text(AppStrings.login),
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
