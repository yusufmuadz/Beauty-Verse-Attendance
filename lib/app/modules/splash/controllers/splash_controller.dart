import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/modules/authentication/views/sign_in_view.dart';
import 'package:lancar_cat/app/modules/camera_capture/controllers/camera_capture_controller.dart';
import 'package:lancar_cat/app/modules/home/views/menu_view.dart';

import '../../inbox/views/agreement_detail_view.dart';
import '../../services/cuti/pengajuan/views/detail_pengajuan_absensi_view.dart';
import '../../services/lembur/views/detail_pengajuan_lembur_view.dart';
import '../../services/shift/detail_pengajuan_shift.dart';

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

    // Cek jika app dibuka dari terminated state
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     _handleMessage(message); // Gunakan handler kamu
    //   }
    // });

    // // App sedang di background & user klik notifikasi
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   _handleMessage(message);
    // });
    // // cek login status apakah sudah pernah login sebelumnya
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _firebaseMessaging.requestPermission().then((value) {
        _checkLoginStatus();
    //   });
    //   // _checkLoginStatus();
    // });
  }

  void _handleMessage(RemoteMessage? message) {
    if (message != null) {
      log('Received notification data: ${message.data}');

      final route = message.data['route'];
      final id = message.data['id'];

      // Pastikan ada rute dan ID sebelum mencoba navigasi
      if (route != null && id != null) {
        // Beri sedikit penundaan untuk memastikan Navigator sudah siap, terutama dari terminated state
        Future.delayed(const Duration(milliseconds: 500), () {
          switch (route) {
            case '/cuti':
              Get.to(() => AgreementDetailView(), arguments: id);
              break;
            case '/attendance':
              Get.to(() => DetailPengajuanAbsensiView(), arguments: id);
              break;
            case '/overtime':
              Get.to(() => DetailPengajuanLemburView(), arguments: id);
              break;
            case '/change-shift':
              Get.to(() => DetailPengajuanShiftView(), arguments: id);
              break;
            default:
              log('Unknown route: $route');
              break;
          }
        });
      }
    }
  }

  checkIsLogin() async {
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
