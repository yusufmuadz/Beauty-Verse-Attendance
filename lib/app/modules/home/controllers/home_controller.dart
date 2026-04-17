// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../../controllers/api_controller.dart';
import '../../../controllers/calendar_controller.dart';
import '../../../controllers/geolocator_controller.dart';
import '../../../controllers/model_controller.dart';
import '../../../core/constant/variables.dart';
import '../../../models/shift.dart';
import '../../../service/local_notification_service.dart';
import '../../../shared/button/button_1.dart';
import '../../camera_capture/controllers/camera_capture_controller.dart';

class HomeController extends GetxController {
  final globalKey = GlobalKey();
  final g = Get.put(GeolocatorController());
  final camera = Get.put(CameraCaptureController());
  final a = Get.put(ApiController());
  final m = Get.find<ModelController>();
  final c = Get.put(CalendarController());

  final _myBox = Hive.box("andioffset");

  late LocalNotificationService service;

  @override
  void onInit() async {
    super.onInit();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   debugPrint('log: init push notification');
    //   await FirebaseApi().initPushNotification();
    // });

    service = LocalNotificationService();

    await a.fetchCurrentUser();
    await g.askingPermission();
    await countApplications();

    bool isNeedUpdate = await isAvailableVersion();

    if (isNeedUpdate) {
      await showVersionAlert();
      exit(0);
    }

    await service.initialize();
    bool? status = _myBox.get("notification-status");
    if (status != null && status) {
      initializeNotification();
    }
  }

  Future<bool> isAvailableVersion() async {
    try {
      final appVersion = await checkVersion();
      final availableVersion = await checkApplicationVersion();

      List<int> appVersionList = appVersion
          .split('.')
          .map((e) => int.parse(e))
          .toList();

      Version currentVersion = Version(
        appVersionList[0],
        appVersionList[1],
        appVersionList[2],
      );

      Version latestVersion = Version.parse(availableVersion);

      if (latestVersion > currentVersion) {
        return true;
      }
      return false;
    } catch (e) {
      var box = await Hive.openBox('andioffset');
      await box.delete('token');
      // debugPrint(e.toString());
      return false;
    }
  }

  Future<void> countApplications() async {
    await a.getAgreementLine();
    await a.findSubmissionByUserId();
    await a.findOvertimeByLine();
    await a.lenghtCountShiftLine();
  }

  Future<String> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<dynamic> showVersionAlert() async => await Get.bottomSheet(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade200,
            ),
          ),
          const Gap(20),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: HexColor('148582'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Iconsax.notification_copy, color: Colors.white),
          ),
          const Gap(15),
          Text(
            'Update Available',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const Gap(15),
          Text(
            'A new software version is available for download',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const Gap(15),
          Button1(
            title: 'update',
            backgroundColor: Colors.amber.shade900,
            onTap: () async {
              Variables().loading(message: 'Logout...');
              await a.isAccountDeleted();
            },
          ),
        ],
      ),
    ),
  );

  Future checkApplicationVersion() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v1/versi/android/isbu'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        return json.decode(data);
      } else {
        // debugPrint('${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> initializeNotification() async {
    log('Start initializing notification');
    String date = DateFormat('yyyy-MM-dd', 'id').format(DateTime.now());

    var headers = {'Authorization': 'Bearer ${m.token.value}'};

    var response = await http.get(
      Uri.parse("${Variables.baseUrl}/v1/user/nextday/shift?time=$date"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse["status"]) {
        Shift nextDayShift = Shift.fromMap(jsonResponse["shift"]);
        DateTime date = DateTime.parse(jsonResponse["date"]);

        if (nextDayShift.dayoff == '0') {
          // Jika tidak libur, set notifikasi untuk jadwal masuk dan keluar
          ["scheduleIn", "scheduleOut"].forEach((schedule) {
            String? time = schedule == "scheduleIn"
                ? nextDayShift.scheduleIn
                : nextDayShift.scheduleOut;

            if (time != null) {
              // lakukan pengecekan apakah waktu sudah lewat
              List<String> timeParts = time.split(":");

              service.setScheduleNotifications(
                DateTime(
                  date.year,
                  date.month,
                  date.day,
                  int.parse(timeParts[0]),
                  int.parse(timeParts[1]) - 15,
                ),
                "Jadwal ${schedule == "scheduleIn" ? "Waktunya Masuk Kerja" : "Waktunya Pulang Kerja"}",
                "Jadwal ${schedule == "scheduleIn" ? "Jangan lupa untuk melakukan presensi Clock-In" : "Jangan lupa untuk melakukan presensi Clock-Out"}",
              );
            }
          });
        } else {
          // Jika libur, hapus semua notifikasi terjadwal
          service.clearAllScheduledNotifications();
        }
      } else {
        log("Failed to fetch next day's shift");
      }
    } else {
      log("Request failed: ${response.reasonPhrase}");
    }
  }

  RxInt curIndex = 0.obs;
  RxInt curIndexCarousel = 0.obs;

  DateTime stringToDate(String time) {
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);

    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateTime object with today's date and the specified time
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
      seconds,
    );

    return dateTime;
  }

  bool cekApakahJamKerjaSelesai(String time) {
    DateTime endTime = stringToDate(time);

    // Check if createdAt is null and the endTime is after the current time
    if (m.ci.value.createdAt == null && DateTime.now().isAfter(endTime)) {
      return true;
    }
    return false;
  }

  String timeOfDayFormat(String timeString) {
    // Split the time string into hours, minutes, and seconds
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);

    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateTime object with today's date and the specified time
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
      seconds,
    );

    // Format the DateTime object to local date and time format
    String formattedDateTime = DateFormat('HH:mm').format(dateTime);

    return formattedDateTime;
  }

  bool checkClockOut(String aP) {
    DateTime now = DateTime.now();
    // Combine the current date with the provided time string
    String dateTimeString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${m.todayShift.value.scheduleOut}";
    // Parse the combined string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime a = DateTime.parse(aP);

    return a.isAfter(dateTime);
  }

  Future<bool> isReqGranted() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/permintaan/permission'),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = json.decode(str);
        final result = data['content']['isGranted'] ?? false;
        return result as bool;
      } else {
        return false;
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  String getImageAssetForCode({required String code}) {
    switch (code) {
      case 'CNKM':
        return 'CNKM.png';
      case 'CT':
        return 'CT.png';
      case 'CM':
        return 'CM.png';
      case 'COAM':
        return 'COAM.png';
      case 'CSSKM':
        return 'CSSKM.png';
      case 'CSTSD':
        return 'CSTSD.png';
      case 'CSSID':
        return 'CSSID.png';
      case 'CIMK':
        return 'CIMK.png';
      case 'CL':
        return 'CL.png';
      case 'CMKO':
        return 'CMKO.png';
      case 'IZIN':
        return 'IZIN.png';
      case 'CML':
        return 'CML.png';
      case 'CH':
        return 'CH.png';
      case 'DDK':
        return 'DDK.png';
      case 'CAKSRM':
        return 'CAKSRM.png';
      case 'DLK':
        return 'DLK.png';
      case 'CKM':
        return 'CKM.png';
      case 'CBA':
        return 'CBA.png';
      case 'CBRT':
        return 'CBRT.png';
      case 'CMA':
        return 'CMA.png';
      case 'CKA':
        return 'CKA.png';
      default:
        return 'default.png'; // fallback jika code tidak ditemukan
    }
  }
}
