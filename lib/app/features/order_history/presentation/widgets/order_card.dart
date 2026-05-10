import 'package:flutter/material.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/utils/formatters.dart';
import 'package:bersih_in/app/routes/app_routes.dart';
import 'package:bersih_in/app/features/booking/data/models/order_model.dart';
import 'status_badge.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        side: const BorderSide(color: AppColors.divider, width: 0.5),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.ORDER_DETAIL,
          arguments: order,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Order ID + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${Formatters.shortOrderId(order.orderId)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSM),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: AppDimensions.spacingSM),

              // Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimasi Harga',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatRupiah(order.estimatedPrice),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatDate(order.createdAt),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
