import 'package:get/get.dart';

import '../controllers/detail_information_employee_controller.dart';

class DetailInformationEmployeeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailInformationEmployeeController>(
      () => DetailInformationEmployeeController(),
    );
  }
}
