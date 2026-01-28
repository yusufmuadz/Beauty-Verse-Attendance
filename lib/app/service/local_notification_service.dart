import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  }

  Future<void> initialize() async {
    _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher_foreground');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotificationService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
    );
  }

  int _generateNotificationId(DateTime time) {
    return int.parse('${time.day}${time.month}${time.hour}${time.minute}');
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    return NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
  }

  Future<void> _scheduleNotification({
    required DateTime now,
    required String title,
    required String body,
  }) async {
    final notificationId = _generateNotificationId(now);

    List scheduleRunning = await checkScheduledNotificationRunning();

    if (scheduleRunning.isNotEmpty) {
      for (PendingNotificationRequest element in scheduleRunning) {
        if (element.id == notificationId) {
          log('tidak dibuat lagi karena sudah ada');
          return;
        }
      }
    }

    // Tentukan waktu yang dijadwalkan
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    // Jika waktu sudah lewat, geser ke hari berikutnya
    if (scheduledTime.isBefore(now)) {
      scheduledTime.add(Duration(days: 1));
    }

    // Cek apakah notifikasi dengan ID yang sama sudah ada
    final pendingNotifications = await _localNotificationService
        .pendingNotificationRequests();
    if (pendingNotifications.any(
      (notification) => notification.id == notificationId,
    )) {
      debugPrint(
        'Notifikasi untuk jam ${now.hour}:${now.minute} sudah dijadwalkan.',
      );
      return; // Tidak perlu menjadwalkan ulang
    }

    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );

    debugPrint('Notifikasi dijadwalkan untuk jam ${now.hour}:${now.minute}');
  }

  void onDidReceiveLocalNotification(NotificationResponse details) {
    debugPrint(details.id.toString());
    debugPrint(details.payload);
  }

  void setScheduleNotifications(
    DateTime date,
    String title,
    String body,
  ) async {
    _scheduleNotification(
      now: DateTime(date.year, date.month, date.day, date.hour, date.minute),
      title: title,
      body: body,
    );
  }

  checkScheduledNotificationRunning() async =>
      await _localNotificationService.pendingNotificationRequests();

  clearAllScheduledNotifications() async =>
      await _localNotificationService.cancelAll();
}
