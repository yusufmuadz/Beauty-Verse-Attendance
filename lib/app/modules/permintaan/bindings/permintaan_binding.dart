import 'package:get/get.dart';

import '../controllers/permintaan_controller.dart';

class PermintaanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermintaanController>(
      () => PermintaanController(),
    );
  }
}
