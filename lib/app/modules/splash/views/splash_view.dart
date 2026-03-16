import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constant/variables.dart';
import '../../../shared/button/button_1.dart';
import '../../camera_capture/views/camera_capture_view.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 300,
              child: Image.asset(Variables.logoPath, fit: BoxFit.fill),
            ),
          ),
          Obx(
            () => controller.isButtonShow.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Button1(
                      title: 'Presensi Offline',
                      onTap: () {
                        Get.to(() => CameraCaptureView(), arguments: '502');
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
