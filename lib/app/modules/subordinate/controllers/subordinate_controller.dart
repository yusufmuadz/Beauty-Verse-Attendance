import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/modules/subordinate/models/detail_attendance.dart';
import 'package:lancar_cat/app/modules/subordinate/models/subordinate.dart';
import 'package:lancar_cat/app/shared/tile/tile3.dart';

import '../../../core/constant/time_format_schedule.dart';
import '../../../shared/images/images.dart';
import '../../services/team_members/views/team_subordinate_view.dart';

class SubordinateController extends GetxController {
  RxBool isLoading = false.obs;
  final m = Get.find<ModelController>();
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> firstDay = DateTime.now().add(const Duration(days: -60)).obs;
  Rx<DateTime> lastDay = DateTime.now().obs;
  RxBool isShowDate = true.obs;

  RxList<Subordinate> subordinate = <Subordinate>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await selectDay(selectedDay.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> selectDay(DateTime pickDate) async {
    isLoading(true);

    selectedDay.value = pickDate;
    await fetchAllSubordinate(date: pickDate);
  }

  Future<void> showAttendance(
    BuildContext context,
    Subordinate subordinate,
  ) async {
    if (subordinate.attendance!.isEmpty && subordinate.subordinate == 0) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Detail Presensi",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const Gap(15),
              ...List.generate(subordinate.attendance!.length, (index) {
                Attendance att = subordinate.attendance![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      Variables().loading(message: "Loading...");
                      onDetailPressed(id: att.id.toString(), context: context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    tileColor: Colors.grey.shade50,
                    title: Text(
                      att.type!.split('k').join('k ').capitalizeFirst!,
                    ),
                    subtitle: Text(
                      "${att.shiftName} - ${DateFormat("HH:mm").format(att.presentAt!)}",
                    ),
                    titleTextStyle: GoogleFonts.figtree(color: Colors.black),
                    subtitleTextStyle: GoogleFonts.figtree(
                      color: Colors.black54,
                    ),
                  ),
                );
              }),
              if (subordinate.subordinate! > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.to(
                        () => TeamSubordinateView(),
                        arguments: {
                          "id_karyawan": subordinate.id,
                          "selected_date": DateFormat(
                            "yyyy-MM-dd",
                          ).format(selectedDay.value),
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    tileColor: Colors.grey.shade50,
                    title: Text("Subordinate"),
                    subtitle: Text(
                      "${subordinate.subordinate} Orang Subordinate",
                    ),
                    titleTextStyle: GoogleFonts.figtree(color: Colors.black),
                    subtitleTextStyle: GoogleFonts.figtree(
                      color: Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onDetailPressed({
    required String id,
    required BuildContext context,
  }) async {
    final tm = TimeFormatSchedule();
    ResponseDetailAttendance? resp = await fetchDetailAttendance(id: id);
    Get.back(); // close loading
    if (resp!.data == null) {
      Get.defaultDialog(
        titleStyle: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        middleTextStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        title: "Error",
        middleText: resp.msg.toString(),
        onConfirm: () {
          Get.back();
        },
      );
      return;
    }
    Get.back(); // close bottomsheet

    Data data = resp.data!;
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              width: Get.width,
              child: Row(
                children: [
                  if (data.latitude!.isNotEmpty)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.amber),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              double.parse(data.latitude ?? ""),
                              double.parse(data.longitude ?? ""),
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
                                    double.parse(data.latitude!),
                                    double.parse(data.longitude!),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: ImageNetwork(
                                        boxFit: BoxFit.cover,
                                        borderRadius: 0,
                                        url: data.urlImage ?? "",
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
                  if (data.urlImage!.isNotEmpty) ...[
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: data.urlImage ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            TileInformation(
              title: 'Waktu Presensi',
              subTitle: DateFormat(
                "dd MMM yyyy HH:mm",
                "id_ID",
              ).format(data.createdAt!),
            ),
            TileInformation(title: "Shift", subTitle: data.shiftName ?? "-"),
            TileInformation(
              title: "Jadwal Shift",
              subTitle:
                  "${tm.timeOfDayFormat(data.scheduleIn!)} - ${tm.timeOfDayFormat(data.scheduleOut!)}",
            ),
            TileInformation(title: "Alamat", subTitle: data.address ?? '-'),
            TileInformation(
              title: "Koordinat",
              subTitle: "${data.latitude}, ${data.longitude}",
            ),
          ],
        );
      },
    );
  }

  Future<ResponseDetailAttendance?> fetchDetailAttendance({
    required String id,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/team/attendance'),
      );
      request.body = json.encode({"attendance_id": id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = ResponseDetailAttendance.fromJson(str);
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(response.reasonPhrase);
        }
        final str = await response.stream.bytesToString();
        final decode = jsonDecode(str);
        return ResponseDetailAttendance(msg: decode['msg'], data: null);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchAllSubordinate({DateTime? date}) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/team/member'),
      );
      request.body = json.encode({"date": date.toString()});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = ResponseSubordinate.fromJson(str);
        subordinate.value = data.data!;
        subordinate.sort(
          (a, b) => b.attendance!.length.compareTo(a.attendance!.length),
        );
      } else {
        if (kDebugMode) {
          debugPrint(response.reasonPhrase);
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}
