import 'dart:async';
import 'package:get/get.dart';
import 'package:bersih_in/app/core/services/user_session_service.dart';
import 'package:bersih_in/app/features/booking/data/models/order_model.dart';
import 'package:bersih_in/app/features/order_history/data/repositories/order_history_repository.dart';

class OrderHistoryController extends GetxController {
  final OrderHistoryRepository _repository =
      Get.find<OrderHistoryRepository>();

  final orders = <OrderModel>[].obs;
  final isLoading = true.obs;
  StreamSubscription? _orderSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToOrders();
  }

  void _listenToOrders() {
    final userSession = Get.find<UserSessionService>();
    final userId = userSession.currentUser.value?.uid;

    if (userId == null) {
      isLoading.value = false;
      return;
    }

    _orderSubscription = _repository.getUserOrders(userId).listen(
      (orderList) {
        orders.assignAll(orderList);
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _orderSubscription?.cancel();
    super.onClose();
  }
}
