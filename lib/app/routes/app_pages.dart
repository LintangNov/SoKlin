import 'package:get/get.dart';
import 'package:bersih_in/app/features/ai_vision/presentation/bindings/ai_vision_binding.dart';
import 'package:bersih_in/app/features/ai_vision/presentation/views/camera_view.dart';
import 'package:bersih_in/app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:bersih_in/app/features/auth/presentation/views/login_view.dart';
import 'package:bersih_in/app/features/auth/presentation/views/register_view.dart';
import 'package:bersih_in/app/features/auth/presentation/views/splash_view.dart';
import 'package:bersih_in/app/features/booking/presentation/bindings/booking_binding.dart';
import 'package:bersih_in/app/features/booking/presentation/views/booking_form_view.dart';
import 'package:bersih_in/app/features/booking/presentation/views/order_confirmation_view.dart';
import 'package:bersih_in/app/features/home/presentation/bindings/home_binding.dart';
import 'package:bersih_in/app/features/home/presentation/views/home_view.dart';
import 'package:bersih_in/app/features/order_history/presentation/bindings/order_history_binding.dart';
import 'package:bersih_in/app/features/order_history/presentation/views/order_detail_view.dart';
import 'package:bersih_in/app/features/order_history/presentation/views/order_history_view.dart';
import 'package:bersih_in/app/features/pricing/presentation/views/price_estimation_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.BOOKING_FORM,
      page: () => const BookingFormView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.AI_CAMERA,
      page: () => const CameraView(),
      binding: AiVisionBinding(),
    ),
    GetPage(
      name: AppRoutes.PRICE_RESULT,
      page: () => const PriceEstimationView(),
    ),
    GetPage(
      name: AppRoutes.ORDER_CONFIRM,
      page: () => const OrderConfirmationView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDER_DETAIL,
      page: () => const OrderDetailView(),
    ),
  ];
}
