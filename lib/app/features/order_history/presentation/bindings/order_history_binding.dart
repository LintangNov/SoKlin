import 'package:get/get.dart';
import 'package:bersih_in/app/features/order_history/presentation/controllers/order_history_controller.dart';
import 'package:bersih_in/app/features/order_history/data/repositories/order_history_repository.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderHistoryRepository>(() => OrderHistoryRepository());
    Get.lazyPut<OrderHistoryController>(() => OrderHistoryController());
  }
}
