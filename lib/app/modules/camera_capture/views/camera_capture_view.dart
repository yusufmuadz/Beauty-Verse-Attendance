// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/components/custom_dialog.dart';
import '../../../core/constant/geolocator_locations.dart';
import '../../../shared/button/button_1.dart';
import '../../../shared/snackbar/snackbar_1.dart';
import '../../../shared/textfield/textfield_1.dart';
import '../../../shared/utils.dart';
import '../controllers/camera_capture_controller.dart';

class CameraCaptureView extends StatefulWidget {
  const CameraCaptureView({super.key});

  @override
  State<CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<CameraCaptureView> {
  final controller = Get.put(CameraCaptureController());
  final Box imageBox = Hive.box('andioffset');

  RxBool isTorchOn = false.obs;

  RxDouble currentExposureOffset = 0.7.obs;
  RxDouble minExposureOffset = 0.0.obs;
  RxDouble maxExposureOffset = 0.0.obs;

  Timer? _exposureDebounce;

  @override
  void dispose() {
    _exposureDebounce?.cancel();
    controller.isLoading(false);
    controller.camController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    CameraDescription? cameraDescription;

    cameraDescription = controller.cameras.firstWhere(
      (element) => element.lensDirection == CameraLensDirection.front,
      orElse: () => controller
          .cameras
          .first, // Fallback to the first camera instead of last
    );

    controller.camController = CameraController(
      cameraDescription,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
      fps: 30,
    );

    controller.camController
        .initialize()
        .then((_) async {
          await controller.camController.initialize();

          // Get the exposure offset range
          minExposureOffset(
            await controller.camController.getMinExposureOffset(),
          );
          maxExposureOffset(
            await controller.camController.getMaxExposureOffset(),
          );

          if (!mounted) {
            return;
          }
          controller.camController.setExposureOffset(0.7);
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CameraCaptureController());
    return WillPopScope(
      onWillPop: () async {
        controller.isLoading(false);
        controller.noteC.text = '';
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hadap Ke Kamera'),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: 1.0,
                    child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.aspectRatio,
                      child: OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: Get.width,
                            child: CameraPreview(controller.camController),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Column(
                      children: [
                        Container(
                          width: Get.width,
                          height: Get.height * 0.08,
                          color: Colors.black87.withOpacity(0.8),
                        ),
                        Image.asset(
                          'assets/images/img_face.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Positioned(
                      bottom: 3,
                      left: Get.width * 0.2,
                      right: Get.width * 0.2,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          thumbColor: Colors.amber,
                          activeTrackColor: Colors.amber,
                          inactiveTrackColor: Colors.grey.shade300,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 8.0,
                          ),
                        ),
                        child: Slider(
                          value: currentExposureOffset.value,
                          onChanged: (value) async {
                            // debugPrint('Value Exposure: $value');
                            // debugPrint('Value Exposure Min: ${await controller.camController.getMinExposureOffset()}');
                            // debugPrint('Value Exposure Max: ${await controller.camController.getMaxExposureOffset()}');
                            // setExposureSafe(value);
                            currentExposureOffset(value);
                            controller.camController.setExposureOffset(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField1(
                    controller: controller.noteC,
                    hintText: "Alasan",
                    fillColor: whiteColor,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    preffixIcon: Icon(Iconsax.task_square_copy),
                  ),
                  const Gap(10),
                  Obx(() {
                    return Button1(
                      title: "${controller.status}",
                      showOutline: false,
                      widget: controller.isLoading.value
                          ? SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: HexColor("#02bdde"),
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                      onTap: controller.isLoading.value
                          ? null
                          : () async {
                              if (Platform.isAndroid) {
                                bool timeAuto =
                                    await DatetimeSetting.timeIsAuto();
                                bool timezoneAuto =
                                    await DatetimeSetting.timeZoneIsAuto();

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

                              // Jika sedang dalam proses (isLoading = true), jangan lakukan apapun
                              if (controller.isLoading.value) return;

                              // Set isLoading menjadi true untuk mencegah tap lagi
                              controller.isLoading(true);

                              try {
                                if (Get.arguments == '502') {
                                  // Kondisi tanpa koneksi internet
                                  await saveImageIntoHive();
                                } else {
                                  // Kondisi dengan koneksi internet

                                  if (Get.arguments == '2' &&
                                      controller.noteC.text.isEmpty) {
                                    // Jika note tidak diisi
                                    Snackbar().snackbar1(
                                      'Informasi!',
                                      'Note harus diisi',
                                      Iconsax.info_circle,
                                      Colors.white,
                                      Colors.orange,
                                    );
                                    return;
                                  }

                                  /**
                             * Logika capture dan perbandingan wajah online
                             * ambil gambar untuk mf2image
                             */
                                  await controller.captureAndMatchFaces(
                                    Get.arguments,
                                  );
                                }
                              } finally {
                                // Pastikan isLoading di-reset ke false setelah proses selesai
                                controller.isLoading(false);
                              }
                            },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> setExposureSafe(double value) async {
  if (!controller.camController.value.isInitialized) return;

  _exposureDebounce?.cancel();
  _exposureDebounce = Timer(const Duration(milliseconds: 120), () async {
    try {
      await controller.camController.setExposureOffset(value);
    } catch (e) {
      debugPrint('⚠️ Exposure skipped: $e');
    }
  });
}


  Future<void> saveImageIntoHive() async {
    try {
      XFile? picture = await controller.camController.takePicture();

      // save image into hive
      Uint8List imageBytes = await File(picture.path).readAsBytes();

      // get location
      final data = await GeoLocation().offlineLocation();

      // simpan gambar ke hive
      await imageBox.put('storedImage', imageBytes);
      await imageBox.put('storedLat', data['lat'].toString());
      await imageBox.put('storedLng', data['lng'].toString());
      await imageBox.put('storedNote', controller.noteC.text);
      await imageBox.put('storedTime', DateTime.now().toIso8601String());

      log('all save completed');

      Get.defaultDialog(
        title: 'Berhasil',
        middleText:
            'Data berhasil disimpan!, jangan foto kembali sebelum absen ini selesai',
        titleStyle: GoogleFonts.varelaRound(),
        middleTextStyle: GoogleFonts.varelaRound(),
        textConfirm: 'OK',
        onConfirm: () {
          // tutup aplikasi
          SystemNavigator.pop();
        },
      );
    } catch (e) {
      controller.isLoading(false);
      log(e.toString());
    }
  }

  Future<File> uint8ListToFile(Uint8List uint8list, String fileName) async {
    // Dapatkan direktori sementara
    final directory = await getTemporaryDirectory();

    // Buat path untuk file baru
    final filePath = '${directory.path}/$fileName';

    // Buat file baru di path tersebut
    final file = File(filePath);

    // Tulis Uint8List ke file
    await file.writeAsBytes(uint8list);

    return file;
  }
}
