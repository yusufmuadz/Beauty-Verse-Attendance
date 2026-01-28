import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/modules/authentication/views/sign_in_view.dart';
import 'package:lancar_cat/app/modules/home/views/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
