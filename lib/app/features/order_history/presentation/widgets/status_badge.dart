import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }

  String get _label {
    switch (status) {
      case 'pending':
        return AppStrings.statusPending;
      case 'confirmed':
        return AppStrings.statusConfirmed;
      case 'done':
        return AppStrings.statusDone;
      default:
        return status;
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case 'pending':
        return AppColors.statusPending.withValues(alpha: 0.15);
      case 'confirmed':
        return AppColors.statusConfirmed.withValues(alpha: 0.15);
      case 'done':
        return AppColors.statusDone.withValues(alpha: 0.15);
      default:
        return AppColors.divider;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'done':
        return AppColors.statusDone;
      default:
        return AppColors.textSecondary;
    }
  }
}
