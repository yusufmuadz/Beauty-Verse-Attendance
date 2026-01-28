import 'package:get/get.dart';

import '../controllers/istirahat_telat_controller.dart';

class IstirahatTelatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IstirahatTelatController>(
      () => IstirahatTelatController(),
    );
  }
}
