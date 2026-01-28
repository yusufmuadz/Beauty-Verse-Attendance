import 'package:get/get.dart';

import '../controllers/camera_capture_controller.dart';

class CameraCaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraCaptureController>(
      () => CameraCaptureController(),
    );
  }
}
