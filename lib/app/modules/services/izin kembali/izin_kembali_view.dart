import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/components/custom_dialog.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/core/constant/time_format_schedule.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/permit_response_model.dart';
import 'package:lancar_cat/app/modules/locations_tracker/views/locations_tracker_view.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/textfield/textfield_1.dart';
import 'package:lancar_cat/app/shared/textfieldform.dart';
import 'package:lancar_cat/app/shared/tile/tile3.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../shared/images/images.dart';

class IzinKembaliView extends StatefulWidget {
  IzinKembaliView({super.key});

  @override
  State<IzinKembaliView> createState() => _IzinKembaliViewState();
}

class _IzinKembaliViewState extends State<IzinKembaliView> {
  final m = Get.find<ModelController>();

  final reason = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchC.text = DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Istirahat'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchTodayPermit(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          } else if (snapshot.hasData) {
            PermitResponseModel data = snapshot.data as PermitResponseModel;

            //   return Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(10),
            //         child: TextField1(
            //           controller: searchC,
            //           suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
            //           preffixIcon: Icon(Iconsax.calendar_1_copy),
            //           hintText: 'Pilih Tanggal',
            //           readOnly: true,
            //           onTap: () async {
            //             final result = await showDatePicker(
            //               context: context,
            //               firstDate: DateTime(2024),
            //               lastDate: DateTime(2025),
            //               initialDate: selectedDate,
            //               locale: Locale('id', 'ID'),
            //             );

            //             if (result != null) {
            //               selectedDate = result;
            //               searchC.text = DateFormat('dd MMMM yyyy', 'id_ID')
            //                   .format(result);
            //               setState(() {});
            //             }
            //           },
            //         ),
            //       ),
            //       Expanded(
            //         child: Center(
            //           child: CustomEmptySubmission(),
            //         ),
            //       ),
            //     ],
            //   );
            // }

            data.logs!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField1(
                    controller: searchC,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                    preffixIcon: Icon(Iconsax.calendar_1_copy),
                    hintText: 'Pilih Tanggal',
                    readOnly: true,
                    onTap: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        initialDate: selectedDate,
                        locale: Locale('id', 'ID'),
                      );

                      if (result != null) {
                        selectedDate = result;
                        searchC.text = DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(result);
                        setState(() {});
                      }
                    },
                  ),
                ),
                data.logs == null || data.logs!.isEmpty ?
                Expanded(
                  child: Center(
                    child: CustomEmptySubmission(title: 'Istirahat Kosong', subtitle: 'Belum ada pengajuan istirahat, silahkan ajukan istirahat anda',),
                  ),
                )
                :
                Expanded(
                  child: ListView.builder(
                    itemCount: data.logs?.length ?? 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      Permit perm = data.logs![index];

                      return CustomTileStatus(
                        onTap: () {
                          showModalBottomSheet(
                            enableDrag: true,
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: Get.width,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                            ),
                                            child: FlutterMap(
                                              options: MapOptions(
                                                interactionOptions:
                                                    InteractionOptions(
                                                      flags:
                                                          ~InteractiveFlag.all,
                                                    ),
                                                initialCenter: LatLng(
                                                  double.parse(perm.lat ?? ""),
                                                  double.parse(perm.lang ?? ""),
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
                                                        double.parse(perm.lat!),
                                                        double.parse(
                                                          perm.lang!,
                                                        ),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                width: 2,
                                                                color:
                                                                    whiteColor,
                                                              ),
                                                            ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100,
                                                              ),
                                                          child: ImageNetwork(
                                                            boxFit:
                                                                BoxFit.cover,
                                                            borderRadius: 0,
                                                            url:
                                                                '${m.u.value.avatar}',
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
                                      ],
                                    ),
                                  ),
                                  TileInformation(
                                    title: 'Tanggal istirahat ${perm.type == 'out' ? 'keluar' : 'masuk'}',
                                    subTitle:
                                        '${DateFormat('dd MMMM yyyy', 'id_ID').format(perm.createdAt ?? DateTime.now())}',
                                  ),
                                  TileInformation(
                                    title: 'Waktu istirahat ${perm.type == 'out' ? 'keluar' : 'masuk'}',
                                    subTitle:
                                        '${DateFormat('HH:mm', 'id_ID').format(perm.createdAt ?? DateTime.now())}',
                                  ),
                                  TileInformation(
                                    title: 'Alasan istirahat ${perm.type == 'out' ? 'keluar' : 'masuk'}',
                                    subTitle: '${perm.catatan ?? '-'}',
                                  ),
                                  TileInformation(
                                    title: 'Latitude & Longitude',
                                    subTitle: '${perm.coordinate ?? '-'}',
                                  ),
                                  TileInformation(
                                    title: 'Alamat',
                                    subTitle: '${perm.address ?? '-'}',
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        status: (perm.type == 'out') ? 'Approved' : 'Rejected',
                        showStatus: false,
                        mainTitle:
                            "Waktu Istirahat ${perm.type == 'out' ? 'Keluar' : 'Masuk'}",
                        mainSubtitle: '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(perm.createdAt!)}',
                        secTitle: "Alasan istirahat ${perm.type == 'out' ? 'keluar' : 'masuk'}",
                        secSubtitle: perm.catatan ?? '-',
                        thirdTitle: "Istirahat untuk",
                        thirdSubtitle:
                            '${perm.type == 'out' ? "Keluar" : "Masuk"}',
                      );
                    },
                  ),
                ),
                if (TimeFormatSchedule.checkIsSameDay(
                  selectedDate,
                  DateTime.now(),
                ))
                  Material(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: _keyForm,
                            child: TextfieldForm(
                              controller: reason,
                              hintText: 'contoh: Lapar',
                              labelText: 'Alasan',
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(Iconsax.note_1_copy),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Alasan wajib di isi';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const Gap(10),
                          if (TimeFormatSchedule.checkIsSameDay(
                            selectedDate,
                            DateTime.now(),
                          ))
                            Button1(
                              title: (data.logs!.length % 2 == 0)
                                  ? 'Istirahat Keluar'
                                  : 'Istirahat Masuk',
                              showOutline: false,
                              onTap: _onTapSubmitPermitOut,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
          return const Center(child: CustomEmptySubmission());
        },
      ),
    );
  }

  _onTapSubmitPermitOut() async {
    // if (_keyForm.currentState!.validate()) {
      if (m.ci.value.createdAt == null) {
        Get.dialog(
          AlertDialog(
            titlePadding: const EdgeInsets.only(left: 20, top: 20),
            contentPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: 10,
            ),
            title: Text(
              'Informasi',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Anda harus melakukan clock-in terlebih dahulu.',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
        return;
      }

      DateTime timeIn = TimeFormatSchedule().timeFormatDateTime(
        m.todayShift.value.scheduleIn,
      );
      DateTime timeOut = TimeFormatSchedule().timeFormatDateTime(
        m.todayShift.value.scheduleOut,
      );

      var scheduleIn = TimeOfDay(hour: timeIn.hour, minute: timeIn.minute);
      var scheduleOut = TimeOfDay(hour: timeOut.hour, minute: timeOut.hour);

      if (!checkCrossingMidnight(scheduleIn, scheduleOut)) {
        /**
       * hanya berlaku jika jam kerja tidak melewati tengah malam
       */
        if (!checkTime(m.todayShift.value.scheduleOut)) {
          Get.dialog(
            CustomDialog(
              title: 'Informasi',
              content: 'Anda sudah melewati waktu kerja',
            ),
          );
          return;
        }
      }

      await Get.to(
        () => LocationsTrackerView(note: reason.text),
        arguments: '1',
      );
      reason.text = '';
      setState(() {});
    // }
  }

  bool checkCrossingMidnight(TimeOfDay scheduleIn, TimeOfDay scheduleOut) {
    // Convert to minutes for easier comparison
    int scheduleInMinutes = scheduleIn.hour * 60 + scheduleIn.minute;
    int scheduleOutMinutes = scheduleOut.hour * 60 + scheduleOut.minute;

    // If scheduleOut is smaller than scheduleIn, it means it crossed midnight
    return scheduleOutMinutes < scheduleInMinutes;
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

  Future fetchTodayPermit(DateTime date) async {
    final m = Get.find<ModelController>();
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '${Variables.baseUrl}/v1/user/permit?date=${date.toIso8601String()}',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = PermitResponseModel.fromJson(result);

      return data;
    } else {
      print(response.reasonPhrase);
    }
  }
}
