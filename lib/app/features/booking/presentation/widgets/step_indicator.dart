import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIndex = index ~/ 2;
              return Expanded(
                child: Container(
                  height: 2,
                  color: stepIndex < currentStep
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              );
            }

            // Step circle
            final stepIndex = index ~/ 2;
            final isActive = stepIndex <= currentStep;
            final isCurrent = stepIndex == currentStep;

            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.divider,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Center(
                child: isActive && stepIndex < currentStep
                    ? const Icon(Icons.check, size: 16, color: AppColors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                      ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepLabels
              .asMap()
              .entries
              .map(
                (entry) => Flexible(
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: entry.key == currentStep
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: entry.key <= currentStep
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
