import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/constants/app_colors.dart';
import 'package:bersih_in/app/core/constants/app_dimensions.dart';
import 'package:bersih_in/app/core/constants/app_strings.dart';
import 'package:bersih_in/app/core/services/user_session_service.dart';
import 'package:bersih_in/app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:bersih_in/app/features/order_history/presentation/views/order_history_view.dart';
import 'package:bersih_in/app/routes/app_routes.dart';
import 'package:bersih_in/app/features/home/presentation/controllers/home_controller.dart';
import 'package:bersih_in/app/features/home/presentation/widgets/hero_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Get.find<UserSessionService>();

    return Obx(() {
      final tabIndex = controller.currentTabIndex.value;

      return Scaffold(
        appBar: AppBar(
          title: tabIndex == 0
              ? Obx(() => Text(
                    '${AppStrings.greeting}, ${userSession.userName}! 👋',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
              : const Text(AppStrings.orderHistoryTitle),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                // Use a fresh or find existing AuthController
                final authController = Get.put(AuthController());
                authController.logout();
              },
              icon: const Icon(Icons.logout_rounded),
              tooltip: AppStrings.logout,
            ),
          ],
        ),
        body: IndexedStack(
          index: tabIndex,
          children: [
            _buildHomeTab(),
            const OrderHistoryView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tabIndex,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: AppStrings.orderHistory,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spacingSM),

          // Hero Card
          HeroCard(
            onOrderPressed: () => Get.toNamed(AppRoutes.BOOKING_FORM),
          ),

          const SizedBox(height: AppDimensions.spacingLG),

          // Quick info section
          const Text(
            'Kenapa BersihIn?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),

          _buildFeatureItem(
            Icons.timer_rounded,
            'Cepat & Praktis',
            'Pesan dalam hitungan menit, mitra datang ke lokasimu',
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          _buildFeatureItem(
            Icons.verified_user_rounded,
            'Mitra Terverifikasi',
            'Semua mitra sudah diverifikasi KTP & SKCK',
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          _buildFeatureItem(
            Icons.psychology_rounded,
            'Harga Cerdas AI',
            'Estimasi harga otomatis berdasarkan kondisi ruangan',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
