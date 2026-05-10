import 'package:get/get.dart';

import 'package:bersih_in/app/features/ai_vision/data/repositories/vision_repository.dart';
import 'package:bersih_in/app/features/ai_vision/domain/usecases/classify_image_usecase.dart';
import 'package:bersih_in/app/features/ai_vision/presentation/controllers/ai_vision_controller.dart';

/// Registers all AI Vision dependencies for the camera screen.
class AiVisionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisionRepository>(() => VisionRepository());
    Get.lazyPut<ClassifyImageUseCase>(
      () => ClassifyImageUseCase(Get.find()),
    );
    Get.lazyPut<AiVisionController>(
      () => AiVisionController(Get.find()),
    );
  }
}
