import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../data/model/login_response_model.dart';
import '../data/model/month_attendance_response_model.dart';
import '../data/model/today_attendance_response_model.dart';
import '../models/attendance.dart';
import '../models/location.dart';
import '../models/schedule.dart';
import '../models/schedules.dart';
import '../models/time_off.dart';
import '../modules/camera_capture/views/camera_capture_view.dart';
import '../shared/button/button_1.dart';

import '../models/shift.dart';

class ModelController extends GetxController {
  RxString token = ''.obs;

  Rx<DateTime> pausedTime = DateTime.now().obs;

  // ===== overtime lembur
  RxString overtimeReqId = ''.obs;
  RxString typeOvertime = ''.obs;
  // =====

  // ===== butuh persetujuan
  RxInt leaveSize = 0.obs;
  RxInt attendanceSize = 0.obs;
  RxInt overtimeSize = 0.obs;
  RxInt changeShift = 0.obs;
  // =====

  Rx<User> u = Rx<User>(User(cabang: Cabang(), job: Job()));

  Rx<LoginResponseModel> detailUser = LoginResponseModel().obs;

  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;

  RxList<Attendance> attendance = <Attendance>[].obs;
  RxList<Schedules> schedules = <Schedules>[].obs;
  Rx<SchedulesPackage> schedulesPackage = Rx<SchedulesPackage>(
    SchedulesPackage(),
  );

  Rx<MonthAttendanceResponseModel> monthAttendance = Rx(
    MonthAttendanceResponseModel(),
  );

  RxList<User> listUser = <User>[].obs;
  Rx<Locations> locations = Locations().obs;

  Rx<Attendance> ci = Attendance().obs;
  Rx<Attendance> co = Attendance().obs;
  Rx<Shift> todayShift = Shift().obs;

  Rx<Master> timeOffMaster = Master().obs;

  RxList<User> karyawan = <User>[].obs;

  RxList<TimeOff> timeOff = <TimeOff>[].obs;

  DateTime? effectiveDate;
  Schedule? schedule;
  final loading = false.obs;

  clearModel() {
    leaveSize(0);
    attendanceSize(0);
    overtimeSize(0);
    changeShift(0);
    typeOvertime.value = '';
    overtimeReqId.value = '';
    timeOffMaster.value = Master();
    token.value = '';
    u.value = User(cabang: Cabang(), job: Job());
    attendance.value = [];
    ci.value = Attendance();
    co.value = Attendance();
    todayShift.value = Shift();
    karyawan.value = [];
    effectiveDate = null;
    schedule = null;
    locations.value = Locations();
    mfImage1 = null;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize schedule or handle it as nullable

    // fetchSchedule is an example function
    schedule = fetchSchedule() ?? Schedule(startDate: DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      connectivitySubscription = Connectivity().onConnectivityChanged.listen((
        event,
      ) {
        // debugPrint(event.first.toString());
        if (event.first == ConnectivityResult.none) {
          isOnline(false);
          dialogNoInternet();
        } else {
          if (!isOnline.value) {
            Get.back();
          }
          isOnline(true);
          // debugPrint('log_info: connected to internet');
        }
      });
    });
  }

  // network setting
  RxBool isOnline = true.obs;
  RxBool isLoading = false.obs;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  Schedule? fetchSchedule() {
    // Replace with your actual code to fetch or create a Schedule object
    // Return null if no schedule is found
    return null;
  }

  // face recognition
  MatchFacesImage? mfImage1;

  Future checkInternetConnection() async {
    try {
      final List<ConnectivityResult> connection = await (Connectivity()
          .checkConnectivity());
      if (connection.first == ConnectivityResult.none) {
        await dialogNoInternet();
      }
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<void> dialogNoInternet() async {
    final box = Hive.box('andioffset');
    final String? token = await box.get('token');

    await Get.dialog(
      barrierDismissible: true,
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icons/ic_network.png",
                width: 150,
                height: 150,
              ),
              const Gap(10),
              Text(
                'Oops, terjadi sedikit gangguan. Periksa koneksi internetmu.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 14),
              ),
              const Gap(15),
              Obx(
                () => isLoading.value
                    ? CupertinoActivityIndicator()
                    : Button1(
                        title: 'Coba Lagi',
                        onTap: () async {
                          isLoading(true);
                          await Future.delayed(
                            const Duration(seconds: 6),
                          ).then((value) => isLoading(false));
                        },
                      ),
              ),
              const Gap(10),
              if (token != null)
                Button1(
                  title: 'Presensi Offline',
                  onTap: () async {
                    Uint8List? storedImage = box.get('storedImage');
                    if (storedImage == null) {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Peringatan!'),
                          content: Text(
                            'Hanya lakukan presensi offline jika anda belum melakukan presensi, dan pastikan anda terkoneksi internet untuk mengirim data presensi ini nanti.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                Get.back();
                                Get.to(
                                  () => CameraCaptureView(),
                                  arguments: '502',
                                );
                              },
                              child: Text('Lanjutkan'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
