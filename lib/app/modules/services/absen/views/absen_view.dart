import 'package:hexcolor/hexcolor.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/daftar_absen_view.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/components/detail_absensi_bottom_sheet.dart';
import 'package:lancar_cat/app/modules/locations_tracker/views/locations_tracker_view.dart';
import 'package:lancar_cat/app/modules/services/absen/views/absen_locations.dart';

import '../../../home/controllers/home_controller.dart';

class AbsenView extends StatefulWidget {
  const AbsenView({super.key});

  @override
  State<AbsenView> createState() => _AbsenViewState();
}

class _AbsenViewState extends State<AbsenView> {
  final a = Get.put(ApiController());
  final h = Get.put(HomeController());
  final m = Get.find<ModelController>();

  RxInt jumlahLokasi = 0.obs;

  @override
  void initState() {
    super.initState();
    a.locations();
  }

  _infoLocations() {
    // ignore: unnecessary_null_comparison
    if (m.locations.value.locations!.isEmpty) {
      return "Lokasi presensi belum diset";
    } else if (m.locations.value.setting!.flexible == '1') {
      return 'Lokasi absen flexible';
    } else {
      return 'Lihat ${m.locations.value.locations!.length} lokasi kehadiran';
    }
  }

  _onTapLocations() async {
    if (m.locations.value.setting!.flexible == '1') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Lokasi Absen Flexible',
            textAlign: TextAlign.center,
            style: GoogleFonts.varelaRound(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Lokasi presensi anda flexible, anda dapat melakukan presensi dimana saja.',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(fontSize: 13),
          ),
        ),
      );
    } else {
      Get.to(AbsenLocationsView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Detail Presensi",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const Gap(8),
          // Waktu utama
          Text(
            DateFormat('HH:mm', 'id_ID').format(DateTime.now()),
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.black87,
            ),
          ),

          const Gap(8),

          // Kartu informasi jadwal
          SizedBox(
            width: Get.width,
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Jadwal: ${DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now())}",
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      m.todayShift.value.id == null
                          ? "Shift belum tersedia"
                          : findShiftName(m.todayShift.value),
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(10),

                    // Lokasi absen
                    FutureBuilder(
                      future: a.locations(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(height: 16);
                        }
                        if (snapshot.hasData) {
                          return TextButton(
                            onPressed: _onTapLocations,
                            child: Text(
                              _infoLocations(),
                              style: GoogleFonts.urbanist(
                                color: HexColor('#f98c53'),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Gap(12),

          // Tombol Clock-in / Clock-out
          Obx(() {
            if (m.todayShift.value.dayoff == null &&
                m.todayShift.value.dayoff == '0' &&
                m.timeOffMaster.value.id == null) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#f98c53"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () =>
                      Get.to(() => LocationsTrackerView(), arguments: '0'),
                  child: Text(
                    m.ci.value.type == null ? "Clock-In" : "Clock-Out",
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
          const Gap(12),

          // Log Presensi
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Log Presensi",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => DaftarAbsenView()),
                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),
                  const Gap(8),
                  if (m.ci.value.type == null && m.co.value.type == null)
                    CustomEmptySubmission(title: "Belum ada presensi", subtitle: 'Belum ada presensi di hari ini, silakan lakukan presensi anda terlebih dahulu',),
                  if (m.ci.value.type != null)
                    cTilePresensi(
                      context: context,
                      title: "Clock-In",
                      date: m.ci.value.createdAt!,
                      onTap: () => detailInformationAbsen(
                        attendance: m.ci.value,
                        shift: m.todayShift.value,
                        context: context,
                      ),
                    ),
                  if (m.co.value.type != null) ...[
                    const Gap(8),
                    cTilePresensi(
                      context: context,
                      title: "Clock-Out",
                      date: m.co.value.createdAt!,
                      onTap: () => detailInformationAbsen(
                        attendance: m.co.value,
                        shift: m.todayShift.value,
                        context: context,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Material cTilePresensi({
    required BuildContext context,
    required DateTime date,
    required String title,
    required Function()? onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('dd MMM', "id_ID").format(date),
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              DateFormat('HH:mm', 'id_ID').format(date),
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Iconsax.arrow_right_3_copy,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }
}
