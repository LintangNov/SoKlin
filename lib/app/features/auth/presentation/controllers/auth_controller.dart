import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/services/user_session_service.dart';
import 'package:bersih_in/app/routes/app_routes.dart';
import 'package:bersih_in/app/features/auth/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Observables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Form key
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// Login with email & password
  Future<void> loginWithEmail() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authRepository.loginWithEmail(
        emailController.text,
        passwordController.text,
      );
      await Get.find<UserSessionService>().setUser(user);
      Get.snackbar(
        'Berhasil',
        AppStrings.loginSuccess,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF27AE60),
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        AppStrings.errorGeneral,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authRepository.loginWithGoogle();
      await Get.find<UserSessionService>().setUser(user);
      Get.snackbar(
        'Berhasil',
        AppStrings.loginSuccess,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF27AE60),
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'sign-in-cancelled') return;
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        AppStrings.errorGeneral,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authRepository.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      await Get.find<UserSessionService>().setUser(user);
      Get.snackbar(
        'Berhasil',
        AppStrings.registerSuccess,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF27AE60),
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        AppStrings.errorGeneral,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      Get.find<UserSessionService>().clearUser();
      Get.offAllNamed(AppRoutes.LOGIN);
      Get.snackbar(
        'Berhasil',
        AppStrings.logoutSuccess,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        AppStrings.errorGeneral,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = AppStrings.errorUserNotFound;
        break;
      case 'wrong-password':
        message = AppStrings.errorWrongPassword;
        break;
      case 'email-already-in-use':
        message = AppStrings.errorEmailInUse;
        break;
      case 'invalid-email':
        message = AppStrings.emailInvalid;
        break;
      default:
        message = e.message ?? AppStrings.errorGeneral;
    }
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE74C3C),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
