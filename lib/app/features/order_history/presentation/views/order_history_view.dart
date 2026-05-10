import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/features/order_history/presentation/controllers/order_history_controller.dart';
import 'package:bersih_in/app/features/order_history/presentation/widgets/order_card.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 64,
                color: AppColors.textHint.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppDimensions.spacingMD),
              const Text(
                AppStrings.noOrders,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              const Text(
                'Pesan jasa kebersihan pertamamu!',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        itemCount: controller.orders.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spacingSM),
        itemBuilder: (context, index) {
          return OrderCard(order: controller.orders[index]);
        },
      );
    });
  }
}
