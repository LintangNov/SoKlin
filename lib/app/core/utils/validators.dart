import 'package:bersih_in/app/core/constants/app_strings.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    final passwordError = validatePassword(value);
    if (passwordError != null) return passwordError;
    if (value != password) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    if (value.trim().length < 3) {
      return AppStrings.nameMinLength;
    }
    return null;
  }
}
