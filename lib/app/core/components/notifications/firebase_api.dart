import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_detail_view.dart';
import 'package:lancar_cat/app/modules/services/cuti/pengajuan/views/detail_pengajuan_absensi_view.dart';
import 'package:lancar_cat/app/modules/services/lembur/views/detail_pengajuan_lembur_view.dart';
import 'package:lancar_cat/app/modules/services/shift/detail_pengajuan_shift.dart';

class FirebaseApi {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi semua fitur FCM
  Future<void> initPushNotification() async {
    await _initLocalNotification(); // penting biar bisa bunyi
    await _requestPermission();
    await _registerToken();
    _setupForegroundListener();
    _setupMessageOpenedAppHandler();
    _handleInitialMessage(); // Untuk terminated
  }

  /// Setup plugin notifikasi lokal
  Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings(
      '@drawable/ic_foreground',
    );
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // klik notif lokal
      },
    );

    // 🚀 Buat channel custom saat aplikasi start
    const androidChannel = AndroidNotificationChannel(
      'custom_channel', // id channel
      'Custom Channel', // nama channel yang ditampilkan di setting
      description: 'Channel untuk notifikasi dengan custom sound',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notifications'),
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Meminta izin notifikasi dari pengguna
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('🚫 Izin notifikasi ditolak oleh user');
    } else {
      debugPrint('✅ Izin notifikasi diberikan');
    }
  }

  /// Ambil token FCM dan kirim ke server
  Future<void> _registerToken() async {
    try {
      final fcmToken = await _messaging.getToken();
      if (fcmToken != null) {
        Variables.FCMToken = fcmToken;
        debugPrint('✅ Token FCM: $fcmToken');
        await _sendTokenToServer(fcmToken);
      }
    } catch (e) {
      debugPrint('❌ Gagal ambil token FCM: $e');
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    final model = Get.find<ModelController>();
    final uri = Uri.parse('${Variables.baseUrl}/notification/set/fcm/token');

    final headers = {
      'Authorization': 'Bearer ${model.token.value}',
      'Content-Type': 'application/json',
    };

    final request = http.MultipartRequest('POST', uri)
      ..fields['fcm_token'] = token
      ..headers.addAll(headers);

    final response = await request.send();
    if (response.statusCode == 200) {
      debugPrint('📤 Token dikirim ke server');
    } else {
      debugPrint('⚠️ Gagal kirim token ke server: ${response.reasonPhrase}');
    }
  }

  void _setupMessageOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📬 Notifikasi diklik (background)');
      _handleNavigation(message);
    });
  }

  /// Handler notifikasi ketika aplikasi foreground
  void _setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint(
        '📢 Pesan diterima (foreground): ${message.notification?.title}',
      );

      // 🔔 Tampilkan notifikasi lokal agar ada bunyi
      if (message.notification != null && Platform.isAndroid) {
        const androidDetails = AndroidNotificationDetails(
          'custom_channel',
          'Custom Channel',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notifications'),
        );

        const iosDetails = DarwinNotificationDetails(
          presentSound: true,
          sound: "notifications.wav",
        );

        const notifDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _localNotif.show(
          DateTime.now().millisecond,
          message.notification!.title,
          message.notification!.body,
          notifDetails,
          payload: message.data.toString(),
        );
      }
    });
  }

  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🟢 App dibuka dari terminated oleh notifikasi');
        _handleNavigation(initialMessage);
      });
    }
  }

  void _handleNavigation(RemoteMessage message) {
    final data = message.data;
    final route = data['route'];
    final id = data['id'];

    log('📦 Payload notifikasi: $data');

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
        debugPrint('❓ Rute tidak dikenal: $route');
    }
  }
}
