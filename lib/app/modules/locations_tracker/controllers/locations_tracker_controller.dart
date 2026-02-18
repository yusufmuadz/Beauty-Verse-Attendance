import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lancar_cat/app/core/constant/geolocator_locations.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/shared/snackbar/snackbar_1.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/geolocator_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/modules/camera_capture/views/camera_capture_view.dart';
import 'package:lancar_cat/app/modules/services/absen/views/absen_view.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class LocationsTrackerController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isStreamEnable = false.obs;
  RxString textB = "Cek lokasi".obs;

  RxDouble turns = 0.0.obs;

  Position? position;

  final a = Get.put(ApiController());
  final g = Get.put(GeolocatorController());
  final m = Get.find<ModelController>();

  final locationStreamController = StreamController<Position>.broadcast();
  Stream<Position> get locationStream => locationStreamController.stream;

  @override
  void onInit() async {
    super.onInit();
    g.askingPermission().then((value) {
      isStreamEnable(true);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    isLoading(false);
    isStreamEnable(false);
    locationStreamController.close();
    super.onClose();
  }

  // buatkan untuk mengembalikan value stream
  Stream<Position> streamPositionV2() async* {
    await for (Position position in Geolocator.getPositionStream()) {
      if (isStreamEnable.value) {
        yield position;
      }
    }
  }

  // =========================== V2 =======================
  Future checkCurrentLocationV2(
    String? id,
    String note,
    String lat,
    String lang,
  ) async {
    Uri url = Uri.parse('${Variables.baseUrl}/v2/user/check/locations');
    Map<String, dynamic> body = {"lat": lat, "lang": lang};
    Map<String, String> headers = {
      "Authorization": "Bearer ${m.token.value}",
      "Accept-Encoding": "gzip, deflate",
    };

    try {
      final request = await http
          .post(url, body: body, headers: headers)
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () async {
              textB.value = 'Cek lokasi';
              isLoading(true);
              Get.defaultDialog(
                title: 'Gagal..!',
                content: Text(
                  'Hubungi personalia untuk memastikan lokasi anda aktif.',
                ),
              );

              // Return a dummy or error response
              throw TimeoutException(
                'The connection has timed out. Please try again.',
              );
            },
          );

      if (request.statusCode == 200) {
        var data = json.decode(request.body)["data"];

        if (data) {
          // if value is true
          textB.value = 'Cek lokasi';
          isLoading(true);
          if (Get.arguments == '1') {
            Variables().loading(message: 'mengirim...');
            onPressSubmitPermit(
              note: note.isEmpty ? '-' : note,
              position: null,
            );
            return;
          } else {
            isLoading(true);
            textB('Cek lokasi');
            Get.to(() => CameraCaptureView(), arguments: id);
          }
        } else {
          // if value is false
          textB.value = 'Cek lokasi';
          isLoading(true);
          _alertOutOfRange();
        }
      } else {
        Get.defaultDialog(
          title: 'Gagal..!',
          content: Text(
            'Hubungi personalia untuk memastikan lokasi anda aktif.',
          ),
        );
        textB.value = 'Cek lokasi';
        isLoading(true);
      }
    } on HttpException catch (e) {
      textB.value = 'Cek lokasi';
      isLoading(true);
      Get.dialog(AlertDialog(title: Text('Failed'), content: Text(e.message)));
    } catch (e) {
      textB.value = 'Cek lokasi';
      isLoading(true);
      _alertInternetNoConnection();
      Get.dialog(
        AlertDialog(title: Text('Failed'), content: Text(e.toString())),
      );
    }
  }

  Future onPressSubmitPermit({required String note, Position? position}) async {
    bool result = await submitPermit(note);

    if (result) {
      Get.back();
      Snackbar().snackbar1(
        'Berhasil',
        'Berhasil Istirahat',
        null,
        Colors.white,
        Colors.amber,
      );
    }
  }

  Future submitPermit(String note) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/permit'),
    );

    Map<String, dynamic> loc = await GeoLocation().currentLocation();

    // pencegahan agar lat dan lng tidak kosong
    if (loc['lat'] == 0.0 || loc['lng'] == 0.0) {
      loc = await GeoLocation().currentLocation();
    }

    request.fields.addAll({
      'attendance_id': '${m.ci.value.userAttendanceId}',
      'lat': loc['lat'].toString(),
      'lang': loc['lng'].toString(),
      'address': loc['address'].toString(),
      'catatan': note,
      'time': DateTime.now().toLocal().toIso8601String(),
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      debugPrint('URL: ${request.url}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: $data');

      if (response.statusCode == 201) {
        return true;
      } else {
        final response = json.decode(data);
        Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: Text(
              "Gagal mengirim presensi",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              response['message'],
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

_alertInternetNoConnection() {
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
                  style: TextStyle(fontWeight: semiBold, fontSize: 18),
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

_alertOutOfRange() {
  Get.bottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    backgroundColor: whiteColor,
    Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Anda berada diluar jangkauan!",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: Get.width * 0.3,
                height: Get.width * 0.3,
                child: Image.asset('assets/icons/ic_map.png'),
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Center(
              child: Text(
                'Anda berada di luar jangkauan lokasi untuk melakukan presensi, silakan klik tombol di bawah ini, untuk mengetahui lokasi presensi Anda.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),
          ),
          if (Get.arguments != '1' &&
              Get.arguments != '2' &&
              Get.arguments != '5')
            Button1(
              backgroundColor: Colors.amber,
              title: 'Tetap Presensi',
              onTap: () {
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: Text(
                      'Peringatan!',
                      style: TextStyle(color: Colors.red),
                    ),
                    content: Text(
                      'Presensi Anda akan masuk kedalam tahap pengajuan',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Kembali'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Get.back();
                          Get.to(() => CameraCaptureView(), arguments: '3');
                        },
                        child: Text('Lanjutkan'),
                      ),
                    ],
                  ),
                );
              },
            ),
          const Gap(10),
          Button1(
            title: 'Cek Lokasi',
            onTap: () {
              Get.to(AbsenView());
            },
          ),
          const Gap(10),
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
