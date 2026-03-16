import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../controllers/model_controller.dart';
import '../../../../core/components/custom_dialog.dart';
import '../../../../core/components/custom_empty_submission.dart';
import '../../../../core/components/custom_tile_status.dart';
import '../../../../core/constant/time_format_schedule.dart';
import '../../../../core/constant/variables.dart';
import '../../../../data/model/late_break_response_model.dart';
import '../../../../shared/button/button_1.dart';
import '../../../../shared/images/images.dart';
import '../../../../shared/maps/tile_layer_maps.dart';
import '../../../../shared/snackbar/snackbar_1.dart';
import '../../../../shared/textfield/textfield_1.dart';
import '../../../../shared/tile/tile3.dart';
import '../../../../shared/utils.dart';
import '../../../locations_tracker/views/locations_tracker_view.dart';
import '../controllers/istirahat_telat_controller.dart';

class IstirahatTelatView extends StatefulWidget {
  const IstirahatTelatView({super.key});

  @override
  State<IstirahatTelatView> createState() => _IstirahatTelatViewState();
}

class _IstirahatTelatViewState extends State<IstirahatTelatView> {
  final controller = Get.put(IstirahatTelatController());
  final m = Get.find<ModelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Istirahat Telat'),
        centerTitle: true,
        elevation: 1.5,
      ),
      body: Column(
        children: [
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField1(
              controller: controller.searchC,
              suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
              preffixIcon: Icon(Iconsax.calendar_1_copy),
              hintText: 'Pilih Bulan',
              readOnly: true,
              onTap: () async {
                showMonthPicker(
                  context,
                  highlightColor: Colors.amber.shade600,
                  textColor: Colors.white,
                  contentBackgroundColor: Colors.white,
                  dialogBackgroundColor: Colors.grey[200],
                  initialSelectedYear: controller.yearSelected.value,
                  initialSelectedMonth: controller.monthSelected.value,
                  onSelected: (p0, p1) {
                    controller.monthSelected.value = p0;
                    controller.yearSelected.value = p1;

                    controller.searchC.text = DateFormat('MMMM yyyy', 'id_ID')
                        .format(
                          DateTime(
                            controller.yearSelected.value,
                            controller.monthSelected.value,
                          ),
                        );
                  },
                );
              },
            ),
          ),
          Obx(
            () => FutureBuilder(
              future: fetchSubmissionByUserId(
                controller.monthSelected.value,
                controller.yearSelected.value,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Variables().loadingWidget(message: 'Loading...'),
                  );
                } else if (snapshot.hasData) {
                  final LateBreakResponseModel data = snapshot.data;

                  if (data.data!.isEmpty) {
                    return const Expanded(
                      child: CustomEmptySubmission(
                        title: 'Belum ada pengajuan pada bulan ini',
                        subtitle: 'Belum ada pengajuan Istirahat Telat pada bulan ini, silakan ajukan pengajuan Istirahat Telat anda',
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      itemCount: data.data!.isEmpty ? 0 : data.data!.length,
                      itemBuilder: (context, index) {
                        LateBreak lateBreak = data.data![index];

                        final now = DateTime.now();

                        if (TimeFormatSchedule.checkIsSameDay(
                          now,
                          lateBreak.createdAt!,
                        )) {
                          controller.isAlreadyExists(true);
                        }

                        return CustomTileStatus(
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              showDragHandle: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: Get.width,
                                    child: Row(
                                      children: [
                                        if (lateBreak.lat != null &&
                                            lateBreak.lang != null)
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                              ),
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  initialCenter: LatLng(
                                                    double.parse(
                                                      lateBreak.lat ?? "",
                                                    ),
                                                    double.parse(
                                                      lateBreak.lang ?? "",
                                                    ),
                                                  ),
                                                  initialZoom: 17,
                                                  maxZoom: 18,
                                                  minZoom: 17,
                                                ),
                                                children: [
                                                  TileLayerMaps().sharedTile(),
                                                  MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        point: LatLng(
                                                          double.parse(
                                                            lateBreak.lat!,
                                                          ),
                                                          double.parse(
                                                            lateBreak.lang!,
                                                          ),
                                                        ),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              width: 2,
                                                              color: whiteColor,
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
                                        if (lateBreak.urlImage != null)
                                          Expanded(
                                            child: Container(
                                              color: Colors.grey.shade100,
                                              child: CachedNetworkImage(
                                                imageUrl: lateBreak.urlImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1, color: blackColor),
                                  TileInformation(
                                    title: 'Tanggal & Waktu',
                                    subTitle: DateFormat(
                                      'dd MMM yyyy, HH:mm',
                                      'id_ID',
                                    ).format(lateBreak.createdAt!),
                                  ),
                                  TileInformation(
                                    title: 'Alasan',
                                    subTitle: lateBreak.catatan ?? '-',
                                  ),
                                  TileInformation(
                                    title: 'Alamat',
                                    subTitle: lateBreak.address ?? '-',
                                  ),
                                  TileInformation(
                                    title: 'Kordinat Lokasi',
                                    subTitle: '${lateBreak.coordinate}',
                                  ),
                                ],
                              ),
                            );
                          },
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
                        );
                      },
                    ),
                  );
                }
                return const Expanded(child: CustomEmptySubmission());
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -1),
                  color: Colors.grey.shade200,
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Button1(
              title: 'Pengajuan Istirahat Telat',
              onTap: () async {
                if (termsAndConditionsIstirahatTelat()) {
                  if (isButtonClicked) return;

                  await Get.to(() => LocationsTrackerView(), arguments: '2');

                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isButtonClicked = false;

  Future fetchSubmissionByUserId(int month, int year) async {
    var headers = {'Authorization': 'Bearer ${controller.m.token.value}'};

    var request = http.Request(
      'GET',
      Uri.parse(
        "${Variables.baseUrl}/v1/user/late/break?year=$year&month=$month",
      ),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        return LateBreakResponseModel.fromJson(str);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      CustomDialog(title: 'Gagal', content: e.toString());
    }
  }

  bool termsAndConditionsIstirahatTelat() {
    if (m.todayShift.value.breakStart == m.todayShift.value.breakEnd) {
      Snackbar().snackbar1(
        'Informasi',
        'Anda tidak bisa melakukan istirahat terlambat atas kebijakan personalia.',
        null,
        Colors.white,
        Colors.orange,
      );
      return false;
    }

    if (controller.isAlreadyExists.value) {
      Snackbar().snackbar1(
        'Informasi',
        'Anda sudah mengajukan istirahat terlambat',
        null,
        Colors.white,
        Colors.orange,
      );
      return false;
    }

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
}
