import 'package:get/get.dart';
import 'package:bersih_in/app/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
