import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthenticationController());
    return Scaffold(
      body: Center(
        child: Icon(Icons.developer_board),
      ),
    );
  }
}
