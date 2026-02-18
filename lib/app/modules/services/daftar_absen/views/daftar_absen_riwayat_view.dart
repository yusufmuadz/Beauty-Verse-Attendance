import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/data/model/log_submission_response_model.dart';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lancar_cat/app/shared/error_message.dart';
import 'package:latlong2/latlong.dart';
import 'package:lancar_cat/app/shared/dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/time_format_schedule.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/month_attendance_response_model.dart';
import 'package:lancar_cat/app/models/attendance.dart';
import 'package:lancar_cat/app/models/holiday.dart';
import 'package:lancar_cat/app/models/overtime.dart';
import 'package:lancar_cat/app/modules/home/controllers/home_controller.dart';
import 'package:lancar_cat/app/shared/images/images.dart';
import 'package:lancar_cat/app/shared/tile/tile3.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../../shared/textfield/textfield_1.dart';

class DaftarAbsenRiwayatView extends StatefulWidget {
  const DaftarAbsenRiwayatView({super.key});

  @override
  State<DaftarAbsenRiwayatView> createState() => _DaftarAbsenRiwayatViewState();
}

class _DaftarAbsenRiwayatViewState extends State<DaftarAbsenRiwayatView> {
  final calendarC = TextEditingController();

  int sYear = DateTime.now().year;
  int sMonth = DateTime.now().month;

  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  List<DateTime> sDate = [];

  RxBool isLoading = false.obs;

  DateTime date = DateTime.now();
  DateTime startDate = DateTime.now();

  List<Map<String, String?>> customDayOff = [];

  @override
  void initState() {
    super.initState();
    // INFO: buat sebuah fungsi untuk get schedule dan simpan kedalam variable lokal
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initHistory();
    });
  }

  @override
  void dispose() {
    calendarC.dispose();
    super.dispose();
  }

  initHistory() async {
    calendarC.text = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime(date.year, date.month));
    DateTime now = DateTime.now();
    await getSchedule(now.month, now.year);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.grey.shade100,
      onRefresh: () async => await initHistory(),
      child: Obx(() {
        if (m.loading.value) {
          return LoadingScreen();
        }

        if (m.monthAttendance.value.detail == null) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                ),
                child: Center(child: Text('Tidak ada data')),
              ),
            ],
          );
        }

        return ListView(
          children: [
            const Gap(10),
            datePicker(context),
            const Gap(10),
            attendanceReport(),
            const Gap(10),
            listTileDate(),
          ],
        );
      }),
    );
  }

  datePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField1(
        readOnly: true,
        suffixIcon: Icon(Iconsax.arrow_down_1_copy, size: 15),
        preffixIcon: Icon(Iconsax.calendar_1_copy),
        fillColor: whiteColor,
        hintText: calendarC.text,
        controller: calendarC,
        onTap: () async {
          showMonthPicker(
            context,
            onSelected: (month, year) async {
              isLoading.toggle();
              await getSchedule(month, year);
              isLoading.toggle();

              setState(() {
                calendarC.text = DateFormat(
                  'MMMM yyyy',
                  'id_ID',
                ).format(DateTime(year, month));
              });
            },
            initialSelectedMonth: sMonth,
            initialSelectedYear: sYear,
            firstYear: m.effectiveDate?.year,
            lastYear: sYear + 3,
            selectButtonText: 'OK',
            cancelButtonText: 'Cancel',
            highlightColor: Colors.amber.shade600,
            textColor: Colors.white,
            contentBackgroundColor: Colors.white,
            dialogBackgroundColor: Colors.grey[200],
          );
        },
      ),
    );
  }

  listTileDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(m.monthAttendance.value.data!.length, (index) {
          DetailSchedule schedule = m.monthAttendance.value.data![index];
          return _customTileDate(schedule: schedule, context: context);
        }),
      ),
    );
  }

  attendanceReport() {
    final alert = DialogCustom();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: Get.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tileInfo(
                text: 'Sisa Hari Kerja',
                value: m.monthAttendance.value.detail!.presensi,
                onTap: () {
                  alert.dialog(
                    onTap: () => Get.back(),
                    title: "Informasi",
                    subtitle:
                        "Total hari kebelakang yang tidak masuk tanpa keterangan (izin, cuti, dll)",
                  );
                },
              ),
              Container(width: 0.5, height: 30, color: Colors.black),
              tileInfo(
                text: 'Pulang Cepat',
                value: m.monthAttendance.value.detail!.earlyClockOut,
                onTap: () {
                  alert.dialog(
                    onTap: () => Get.back(),
                    title: 'Informasi',
                    subtitle:
                        "Total berapa kali pulang sebelum Clock-Out di hari kebelakang",
                  );
                },
              ),
            ],
          ),
          Divider(thickness: 0.5, color: Colors.black, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tileInfo(
                text: 'Terlambat',
                value: m.monthAttendance.value.detail!.lateClockIn,
                onTap: () {
                  alert.dialog(
                    onTap: () => Get.back(),
                    title: 'Informasi',
                    subtitle: "Total berapa kali terlambat Clock-In",
                  );
                },
              ),
              Container(width: 0.5, height: 30, color: Colors.black),
              tileInfo(
                text: 'Tidak Clock-Out',
                value: m.monthAttendance.value.detail!.notClockOut,
                onTap: () {
                  alert.dialog(
                    onTap: () => Get.back(),
                    title: 'Informasi',
                    subtitle:
                        "Total berapa kali tidak Clock-Out di hari belakang",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  tileInfo({final String? text, final int? value, Function()? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(
              '$value',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontWeight: medium, fontSize: 19),
            ),
            const Gap(5),
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: HexColor('#faf2ef'),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text!.toLowerCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                      fontSize: 11,
                    ),
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(Iconsax.info_circle_copy, size: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final h = Get.put(HomeController());

  Future getSchedule(int? month, int? year) async {
    m.loading.value = true;
    Uri url = Uri.parse(
      '${Variables.baseUrl}/testing/details?year=${year ?? DateTime.now().year}&month=${month ?? DateTime.now().month}',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${m.token.value}'},
      );

      debugPrint('URL: $url');
      debugPrint('Response status: ${response.statusCode}');
      // debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final result = MonthAttendanceResponseModel.fromMap(data);
        m.monthAttendance(result);
      } else {
        final statusCode = response.statusCode;

        Get.snackbar('Gagal!', ErrorMessage().message(statusCode));
      }
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }
    m.loading.value = false;
  }

  _customTileDate({
    required DetailSchedule schedule,
    required BuildContext context,
  }) {
    bool isEnable = schedule.pattern!.dayoff == '1' ? true : false;
    DateTime date = DateTime.parse(schedule.date!.toIso8601String());
    AbsenRecap? absenRecap = schedule.absenRecap;

    Holiday? holiday = schedule.holiday;
    List<Overtime> listOvertime = schedule.overtimeAttendance ?? [];

    bool isTimeOff = false;

    if (schedule.absenRecap != null) {
      if (schedule.absenRecap!.userTimeoffRequestId != null) {
        isTimeOff = true;
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: (schedule.pattern!.dayoff == '1' || holiday != null)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : (isTimeOff)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : Colors.amber.shade100.withValues(alpha: .3),
            ),
          ),
          child: Material(
            elevation: 1.2,
            shadowColor: (schedule.pattern!.dayoff == '1' || holiday != null)
                ? Colors.red.shade400
                : (isTimeOff)
                ? Colors.red.shade400
                : Colors.amber.shade400,
            borderRadius: BorderRadius.circular(10),
            child: ExpansionTile(
              enabled: !isTimeOff,
              clipBehavior: Clip.hardEdge,
              backgroundColor:
                  (schedule.pattern!.dayoff == '1' || holiday != null)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : (isTimeOff)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : Colors.amber.shade100.withValues(alpha: .3),
              collapsedBackgroundColor:
                  (schedule.pattern!.dayoff == '1' || holiday != null)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : (isTimeOff)
                  ? Colors.red.shade100.withValues(alpha: .3)
                  : Colors.amber.shade100.withValues(alpha: .3),
              tilePadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              trailing: schedule.attendance!.isEmpty ? const SizedBox() : null,
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${DateFormat('dd MMMM', 'id_ID').format(date)}${schedule.pattern!.dayoff == '1' || holiday != null
                        ? ''
                        : (absenRecap != null)
                        ? (absenRecap.userTimeoffRequestId != null)
                              ? ', Cuti'
                              : ', Hari kerja'
                        : ', Hari Kerja'}${listOvertime.isNotEmpty ? ' (Lembur)' : ''}${schedule.absenRecap != null ? (schedule.absenRecap!.userPermitOut != null ? ' (Lainnya)' : '') : ''}',
                    style: GoogleFonts.quicksand(
                      color: isEnable || holiday != null
                          ? Colors.red
                          : (isTimeOff)
                          ? Colors.red
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const Gap(10),
                ],
              ),
              subtitle: (schedule.pattern!.dayoff == '1' || holiday != null)
                  ? Text(
                      holiday != null
                          ? "${holiday.summary}"
                          : schedule.pattern!.shiftName == 'dayoff'
                          ? 'Hari Libur'
                          : '${schedule.pattern!.shiftName}',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        color: isEnable || holiday != null
                            ? Colors.red
                            : (isTimeOff)
                            ? Colors.red
                            : Colors.black,
                        fontSize: 12,
                      ),
                    )
                  : (isTimeOff)
                  ? Text(
                      'Anda mengajukan ${absenRecap!.name}',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber.withValues(alpha: .1),
                                ),
                                padding: const EdgeInsets.all(7.0),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/ic_clockin.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const Gap(10.0),
                              Text(
                                (schedule.attendance!.isEmpty)
                                    ? '--:--'
                                    : DateFormat('HH:mm', 'id_ID').format(
                                        schedule.attendance![0].createdAt!,
                                      ),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lexend(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: schedule.isClockInLate!
                                      ? redColor
                                      : (isTimeOff)
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.amber.withValues(alpha: .1),
                                ),
                                padding: const EdgeInsets.all(7.0),
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/ic_clockout.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                              const Gap(10.0),
                              if (schedule.attendance!.length > 1) ...[
                                Text(
                                  (schedule.attendance!.length == 1)
                                      ? '--:--'
                                      : DateFormat('HH:mm', 'id_ID').format(
                                          schedule.attendance![1].createdAt!,
                                        ),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: schedule.isClockOutEarly!
                                        ? redColor
                                        : Colors.black,
                                  ),
                                ),
                              ] else ...[
                                Text('--:--'),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
              children:
                  schedule.attendance!
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                            onTap: () {
                              _detailTile(attendance: e, schedule: schedule);
                            },
                            trailing: Icon(Icons.keyboard_arrow_right_outlined),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('HH:mm').format(e.createdAt!),
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    (e.type == 'clockin'
                                            ? 'Clock In'
                                            : 'Clock Out')
                                        .capitalizeFirst!,
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()
                    ..addAll(
                      (listOvertime.length > 0)
                          ? listOvertime.map(
                              (e) => CustomLemburTile(context, e),
                            )
                          : [],
                    )
                    ..add(
                      (schedule.absenRecap != null &&
                              (schedule.absenRecap!.userLateBreakInId != null ||
                                  schedule.absenRecap!.userPermitOut != null))
                          ? customPengajuan(
                              context: context,
                              lateBreakIn:
                                  schedule.absenRecap!.userLateBreakInId,
                              permitOut: schedule.absenRecap!.userPermitOut,
                            )
                          : Container(),
                    ),
            ),
          ),
        ),
        const Gap(7),
      ],
    );
  }

  Container customPengajuan({
    required BuildContext context,
    String? lateBreakIn,
    String? permitOut,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 6, 0),
        trailing: Icon(Icons.keyboard_arrow_right_outlined),
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Iconsax.more_2_copy, color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Lihat pengajuan lainnya',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            builder: (context) {
              return Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                height: Get.height * 0.8,
                child: FutureBuilder(
                  future: fetchLogSubmission(
                    listIdPermitOut: permitOut,
                    idLateBreak: lateBreakIn,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      LogSubmissionResponseModel? result =
                          snapshot.data as LogSubmissionResponseModel;

                      List<Permit>? permits = result.permit;
                      LateBreak? lateBreak = result.lateBreak;

                      if (permits != null) {
                        permits.sort(
                          (a, b) => a.createdAt!.compareTo(b.createdAt!),
                        );
                      }

                      return ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          if (lateBreak != null) ...[
                            Text(
                              'Istirahat terlambat',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(10),
                            CustomTileStatus(
                              status: 'Approved',
                              showStatus: false,
                              mainTitle: "Alasan",
                              mainSubtitle: lateBreak.catatan ?? "-",
                              secTitle: "Tanggal kembali pada",
                              secSubtitle: DateFormat(
                                'dd MMMM yyyy',
                                'id_ID',
                              ).format(lateBreak.createdAt ?? DateTime.now()),
                              thirdTitle: "Waktu kembali pada",
                              thirdSubtitle: DateFormat(
                                'HH:mm',
                                'id_ID',
                              ).format(lateBreak.createdAt ?? DateTime.now()),
                            ),
                          ],
                          if (permits!.isNotEmpty) ...[
                            Text(
                              'Istirahat keluar',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(10),
                            ...List.generate(
                              permits.length,
                              (index) => CustomTileStatus(
                                status: (permits[index].type == 'out')
                                    ? 'Rejected'
                                    : 'Approved',
                                showStatus: false,
                                mainTitle:
                                    "Waktu istirahat ${permits[index].type == 'out' ? 'Keluar' : 'Masuk'}",
                                mainSubtitle:
                                    '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(permits[index].createdAt!)}',
                                secTitle: "Alasan istirahat ${permits[index].type == 'out' ? 'keluar' : 'masuk'}",
                                secSubtitle: permits[index].catatan ?? '-',
                                thirdTitle: "Istirahat untuk",
                                thirdSubtitle:
                                    '${permits[index].type == 'out' ? "Keluar" : "Masuk"}',
                              ),
                            ),
                          ],
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Center(
                        child: Text(
                          'Tidak ada pengajuan yang tersedia',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'Something error 404',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future fetchLogSubmission({
    String? listIdPermitOut,
    String? idLateBreak,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/log/submission'),
    );

    request.headers.addAll({'Authorization': 'Bearer ${m.token.value}'});

    request.fields.addAll({
      'list_id_permit_out': listIdPermitOut ?? '',
      'id_late_break_in': idLateBreak ?? '',
    });

    try {
      http.StreamedResponse response = await request.send();

      log('status code absen riwayat ${response.statusCode}');

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final result = LogSubmissionResponseModel.fromJson(str);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Container CustomLemburTile(BuildContext context, Overtime e) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 6, 0),
        onTap: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            showDragHandle: true,
            enableDrag: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.lat != null && e.lang != null)
                    SizedBox(
                      height: 200,
                      width: Get.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.amber),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    double.parse(e.lat ?? ""),
                                    double.parse(e.lang ?? ""),
                                  ),
                                  initialZoom: 17,
                                  maxZoom: 18,
                                  minZoom: 17,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: ['a', 'b', 'c'],
                                    maxZoom: 19,
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        width: 45.0,
                                        height: 45.0,
                                        point: LatLng(
                                          double.parse(e.lat!),
                                          double.parse(e.lang!),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 2,
                                              color: whiteColor,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            child: ImageNetwork(
                                              boxFit: BoxFit.cover,
                                              borderRadius: 0,
                                              url: '${m.u.value.avatar}',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: e.urlImage!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  TileInformation(
                    title: 'Waktu ${e.type} lembur',
                    subTitle: DateFormat(
                      'HH:mm:ss (dd MMMM yyyy)',
                      'id_ID',
                    ).format(e.createdAt!),
                  ),
                  TileInformation(
                    title: 'Koordinat',
                    subTitle: '${e.lat}, ${e.lang}',
                  ),
                  TileInformation(
                    title: 'Alamat',
                    subTitle: e.address ?? "Pengajuan ini dari superadmin",
                  ),
                  TileInformation(
                    title: 'Catatan',
                    subTitle: e.catatan ?? "Pengajuan ini dari superadmin",
                  ),
                ],
              );
            },
          );
        },
        trailing: Icon(Icons.keyboard_arrow_right_outlined),
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '${DateFormat('HH:mm').format(e.createdAt!)}',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${e.type == 'clockin' ? 'Clock-In' : 'Clock-Out'} Lembur',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _detailTile({
    required Attendance attendance,
    required DetailSchedule schedule,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (attendance.lat!.isNotEmpty)
              SizedBox(
                height: 180,
                width: Get.width,
                child: Row(
                  children: [
                    if (attendance.lat!.isNotEmpty)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.amber),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                double.parse(attendance.lat ?? ""),
                                double.parse(attendance.lang ?? ""),
                              ),
                              initialZoom: 17,
                              maxZoom: 18,
                              minZoom: 17,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                                maxZoom: 19,
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 45.0,
                                    height: 45.0,
                                    point: LatLng(
                                      double.parse(attendance.lat!),
                                      double.parse(attendance.lang!),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: whiteColor,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: ImageNetwork(
                                          boxFit: BoxFit.cover,
                                          borderRadius: 0,
                                          url: '${m.u.value.avatar}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (attendance.urlImage!.isNotEmpty) ...[
                      Expanded(
                        child: Image.network(
                          attendance.urlImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            // TileInformation(
            //   title: "image link",
            //   subTitle: attendance.urlImage ?? "-",
            // ),
            TileInformation(
              title:
                  'Waktu ${attendance.type == 'clockin' ? 'Clock-In' : 'Clock-Out'}',
              subTitle: DateFormat(
                'HH:mm:ss (dd MMM yyy)',
                'id_ID',
              ).format(attendance.createdAt!),
            ),
            TileInformation(
              title: 'Shift',
              subTitle: (schedule.pattern!.scheduleIn == null)
                  ? '${schedule.pattern!.shiftName}'
                  : "${schedule.pattern!.shiftName!} (${TimeFormatSchedule().timeOfDayFormat(schedule.pattern!.scheduleIn)} - ${TimeFormatSchedule().timeOfDayFormat(schedule.pattern!.scheduleOut)})",
            ),
            TileInformation(
              title: 'Jadwal shift',
              subTitle: DateFormat(
                'EEE, dd MMM yyyy',
                'id_ID',
              ).format(schedule.date ?? DateTime.now()),
            ),
            TileInformation(
              title: 'Alamat',
              subTitle: attendance.address!.isEmpty ? '-' : attendance.address!,
            ),
            TileInformation(
              title: 'Kordinat absensi',
              subTitle:
                  '${attendance.lat ?? "0.0000"} - ${attendance.lang ?? "0.0000"}',
            ),
            TileInformation(
              title: 'Catatan',
              subTitle: attendance.catatan!.isEmpty ? '-' : attendance.catatan!,
            ),
          ],
        );
      },
    );
  }

  List<DateTime> generateCalendar(int pYear, int pMonth) {
    int sDay = 26; // start date
    int eDay = 26; // end date

    int sMonth = pMonth; // pMonth = input
    int eMonth = (sMonth == 12) ? 1 : sMonth + 1;

    int sYear = pYear;
    int eYear = (sMonth == 12) ? sYear + 1 : sYear;

    DateTime sDate = DateTime(pYear, sMonth, sDay);
    DateTime eDate = DateTime(eYear, eMonth, eDay);

    print(sDate);
    print(eDate);

    // ambil tanggal di atara sDate & eDate
    int lenghtDay = eDate.difference(sDate).inDays;

    List<DateTime> listDay = List.generate(
      lenghtDay,
      (index) => sDate.add(Duration(days: index)),
    );

    return listDay;
  }

  // === end logic
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black.withValues(alpha: .3), // <<--- Lebih transparan
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            const Gap(10),
            DefaultTextStyle(
              style: GoogleFonts.outfit(
                fontSize: 12.0,
                color: Colors.white, // Pastikan teks tetap terlihat
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'Loading...',
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                isRepeatingAnimation: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkletonizerWidgetRiwayat extends StatelessWidget {
  const SkletonizerWidgetRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Skeleton.leaf(
              child: Card(
                elevation: 0,
                child: SizedBox(width: Get.width, height: 50),
              ),
            ),
          ),
          const Gap(10),
          Skeleton.leaf(
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(width: Get.width, height: 140),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  child: ListTile(
                    shape: UnderlineInputBorder(
                      borderSide: BorderSide(width: 0.6, color: greyColor),
                    ),
                    title: Text('The title goes here'),
                    subtitle: Text('Subtitle here'),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Juni 20',
                          style: TextStyle().copyWith(fontSize: 16),
                        ),
                        Text(
                          'Masuk Kerja',
                          style: TextStyle().copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Skeleton.shade(
                      // the icon will be shaded by shader mask
                      child: Icon(Iconsax.arrow_right_3_copy, size: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListTileInfo extends StatelessWidget {
  const ListTileInfo({super.key, required this.title, required this.value});

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: medium, fontSize: 12)),
        const Gap(10),
        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.amber[700],
            fontWeight: semiBold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
