import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/data/model/identify_job_scope_response_model.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/models/attendance.dart';
import 'package:lancar_cat/app/shared/tile/tile3.dart';

class TeamSubordinateView extends StatefulWidget {
  const TeamSubordinateView({super.key});

  @override
  State<TeamSubordinateView> createState() => _SubordinateViewState();
}

class _SubordinateViewState extends State<TeamSubordinateView> {
  late String idKaryawan;
  late String date;
  late Future futureData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    try {
      final args = Get.arguments;
      if (args == null ||
          args['id_karyawan'] == null ||
          args['selected_date'] == null) {
        throw Exception("Invalid arguments passed to TeamSubordinateView");
      }
      idKaryawan = args['id_karyawan'];
      date = args['selected_date'];
      futureData = Get.find<ApiController>().identifyJobScope(
        date: date,
        subordinate: idKaryawan,
      );
    } catch (e) {
      log("Error fetching data: $e");
      // Handle error gracefully, e.g., show a dialog or fallback UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team Subordinate')),
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.hasData) {
            IdentifyJobScopeResponseModel model =
                snapshot.data as IdentifyJobScopeResponseModel;
            if (model.data == null || model.data!.isEmpty) {
              return const CustomEmptySubmission(title: 'No Employee Found');
            }
            return _buildEmployeeList(model.data!);
          } else {
            return const CustomEmptySubmission(title: 'No Data Available');
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        width: Get.width * 0.5,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black87.withAlpha(200),
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
              style: GoogleFonts.varelaRound(fontSize: 16.0),
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

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          const Gap(10),
          Text(
            "Error: $errorMessage",
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(List<User> employees) {
    employees.sort(
      (a, b) => (a.attendance != null ? 0 : 1).compareTo(
        b.attendance != null ? 0 : 1,
      ),
    );
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final user = employees[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            dense: true,
            enabled: user.attendance != null || user.subordinate! > 0,
            shape: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: user.avatar?.contains('default') == true
                    ? Image.asset('assets/logo/logo.png')
                    : CachedNetworkImage(imageUrl: user.avatar ?? ''),
              ),
            ),
            title: Text(
              user.nama ?? "-",
              style: GoogleFonts.figtree(color: Colors.black, fontSize: 15.5),
            ),
            subtitle: Text(
              user.jabatan ?? "-",
              style: GoogleFonts.figtree(color: Colors.grey, fontSize: 12),
            ),
            trailing: user.attendance == null ? const SizedBox() : null,
            children: [
              ...(user.attendance?.details ?? []).map(
                (e) => ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
                  onTap: () => _onTap(context, e),
                  trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  title: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          DateFormat('HH:mm').format(e.createdAt!),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          e.type == 'clockin' ? 'Clock-In' : 'Clock-Out',
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (user.subordinate! > 0)
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => TeamSubordinateView(),
                      arguments: {
                        'id_karyawan': user.id,
                        'selected_date': DateFormat(
                          'yyyy-MM-dd',
                          'id_ID',
                        ).format(DateTime.parse(date)),
                      },
                    )?.then((value) {
                      if (value == true) {
                        setState(() {}); // Refresh halaman setelah kembali
                      }
                    });
                  },
                  trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Iconsax.people_copy, color: Colors.amber.shade800),
                      const Spacer(),
                      Text(
                        'Show ${user.subordinate} subordinates data',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onTap(BuildContext context, Attendance e) async {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width,
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          double.parse(e.lat!),
                          double.parse(e.lang!),
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
                                    color: Colors.white,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: e.urlImage ?? '',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (e.urlImage != null)
                    Expanded(child: CachedNetworkImage(imageUrl: e.urlImage!)),
                ],
              ),
            ),
            TileInformation(
              title: 'Type',
              subTitle: e.type == 'clockin' ? 'Clock-In' : 'Clock-Out',
            ),
            TileInformation(
              title: 'Jam Presensi',
              subTitle: DateFormat(
                'HH:mm',
              ).format(e.createdAt ?? DateTime.now()),
            ),
            TileInformation(
              title: 'Kordinat Lokasi Presensi',
              subTitle: e.coordinate ?? '',
            ),
            TileInformation(
              title: 'Alasan Lokasi Presensi',
              subTitle: e.address ?? '',
            ),
          ],
        );
      },
    );
  }
}
