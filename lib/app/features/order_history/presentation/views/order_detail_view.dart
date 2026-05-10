import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/utils/formatters.dart';
import 'package:bersih_in/app/features/booking/data/models/order_model.dart';
import 'package:bersih_in/app/features/order_history/presentation/widgets/partner_badge_widget.dart';
import 'package:bersih_in/app/features/order_history/presentation/widgets/status_badge.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.orderDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Status header
            Card(
              elevation: 0,
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.orderId,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${Formatters.shortOrderId(order.orderId)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(status: order.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Price card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Column(
                children: [
                  const Text(
                    AppStrings.estimatedPrice,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatRupiah(order.estimatedPrice),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Details
            Card(
              elevation: 0,
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                child: Column(
                  children: [
                    _buildRow(
                        AppStrings.dirtLevel, order.dirtLevel),
                    const Divider(height: 20),
                    _buildRow(AppStrings.roomSize,
                        '${order.roomSizeM2.toInt()} m²'),
                    const Divider(height: 20),
                    _buildRow(
                      AppStrings.extraServices,
                      order.extras.isEmpty
                          ? 'Tidak ada'
                          : order.extras
                              .map((e) => _extraLabel(e))
                              .join(', '),
                    ),
                    const Divider(height: 20),
                    _buildRow(
                      AppStrings.estimatedDuration,
                      Formatters.formatDuration(order.estimatedMinutes),
                    ),
                    const Divider(height: 20),
                    _buildRow(
                      'Tanggal Pemesanan',
                      Formatters.formatDateTimeFull(order.createdAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Partner badge
            PartnerBadgeWidget(
              partnerName: order.partnerName,
              partnerVerified: order.partnerVerified,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _extraLabel(String extra) {
    switch (extra) {
      case 'extra_bathroom':
        return AppStrings.extraBathroom;
      case 'extra_dishes':
        return AppStrings.extraDishes;
      default:
        return extra;
    }
  }
}
