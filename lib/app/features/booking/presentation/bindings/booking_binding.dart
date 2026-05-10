import 'package:get/get.dart';
import 'package:bersih_in/app/features/booking/presentation/controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingController>(() => BookingController());
  }
}
