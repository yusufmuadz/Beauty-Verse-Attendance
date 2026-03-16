import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

import '../../../controllers/api_controller.dart';
import '../../../controllers/model_controller.dart';
import '../../authentication/views/sign_in_view.dart';
import '../../camera_capture/controllers/camera_capture_controller.dart';
import '../../home/views/menu_view.dart';

class SplashController extends GetxController {
  final _box = Hive.box('andioffset');
  RxBool isButtonShow = false.obs;

  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());
  final cc = Get.put(CameraCaptureController());

  // final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() async {
    super.onInit();

    /**
     * delay 5 seconds: setelah selesai akan muncul button untuk login secara
     * offline
     */
    await m.checkInternetConnection();
        _checkLoginStatus();
  }

  Future<void> checkIsLogin() async {
    String? token = await _box.get('token');
    if (token != null) {
      isButtonShow(true);
    }

    Uint8List? storedImage = _box.get('storedImage');
    if (storedImage != null) {
      await cc.offlineAttendanceCheck();
    }
  }

  Future<void> jailbreakChecker() async {
    final JailbreakRootDetection root = JailbreakRootDetection.instance;

    final isJailBroken = await root.isJailBroken;
    final isDevMode = await root.isDevMode;

    // Check if not dev mode and is JailBroken
    if (isJailBroken && !isDevMode) {
      await Future.delayed(
        const Duration(seconds: 3),
        () => AlertDialog(
          title: const Text("Perhatian"),
          content: Text('Anda terdeteksi menggunakan jailbreak'),
        ),
      );
      exit(0);
    }
  }

  Future<void> _checkLoginStatus() async {
    // if (Platform.isAndroid) await jailbreakChecker();

    // note: pengecekan jika waktu loading sudah lebih dari 10 detik maka munculkan alert
    Future.delayed(const Duration(seconds: 1)).then((_) => checkIsLogin());

    String? token = await _box.get('token');
    m.token(token);

    (token == null || token.isEmpty)
        ? Get.offAll(() => SignInView())
        : {await a.fetchCurrentUser(), Get.offAll(() => MenuView())};
  }
}
