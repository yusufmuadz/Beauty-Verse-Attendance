import 'package:get/get.dart';

import '../controllers/subordinate_controller.dart';

class SubordinateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubordinateController>(
      () => SubordinateController(),
    );
  }
}
