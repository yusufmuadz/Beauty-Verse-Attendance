import 'package:get/get.dart';

import '../controllers/locations_tracker_controller.dart';

class LocationsTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationsTrackerController>(
      () => LocationsTrackerController(),
    );
  }
}
