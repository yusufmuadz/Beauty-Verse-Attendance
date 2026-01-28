import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/pengajuan_pergantian_shift_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/components/custom_dialog.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/attendance_overtime_response_model.dart';
import 'package:lancar_cat/app/data/model/identify_job_scope_response_model.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/modules/locations_tracker/views/locations_tracker_view.dart';
import 'package:lancar_cat/app/modules/services/cuti/views/cuti_view.dart';
import 'package:lancar_cat/app/modules/services/istirahat_telat/views/istirahat_telat_view.dart';
import 'package:lancar_cat/app/modules/services/izin%20kembali/izin_kembali_view.dart';
import 'package:lancar_cat/app/routes/app_pages.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/snackbar/snackbar_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../controllers/api_controller.dart';
import '../../../core/constant/time_format_schedule.dart';
import '../../../shared/icons/icon_widget_service.dart';
import '../../services/absen/views/absen_view.dart';
import '../../services/daftar_absen/views/daftar_absen_view.dart';
import '../../services/lembur/views/history_lembur_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());
  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  int indexAxis = 0;

  Rx<Color> sliverColor = Colors.amber.shade800.obs;
  Rx<Color> textColor = Colors.white.obs;

  List<String> banner = ['bn_1.png', 'bn_2.png', 'bn_3.png'];

  @override
  void initState() {
    super.initState();
    setState(() {});

    // showTutorial();
    initHistory();
  }

  Future<void> _onRefresh() async {
    setState(() {});
    await controller.a.todayAttendance();
    await controller.a.fetchCurrentUser();
    await initHistory();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    m.pausedTime.value = DateTime.now();
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            BuildMenuService(),
            Obx(() => _buildService()),
            if (true) _buildOvertimeWidget(),
            // _carouselSliderNews(),
            _buildTeamWidget(),
            const Gap(25),
          ],
        ),
      ),
    );
  }

  Future checkCurrentVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      return version;
    } catch (e) {
      log(e.toString());
    }
  }

  _buildOvertimeWidget() {
    return FutureBuilder(
      future: fetchAttendanceLembur(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          AttendanceOvertimeResponseModel overtime =
              snapshot.data as AttendanceOvertimeResponseModel;

          if (overtime.data == null) {
            // jika tidak ada shift hari itu
            return Container();
          }
          m.typeOvertime(overtime.data == null ? '' : overtime.statusOvertime);

          m.overtimeReqId(
            overtime.detailOvertime == null ? '' : overtime.detailOvertime!.id,
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: HexColor('#e1faff'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  'Presensi Lembur ${overtime.statusOvertime!.replaceAll('_', ' ').capitalizeFirst!}',
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Gap(10),
                if (overtime.detailOvertime!.type == 'Day off')
                  Row(
                    children: [
                      CustomTileInfo(
                        icons: Iconsax.coffee_copy,
                        title: 'Jam Masuk',
                        subtitle:
                            '${TimeFormatSchedule().timeOfDayFormat(overtime.detailOvertime!.timeInDayoff!)}',
                        note: 'Lembur masuk',
                      ),
                      const Gap(10),
                      CustomTileInfo(
                        icons: Iconsax.coffee_copy,
                        title: 'Jam Keluar',
                        subtitle:
                            '${TimeFormatSchedule().timeOfDayFormat(overtime.detailOvertime!.timeOutDayoff!)}',
                        note: 'Lembur Keluar',
                      ),
                    ],
                  ),
                const Gap(10),
                Row(
                  children: [
                    CustomTileInfo(
                      icons: Iconsax.coffee_copy,
                      title: 'Clock In',
                      subtitle: (overtime.data!.clockIn == null)
                          ? '-- : --'
                          : DateFormat(
                              'HH:mm',
                              'id_ID',
                            ).format(overtime.data!.clockIn!.createdAt!),
                      note: 'Lembur masuk',
                    ),
                    const Gap(10),
                    CustomTileInfo(
                      icons: Iconsax.coffee_copy,
                      title: 'Clock Out',
                      subtitle: (overtime.data!.clockOut == null)
                          ? '-- : --'
                          : DateFormat(
                              'HH:mm',
                              'id_ID',
                            ).format(overtime.data!.clockOut!.createdAt!),
                      note: 'Lembur keluar',
                    ),
                  ],
                ),
                const Gap(10),
                if (overtime.data!.clockOut == null)
                  Button1(
                    backgroundColor: overtime.data!.clockIn == null
                        ? Colors.amber
                        : Colors.red,
                    title:
                        '${overtime.data!.clockIn == null ? "Clock In" : "Clock Out"} Overtime',
                    onTap: () async {
                      await Get.to(
                        () => LocationsTrackerView(),
                        arguments: '5',
                      );
                      setState(() {});
                    },
                  ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  _buildTeamWidget() {
    return FutureBuilder(
      future: a.identifyJobScope(
        date: DateFormat('yyyy-MM-dd', 'id_ID').format(DateTime.now()),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonizerWidget();
        } else if (snapshot.hasData) {
          IdentifyJobScopeResponseModel model = snapshot.data;

          if (model.data!.isEmpty) {
            return const SizedBox();
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tim Anda",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.SUBORDINATE),
                        child: Text(
                          "Lebih Lengkap",
                          style: GoogleFonts.figtree(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: Get.width,
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: model.data!.length,
                    itemBuilder: (context, index) {
                      User u = model.data![index];
                      return SizedBox(
                        key: ValueKey(u.id),
                        width: 100,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(
                                  100,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: u.avatar ?? '',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.medium,
                                  memCacheHeight: 100,
                                  memCacheWidth: 100,
                                  maxWidthDiskCache: 100,
                                  maxHeightDiskCache: 100,
                                ),
                              ),
                            ),

                            const Gap(10),
                            Text(
                              u.nama ?? "-",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.figtree(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Gap(10),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Skeletonizer _skeletonizerWidget() {
    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Ini Dummy"), Text("Ini Dummy")],
            ),
          ),
          const Gap(15),
          SizedBox(
            width: Get.width,
            height: 100,
            child: ListView.builder(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Skeleton.shade(child: CircleAvatar()),
                      Text("Dahlah"),
                      Text("Dahlah ini"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool termsAndConditionsIstirahatTelat() {
    if (controller.m.ci.value.id == null) {
      Snackbar().snackbar1(
        'Informasi',
        'Anda perlu melakukan clock-in terlebih dahulu',
        null,
        Colors.white,
        Colors.orange,
      );
      return false;
    }

    if (!checkTime(controller.m.todayShift.value.scheduleOut!)) {
      Snackbar().snackbar1(
        'Informasi',
        'Anda sudah melewati waktu kerja',
        Iconsax.clock_copy,
        Colors.white,
        Colors.orange,
      );
      return false;
    }

    if (checkTime(controller.m.todayShift.value.breakEnd!)) {
      Snackbar().snackbar1(
        'Informasi',
        'Anda belum lewat dari jam istirahat',
        Iconsax.clock_copy,
        Colors.white,
        Colors.orange,
      );
      return false;
    }

    return true;
  }

  Stream<DateTime> timeStream() async* {
    DateTime current = DateTime.now();
    yield current; // Emit the initial date
    yield* Stream.periodic(Duration(minutes: 1), (_) {
      current = current.add(Duration(minutes: 1));
      return current;
    });
  }

  FutureBuilder _buildService() {
    return FutureBuilder(
      future: controller.a.todayAttendance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _customSkleton();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Obx(
            () => (controller.m.todayShift.value.dayoff == null)
                ? _noShiftDetected(title: 'Tidak ada shift hari ini')
                : (controller.m.todayShift.value.dayoff == '0')
                ? (controller.m.timeOffMaster.value.id != null)
                      ? Container(
                          margin: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Presensi Hari Ini',
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const Gap(20),
                              Center(
                                child: Image.asset(
                                  'assets/icons/${controller.getImageAssetForCode(code: controller.m.timeOffMaster.value.code!)}',
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              const Gap(10),
                              Center(
                                child: Text(
                                  'Anda Mengambil ${controller.m.timeOffMaster.value.name}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: regular,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Menu Presensi',
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  StreamBuilder<DateTime>(
                                    stream: timeStream(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      DateTime currentTime = snapshot.data!;

                                      return CustomTileInfo(
                                        picture:
                                            'assets/icons/ic_calendar_attendance.png',
                                        icons: Iconsax.calendar_1_copy,
                                        title: 'Tanggal',
                                        subtitle: DateFormat(
                                          'dd MMM yyyy',
                                          'id_ID',
                                        ).format(currentTime),
                                        note:
                                            'Waktu: ${DateFormat('HH:mm', 'id_ID').format(currentTime)}',
                                      );
                                    },
                                  ),
                                  const Gap(10),
                                  CustomTileInfo(
                                    picture: 'assets/icons/ic_office.png',
                                    icons: Iconsax.building_4_copy,
                                    title:
                                        '${controller.m.todayShift.value.shiftName}',
                                    subtitle:
                                        "${controller.timeOfDayFormat(controller.m.todayShift.value.scheduleIn!)} - ${controller.timeOfDayFormat(controller.m.todayShift.value.scheduleOut!)}",
                                    note:
                                        "Istirahat: ${controller.timeOfDayFormat(controller.m.todayShift.value.breakStart!)} - ${controller.timeOfDayFormat(controller.m.todayShift.value.breakEnd!)}",
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  CustomTileInfo(
                                    picture: 'assets/icons/ic_clockin.png',
                                    icons: Iconsax.login_1_copy,
                                    title: 'Clock In',
                                    subtitle: (m.ci.value.createdAt == null)
                                        ? "-- : --"
                                        : DateFormat(
                                            'HH:mm',
                                          ).format(m.ci.value.createdAt!),
                                    note: (m.ci.value.createdAt == null)
                                        ? "Belum Clock-In"
                                        : (TimeFormatSchedule()
                                              .timeFormatDateTime(
                                                DateFormat(
                                                  'HH:mm',
                                                  'id_ID',
                                                ).format(m.ci.value.createdAt!),
                                              )
                                              .isAfter(
                                                TimeFormatSchedule()
                                                    .timeFormatDateTime(
                                                      m
                                                          .todayShift
                                                          .value
                                                          .scheduleIn!,
                                                    ),
                                              ))
                                        ? 'Terlambat'
                                        : 'Tepat Waktu',
                                  ),
                                  const Gap(10),
                                  CustomTileInfo(
                                    picture: 'assets/icons/ic_clockout.png',
                                    icons: Iconsax.logout_1_copy,
                                    title: 'Clock Out',
                                    subtitle: (m.co.value.createdAt == null)
                                        ? "-- : --"
                                        : DateFormat(
                                            'HH:mm',
                                          ).format(m.co.value.createdAt!),
                                    note: (m.co.value.createdAt == null)
                                        ? "Belum Clock-Out"
                                        : (TimeFormatSchedule()
                                              .timeFormatDateTime(
                                                DateFormat(
                                                  'HH:mm',
                                                  'id_ID',
                                                ).format(m.co.value.createdAt!),
                                              )
                                              .isBefore(
                                                TimeFormatSchedule()
                                                    .timeFormatDateTime(
                                                      m
                                                          .todayShift
                                                          .value
                                                          .scheduleOut!,
                                                    ),
                                              ))
                                        ? 'Lebih Awal'
                                        : 'Tepat Waktu',
                                  ),
                                ],
                              ),
                              Obx(() {
                                if (controller.m.co.value.type == null) {
                                  return Column(
                                    children: [
                                      const Gap(10),
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              offset: Offset(0, 2),
                                              blurRadius: 3.0,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Button1(
                                          backgroundColor:
                                              checkStatusAttendance()
                                              ? Colors.amber
                                              : Colors.red,
                                          showOutline: false,
                                          title: checkStatusAttendance()
                                              ? 'Clock In'
                                              : 'Clock Out',
                                          onTap: _submitAttendance,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return SizedBox();
                              }),
                            ],
                          ),
                        )
                : (controller.m.todayShift.value.dayoff == "1")
                ? Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CustomTileInfoHoliday(
                          icons: Iconsax.calendar_remove_copy,
                          title: 'Shift',
                          subtitle:
                              "${controller.m.todayShift.value.shiftName == 'dayoff' ? 'Hari libur' : controller.m.todayShift.value.shiftName}",
                          note:
                              "${controller.m.todayShift.value.shiftName == 'dayoff' ? 'Selamat berlibur' : controller.m.todayShift.value.shiftName}",
                        ),
                        Gap(10),
                        Button1(
                          title: 'Ambil Shift Flexible',
                          onTap: () =>
                              Get.to(() => PengajuanPergantianShiftView()),
                        ),
                      ],
                    ),
                  )
                : _noShiftDetected(title: 'Selamat Beristirahat'),
          );
        }

        return Text('something went wrong');
      },
    );
  }

  Widget _customSkleton() {
    return Skeletonizer(
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Presensi Hari Ini',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Gap(10),
            Row(
              children: [
                CustomTileInfo(
                  picture: 'assets/icons/ic_calendar_attendance.png',
                  icons: Iconsax.calendar_1_copy,
                  title: 'Tanggal',
                  subtitle: 'dd MMM yyyy',
                  note: 'dd MMM yyyy',
                ),
                const Gap(10),
                CustomTileInfo(
                  picture: 'assets/icons/ic_office.png',
                  icons: Iconsax.building_4_copy,
                  title: 'shift apa saja',
                  subtitle: "16:00 - 16:00",
                  note: "Istirahat: 16:00 - 16:00",
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                CustomTileInfo(
                  picture: 'assets/icons/ic_office.png',
                  icons: Iconsax.building_4_copy,
                  title: 'shift apa saja',
                  subtitle: "16:00 - 16:00",
                  note: "Istirahat: 16:00 - 16:00",
                ),
                const Gap(10),
                CustomTileInfo(
                  picture: 'assets/icons/ic_office.png',
                  icons: Iconsax.building_4_copy,
                  title: 'shift apa saja',
                  subtitle: "16:00 - 16:00",
                  note: "Istirahat: 16:00 - 16:00",
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: 3.0,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Button1(
                backgroundColor: checkStatusAttendance()
                    ? Colors.amber
                    : Colors.red,
                showOutline: false,
                title: checkStatusAttendance() ? 'Clock In' : 'Clock Out',
                onTap: _submitAttendance,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _noShiftDetected({required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.all(10),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Iconsax.calendar_1_copy),
          const Gap(5),
          Text(
            title,
            style: GoogleFonts.varelaRound(fontWeight: regular, fontSize: 14),
          ),
        ],
      ),
    );
  }

  bool checkTime(String time) {
    // Waktu yang akan dicek (12:45:00)
    String t = time;

    int hour = int.parse('${t[0]}${t[1]}');
    int minute = int.parse('${t[3]}${t[4]}');

    final targetTime = TimeOfDay(hour: hour, minute: minute);

    // Waktu saat ini
    final now = TimeOfDay.now();

    // Konversi waktu menjadi menit sejak tengah malam untuk perbandingan yang lebih mudah
    final targetMinutes = targetTime.hour * 60 + targetTime.minute;
    final currentMinutes = now.hour * 60 + now.minute;

    // Pengecekan apakah targetTime sudah lewat
    if (currentMinutes > targetMinutes) {
      // sudah lewat
      return false;
    } else {
      //  belum lewat
      return true;
    }
  }

  initHistory() async {
    try {
      await controller.a.todayAttendance();
      await controller.a.fetchCurrentUser();
      a.getAgreementLine();
      a.findSubmissionByUserId();
      a.findOvertimeByLine();
    } catch (e) {
      log(e.toString());
    }
  }

  // make a greeting message

  greetingMessage() {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Terima Kasih!",
          style: GoogleFonts.varelaRound(fontSize: 18, fontWeight: semiBold),
        ),
        content: Text(
          "Terima kasih telah menjadi bagian dari testing aplikasi SIAP. Untuk kestabilan jaringan, disarankan menggunakan data seluler.",
          style: GoogleFonts.varelaRound(fontSize: 14, fontWeight: regular),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK", style: GoogleFonts.varelaRound()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future fetchAttendanceLembur() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/user/check/lembur'),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = AttendanceOvertimeResponseModel.fromJson(str);
        return data;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      CustomDialog(title: 'Error!', content: e.toString());
    }
  }

  bool checkStatusAttendance() {
    return (controller.m.ci.value.createdAt != null)
        ? false
        : true; // clockout // clockin
  }

  _submitAttendance() async {
    // Pengecekan apakah waktu di atur secara otomatis
    if (Platform.isAndroid) {
      bool timeAuto = await DatetimeSetting.timeIsAuto();
      bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

      if (!timezoneAuto || !timeAuto) {
        Get.dialog(
          CustomDialog(
            title: 'informasi',
            content:
                'Anda harus mengatur waktu menjadi otomatis akan dapat melanjutkan presensi',
            onConfirm: () async {
              await DatetimeSetting.openSetting();
              Get.back();
            },
            onCancel: () => Get.back(),
          ),
        );
        return;
      }
    }

    bool isEnabled = await controller.g.askingPermission();

    if (!isEnabled) {
      _alertLocationNeeded();
      return;
    }

    if (m.u.value.avatar!.split('/').last.contains('default.jpg')) {
      Get.dialog(
        AlertDialog(
          content: SizedBox(
            width: Get.width * 0.8, // Sesuaikan lebar dialog
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info_outline),
                const Gap(10),
                Expanded(
                  child: Text(
                    "Anda perlu melengkapi Avatar terlebih dahulu.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.outfit(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    if (isEnabled) {
      Get.to(() => LocationsTrackerView(), arguments: '0');
    }
  }

  _alertLocationNeeded() {
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      backgroundColor: whiteColor,
      Container(
        height: 300,
        width: Get.width,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.radar, color: redColor, size: 60.0),
                  const Gap(5),
                  Text(
                    'Tidak ada koneksi internet. \nPeriksa koneksi Anda.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.varelaRound(
                      fontWeight: semiBold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Button1(
              title: 'Kembali',
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BuildMenuService extends StatelessWidget {
  const BuildMenuService({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Menu Pengajuan',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          FutureBuilder<bool>(
            future: HomeController().isReqGranted(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _skeletonWidget();
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    'Jaringan Tidak Stabil',
                    style: GoogleFonts.outfit(fontSize: 12),
                  ),
                );
              }

              final additionalWidgets = [
                {
                  "title": "Lembur",
                  "picture": "assets/icons/ic_overtime.png",
                  "onTap": () => Get.to(() => LemburView()),
                },
                {
                  "title": "Inbox",
                  "picture": "assets/icons/ic_pengajuan.png",
                  "onTap": () {
                    final controller = Get.put(HomeController());
                    controller.curIndex(2);
                  },
                },
                {
                  "title": "Pengajuan Presensi",
                  "picture": "assets/icons/ic_coming_soon.png",
                  "onTap": () =>
                      Get.to(() => DaftarAbsenView(), arguments: 'presensi'),
                },
              ];

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 9.0,
                  runSpacing: 9.0,
                  children: [
                    IconWidgetService(
                      onTap: () =>
                          Get.to(() => DaftarAbsenView(), arguments: true),
                      title: "Log Presensi",
                      icons: Iconsax.book_1_copy,
                      iconsColor: HexColor("#fa8f57"),
                      colors: HexColor("#3FCA6A"),
                      picture: 'assets/icons/ic_history.png',
                    ),
                    IconWidgetService(
                      onTap: () => Get.to(() => AbsenView()),
                      title: "Presensi",
                      icons: Iconsax.map_1_copy,
                      iconsColor: HexColor("#6daae1"),
                      colors: HexColor("#B61277"),
                      picture: 'assets/icons/ic_presensi.png',
                    ),
                    IconWidgetService(
                      onTap: () => Get.to(() => IstirahatTelatView()),
                      title: "Istirahat Telat",
                      icons: Iconsax.clock_copy,
                      iconsColor: HexColor("#f8b131"),
                      colors: HexColor("#DC2C0A"),
                      picture: 'assets/icons/ic_running.png',
                    ),
                    IconWidgetService(
                      onTap: () => Get.to(
                        () => CutiView(),
                        transition: Transition.cupertino,
                      ),
                      title: "Cuti",
                      icons: Iconsax.briefcase_copy,
                      size: 25,
                      iconsColor: HexColor("#b5ca7b"),
                      colors: HexColor("#CA36F3"),
                      picture: 'assets/icons/ic_leave.png',
                    ),
                    IconWidgetService(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IzinKembaliView(),
                        ),
                      ),
                      title: "Izin Kembali",
                      icons: Iconsax.refresh_circle_copy,
                      iconsColor: HexColor("#FF6C6C"),
                      colors: HexColor("#9B4C7C"),
                      picture: 'assets/icons/ic_return.png',
                    ),
                    ...additionalWidgets.map(
                      (e) => IconWidgetService(
                        onTap: e["onTap"] as Function(),
                        title: e["title"].toString(),
                        icons: Iconsax.more_2_copy,
                        iconsColor: HexColor("#FF6C6C"),
                        colors: HexColor("#9B4C7C"),
                        picture: e["picture"].toString(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomTileInfo extends StatelessWidget {
  const CustomTileInfo({
    super.key,
    required this.title,
    required this.subtitle,
    required this.note,
    required this.icons,
    this.picture,
  });

  final IconData icons;
  final String title;
  final String subtitle;
  final String note;
  final String? picture;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: .5, color: Colors.grey.shade300),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: HexColor('#e1faff').withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: picture == null
                        ? Icon(icons, color: HexColor("#01bede"))
                        : Image.asset(picture!, width: 17, height: 17),
                  ),
                ),
                const Gap(5.0),
                SizedBox(
                  width: Get.width * 0.25,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(7),
            Text(
              subtitle,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 16.5,
              ),
            ),
            const Gap(6),
            Text(
              note,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_skeletonWidget() {
  return Skeletonizer(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 9.0,
        runSpacing: 9.0,
        children: List.generate(
          8,
          (index) => IconWidgetService(
            onTap: () => Get.to(() => DaftarAbsenView(), arguments: true),
            title: "Log Presensi",
            icons: Iconsax.book_1_copy,
            iconsColor: HexColor("#fa8f57"),
            colors: HexColor("#3FCA6A"),
            picture: 'assets/icons/ic_history.png',
          ),
        ),
      ),
    ),
  );
}

class CustomTileInfoHoliday extends StatelessWidget {
  const CustomTileInfoHoliday({
    super.key,
    required this.title,
    required this.subtitle,
    required this.note,
    required this.icons,
    this.picture,
  });

  final IconData icons;
  final String title;
  final String subtitle;
  final String note;
  final String? picture;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: HexColor('#01bede').withOpacity(0.4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#e1faff').withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: picture == null
                      ? Icon(icons, color: HexColor("#01bede"))
                      : Image.asset(picture!, width: 20, height: 20),
                ),
              ),
              const Gap(7.0),
              SizedBox(
                width: Get.width * 0.25,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Gap(7),
          Text(
            subtitle,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const Gap(6),
          Text(
            note.toLowerCase(),
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTilePengajuan extends StatelessWidget {
  const CustomTilePengajuan({
    super.key,
    required this.title,
    required this.icons,
    this.onTap,
  });

  final String title;
  final IconData icons;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(icons),
          title: Text('$title', style: GoogleFonts.varelaRound()),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
        ),
        const Gap(10),
      ],
    );
  }
}

class DetailTimeHome extends StatelessWidget {
  const DetailTimeHome({super.key, required this.title, required this.time});

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber.shade800),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.varelaRound(
              color: Colors.grey.withAlpha(180),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const Gap(3),
          Text(
            // Menampilkan waktu saat ini
            time,
            style: GoogleFonts.lexend(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }
}

class CarouselTile extends StatelessWidget {
  const CarouselTile({
    super.key,
    required this.url,
    this.onTap,
    required this.title,
    required this.subtitle,
  });

  final Function()? onTap;
  final String url;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage('assets/banner/$url'),
            fit: BoxFit.cover,
          ),
        ),
        width: Get.width,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54.withOpacity(0.1),
                Colors.black54.withOpacity(0.3),
                Colors.black54.withOpacity(0.4),
                Colors.black54.withOpacity(0.5),
                Colors.black54.withOpacity(0.7),
                Colors.black54.withOpacity(0.9),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$title',
                style: GoogleFonts.varelaRound(
                  fontWeight: semiBold,
                  color: whiteColor,
                  fontSize: 16,
                ),
              ),
              Text(
                '$subtitle',
                style: GoogleFonts.varelaRound(
                  fontWeight: regular,
                  color: whiteColor,
                  fontSize: 11,
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
