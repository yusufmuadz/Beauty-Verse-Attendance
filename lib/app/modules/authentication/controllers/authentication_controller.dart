import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/api_controller.dart';
import '../../home/views/menu_view.dart';
import '../views/sign_in_view.dart';

class AuthenticationController extends GetxController {
  final a = Get.put(ApiController());

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkIsAccountAvailable();
    });
  }

  _checkIsAccountAvailable() async {
    var response = await a.isAccountAvailable();

    if (response!.isNotEmpty) {
      Get.offAll(() => MenuView());
    } else {
      Get.offAll(() => SignInView());
    }
  }
}
