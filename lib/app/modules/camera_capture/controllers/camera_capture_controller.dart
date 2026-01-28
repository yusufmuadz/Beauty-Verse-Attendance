import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:lancar_cat/app/core/components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/submit_attendance_response_model.dart';
import 'package:lancar_cat/app/modules/camera_capture/views/detail_status_attendance_view.dart';
import 'package:lancar_cat/app/modules/home/views/menu_view.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../shared/snackbar/snackbar_1.dart';

class CameraCaptureController extends GetxController {
  final _box = Hive.box('andioffset');

  final a = Get.put(ApiController());
  final m = Get.find<ModelController>();
  final noteC = TextEditingController();

  RxBool isLoading = false.obs;
  RxString status = 'Kirim presensi'.obs;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;

  late CameraController camController;
  final faceSdk = FaceSDK.instance;
  MatchFacesImage? mfImage2;
  final Snackbar snackbar = Snackbar();

  DateTime? temporary;

  XFile? picture;
  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void dispose() {
    isLoading(false);
    super.dispose();
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

  deleteAll() async {
    _box.deleteAll([
      'storedImage',
      'storedLat',
      'storedLng',
      'storedNote',
      'storedTime',
    ]);
  }

  offlineAttendanceCheck() async {
    // Check if the user has present
    Uint8List? sImage = _box.get('storedImage');
    String? sLat = _box.get('storedLat');
    String? sLng = _box.get('storedLng');
    String? sNote = _box.get('storedNote');
    String? sTime = _box.get('storedTime');

    // log('sImage: $sImage');
    log('sLat: $sLat');
    log('sLng: $sLng');
    log('sNote: $sNote');
    log('sTime: $sTime');
    if (sImage != null) {
      // ubah uint8list menjadi file

      // dapatkan alamat lengkap
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(sLat!),
        double.parse(sLng!),
      );

      Placemark pm = placemarks.first;

      String address =
          "${pm.street}, ${pm.locality}, ${pm.postalCode}, ${pm.country}";

      // lakukan pengecekan wajah dengan dengan wajah api
      await loadNetworkImage();

      // lakukan compress gambar Uint8List
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        sImage,
        minHeight: 300, // Atur tinggi minimum
        minWidth: 300, // Atur lebar minimum (
        quality: 40, // Kualitas kompresi
      );

      mfImage2 = MatchFacesImage(compressedBytes, ImageType.PRINTED);
      File imageFile = await uint8ListToFile(compressedBytes, 'temp_img.png');

      log('${m.mfImage1 == null}');
      log('${mfImage2 == null}');

      var request = MatchFacesRequest([m.mfImage1!, mfImage2!]);
      var response = await faceSdk.matchFaces(request);
      var split = await faceSdk.splitComparedFaces(response.results, 0.25);
      var match = split.matchedFaces;
      if (match.isNotEmpty) {
        log('wajah sesuai');
        // jika wajah sesuai maka kirimkan data berikut
        SubmitAttendanceResponseModel data = await submitOfflineAttendance(
          image: imageFile,
          latitude: sLat.toString(),
          longitude: sLng.toString(),
          address: address,
          time: sTime!,
          note: sNote ?? '',
          shiftId: m.todayShift.value.id.toString(),
        );

        if (data.status!) {
          Get.dialog(
            AlertDialog(
              title: Text(data.message ?? 'Absensi gagal dikirim'),
              content: Text('Absensi berhasil dikirim'),
            ),
          );
          deleteAll();
        } else {
          Get.dialog(
            AlertDialog(
              title: Text(data.message ?? 'Absensi gagal dikirim'),
              content: Text('Absensi gagal dikirim'),
            ),
          );
        }
      } else {
        log('wajah tidak sama');

        // jika wajah tidak sesuai maka kirimkan data berikut
        await submitSubmissionAttendance(
          dateRequestFor: DateTime.now().toIso8601String(),
          clockinTime: sTime!, // DateTime.now()
          alasan: sNote!,
          approvalLine: m.u.value.job!.approvalAbsensi!,
        );

        Get.dialog(
          AlertDialog(
            title: Text('Absensi anda dalam pengajuan'),
            content: Text('Absensi berhasil dikirim'),
          ),
        );
        deleteAll();
      }

      deleteAll();
    }
  }

  Future submitSubmissionAttendance({
    required String dateRequestFor,
    required String clockinTime,
    required String alasan,
    required String approvalLine,
  }) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/submission/attendance/submit'),
      );
      request.fields.addAll({
        'date_request_for': dateRequestFor,
        'clockin_time': DateFormat(
          'HH:mm',
          'id_ID',
        ).format(DateTime.parse(clockinTime)),
        'clockout_time': '',
        'reason_request': alasan,
        'approval_line': approvalLine,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        Get.back();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future submitOfflineAttendance({
    required File image,
    required String latitude,
    required String longitude,
    required String address,
    required String time,
    String? note,
    String? shiftId,
  }) async {
    var headers = {
      'Authorization': 'Bearer ${m.token.value}',
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v2/testing/submit/attendance'),
    );

    request.fields.addAll({
      'lat': latitude,
      'lang': longitude,
      'address': address,
      'catatan': note ?? "",
      'shift_id': shiftId ?? "",
      'time': time,
    });

    try {
      request.files.add(
        await http.MultipartFile.fromPath('picture', image.path),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      final result = SubmitAttendanceResponseModel.fromJson(data);
      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadNetworkImage() async {
    // Cek apakah m.mfImage1 sudah menyimpan gambar
    final avatarUrl = m.u.value.avatar;
    final avatarFileName = avatarUrl!.split('/').last;

    // Membuka kotak Hive, misal box 'avatarBox'
    var box = await Hive.openBox('avatarBox');

    // Cek apakah ada nama avatar yang disimpan di Hive
    String? storedAvatarFileName = box.get('avatarFileName');

    // Uint8List? imageToShow; // Variable to hold the image for dialog

    // Jika nama file di Hive berbeda atau belum ada, maka lakukan update
    if (storedAvatarFileName == null ||
        storedAvatarFileName != avatarFileName) {
      // log('load_network_image: Downloading new image because filename is different or empty');

      // Download gambar dari jaringan
      final response = await http.get(Uri.parse(avatarUrl));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Decode image dari jaringan
        img.Image? image = img.decodeImage(bytes);

        if (image != null) {
          // Resize gambar
          img.Image resized = img.copyResize(image, width: 300, height: 300);

          // Kompres gambar menjadi JPEG dengan kualitas 40
          Uint8List compressedBytes = Uint8List.fromList(
            img.encodeJpg(resized, quality: 40),
          );

          // Load gambar yang sudah dikompres ke MatchFacesImage
          m.mfImage1 = MatchFacesImage(compressedBytes, ImageType.PRINTED);
          // log('load_network_image: mfImage1 successfully loaded with compression');

          // Simpan nama file avatar dan gambar ke Hive
          await box.put('avatarFileName', avatarFileName);
          await box.put('avatarImage', compressedBytes);

          // log('load_network_image: Avatar filename and image saved to Hive');
          // imageToShow = compressedBytes;
        } else {
          // log('load_network_image: Failed to decode image');
        }
      } else {
        // log('load_network_image: Failed to load image from network');
      }
    } else {
      // log('load_network_image: Using cached image from Hive');
      if (m.mfImage1 != null) {
        // log('load_network_image: mfImage1 already contains an image, skipping download');
        return; // Jika gambar sudah ada, keluar dari fungsi
      }

      // Ambil gambar dari Hive
      Uint8List? cachedBytes = box.get('avatarImage');

      if (cachedBytes != null) {
        // Gunakan gambar yang sudah ada di Hive
        m.mfImage1 = MatchFacesImage(cachedBytes, ImageType.PRINTED);
        // log('load_network_image: mfImage1 loaded from cached image in Hive');
        // imageToShow = cachedBytes;
      } else {
        // log('load_network_image: Cached image not found, re-downloading');

        // Jika tidak ada gambar di Hive, lakukan download ulang
        final response = await http.get(Uri.parse(avatarUrl));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;

          // Decode image dari jaringan
          img.Image? image = img.decodeImage(bytes);

          if (image != null) {
            // Resize gambar
            img.Image resized = img.copyResize(image, width: 300, height: 300);

            // Kompres gambar menjadi JPEG dengan kualitas 40
            Uint8List compressedBytes = Uint8List.fromList(
              img.encodeJpg(resized, quality: 40),
            );

            // Load gambar yang sudah dikompres ke MatchFacesImage
            m.mfImage1 = MatchFacesImage(compressedBytes, ImageType.PRINTED);
            // log('load_network_image: mfImage1 successfully loaded with compression');

            // Simpan nama file avatar dan gambar ke Hive
            await box.put('avatarFileName', avatarFileName);
            await box.put('avatarImage', compressedBytes);

            // log('load_network_image: Avatar filename and image saved to Hive');
            // imageToShow = compressedBytes;
          } else {
            // log('load_network_image: Failed to decode image');
          }
        } else {
          // log('load_network_image: Failed to load image from network');
        }
      }
    }
  }

  Future submitAttendance({
    required File image,
    required String? note,
    required DateTime now,
  }) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${m.token.value}',
        'Content-Type': 'multipart/form-data',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v2/testing/submit/attendance'),
      );

      // mendapatkan alamat dari pub.dev placemark
      String? address = await placemarkAddress(m.lat.value, m.lng.value);

      // jika alamat gagal didapatkan
      if (address!.isEmpty) {
        // note: untuk mendapatkan alamat menggunakan openstreetmap
        var locations = await http.get(
          Uri.parse(
            "https://nominatim.openstreetmap.org/reverse?format=json&lat=${m.lat.value}&lon=${m.lng.value}&addressdetails=1",
          ),
        );
        final xxx = json.decode(locations.body);
        address = xxx['display_name'];
      }

      if (address!.isEmpty) {
        Get.dialog(
          AlertDialog(
            title: const Text("Gagal"),
            content: const Text("Alamat tidak ditemukan"),
          ),
        );
        return;
      }

      request.fields.addAll({
        'lat': '${m.lat.value}',
        'lang': '${m.lng.value}',
        'catatan': note ?? '-',
        'address': address,
        'time': now.toIso8601String(),
      });

      if (picture != null) {
        XFile? file = await Variables().compressFile(File(picture!.path));
        // jika gambar tidak null maka disertakan
        request.files.add(
          await http.MultipartFile.fromPath('picture', file!.path),
        );
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw HttpException('Request timeout');
        },
      );

      final str = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final result = SubmitAttendanceResponseModel.fromJson(str);
        return result;
      } else {
        final result = SubmitAttendanceResponseModel.fromJson(str);
        return result;
      }
    } on HttpException catch (e) {
      Get.dialog(
        AlertDialog(
          title: Text(
            "Ups, ada sedikit kendala saat mengirim data. Yuk, coba lagi!",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            e.message,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      return null;
    } catch (e) {
      Get.dialog(
        AlertDialog(content: Text('Terjadi Kesalahan Silahkan Hubungi AGS')),
      );
      return null;
    }
  }

  Future<void> matchFaces(XFile? fileImage, String? id) async {
    isLoading(true);

    final startCapture = DateTime.now();

    try {
      var request = MatchFacesRequest([m.mfImage1!, mfImage2!]);
      var response = await faceSdk.matchFaces(request);
      var split = await faceSdk.splitComparedFaces(response.results, 0.20);
      var match = split.matchedFaces;

      if (match.isNotEmpty) {
        await _handleMatchedFaces(id, fileImage, startCapture);
      } else {
        // note: jika presensi gagal dikirimkan
        _showSnackbar(title: 'Gagal!', message: 'Wajah gagal teridentifikasi');
        return;
      }
      log('is finally');
      isLoading(false);
    } catch (e) {
      _showSnackbar(title: 'Gagal!', message: e.toString());
    } finally {
      log('is finally');
      isLoading(false);
    }
  }

  Future submitOutOffRangeAttendance(XFile? image, String catatan) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/submission/attendance/submit'),
      );

      request.fields.addAll({
        'date_request_for': DateTime.now().toIso8601String(),
        'clockin_time': (m.ci.value.createdAt == null)
            ? DateFormat('HH:mm:ss', 'id_ID').format(DateTime.now())
            : '',
        'clockout_time': (m.ci.value.createdAt != null)
            ? DateFormat('HH:mm:ss', 'id_ID').format(DateTime.now())
            : '',
        'reason_request': catatan, // alasan pengajuan
        'approval_line': m.u.value.job!.approvalAbsensi!, // approval line
      });

      request.files.add(await http.MultipartFile.fromPath('file', image!.path));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.back();
        isLoading(false);
        noteC.clear();
        await Get.dialog(
          AlertDialog(
            title: Text('Berhasil!'),
            content: Text('Presensi anda dalam pengajuan'),
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
        Get.back();
        Get.back();
      } else {
        log(response.reasonPhrase.toString());
        return;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future submitOvertimeAttendance({
    required XFile? image,
    required String note,
  }) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/submit/overtime'),
    );

    // Mencoba mendapatkan lokasi dari placemark dengan hasil address atau null
    String? address = await placemarkAddress(m.lat.value, m.lng.value);

    if (address!.isEmpty) {
      // Jika alamat tidak ditemukan, coba dengan menggunakan nominatim
      var locations = await http.get(
        Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=${m.lat.value}&lon=${m.lng.value}&addressdetails=1",
        ),
      );
      final xxx = json.decode(locations.body);
      address = xxx['display_name'];
    }

    if (address!.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: const Text("Alamat tidak ditemukan"),
        ),
      );
      return;
    }
    try {
      request.fields.addAll({
        'timestamp': DateTime.now().toIso8601String(),
        'overtime_request_id': m.overtimeReqId.value.toString(),
        'latitude': m.lat.value.toString(),
        'langitude': m.lng.value.toString(),
        'address': address,
        'notes': note,
        'overtime_type': m.typeOvertime.value,
      });

      XFile? file = await Variables().compressFile(File(image!.path));
      File result = await Variables().cropSquareImage(File(file!.path));
      request.files.add(
        await http.MultipartFile.fromPath('image', result.path),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final str = await response.stream.bytesToString();
      final data = json.decode(str);

      if (response.statusCode == 200) {
        isLoading(false);
        noteC.clear();

        Get.back();
        Get.back();
        Get.back();
      } else {
        Get.back();
        Get.defaultDialog(
          title: 'Informasi',
          titleStyle: GoogleFonts.varelaRound(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          content: Text(
            data["message"].toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.varelaRound(fontSize: 14),
          ),
        );
      }
    } catch (e) {
      Get.dialog(CustomDialog(title: 'Informasi', content: e.toString()));
      throw Exception(e);
    }
  }

  Future placemarkAddress(double lat, double lng) async {
    try {
      final List<Placemark> placemark = await placemarkFromCoordinates(
        lat,
        lng,
      );

      Placemark pm = placemark.first;

      String address =
          "${pm.street}, ${pm.locality}, ${pm.postalCode}, ${pm.country}";
      return address;
    } catch (e) {
      return null;
    }
  }

  // Future overtimeSubmitAttendance(
  //   XFile? image,
  //   String catatan,
  // ) async {
  //   var headers = {'Authorization': 'Bearer ${m.token.value}'};
  //   var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //         '${Variables.baseUrl}/v1/user/presence/lembur',
  //       ));

  //   // /v1/user/submit/overtime

  //   final data = await GeoLocation().currentLocation();

  //   request.fields.addAll({
  //     'overtime_request_id': m.overtimeReqId.value,
  //     'lat': data['lat'].toString(),
  //     'lang': data['lng'].toString(),
  //     'address': data['address'].toString(),
  //     'catatan': catatan,
  //     'type_overtime': m.typeOvertime.value,
  //   });

  //   XFile? file = await Variables().compressFile(File(image!.path));
  //   File result = await Variables().cropSquareImage(File(file!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'image',
  //     result.path,
  //   ));

  //   request.headers.addAll(headers);

  //   try {
  //     log('send message');
  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       final str = await response.stream.bytesToString();
  //       final data = json.decode(str);
  //       log(data.toString());
  //       isLoading(false);
  //       noteC.clear();

  //       Get.back();
  //       Get.back();
  //       Get.back();
  //     } else {
  //       print(response.reasonPhrase);
  //       CustomDialog(title: 'Error', content: response.reasonPhrase!);
  //     }
  //   } catch (e) {
  //     CustomDialog(title: 'Error', content: e.toString());
  //     log(e.toString());
  //   }
  // }

  lateBreakIn(XFile? fileImage, String note) async {
    bool isSuccess = await a.calculateDelayDuration(
      image: File(fileImage!.path),
      catatan: note,
    );

    if (isSuccess) {
      Get.back();
      Get.back();
      Get.back();
    }
    return;
  }

  defaultSubmitAttendance({
    required XFile? fileImage,
    required DateTime presentTime,
  }) async {
    if (fileImage == null) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error Image..!'),
          content: const Text(
            'Terjadi kesalahan pada saat pengambilan gambar.',
          ),
          actions: [TextButton(onPressed: () {}, child: const Text("Selesai"))],
        ),
      );
      return;
    }

    /**
     * Pengecekan apakah shift id kosong atau tidak
     * jika kosong maka lakukan pengambilan data kembali
     * dan jika tidak kosong langsung lakukan presensi
     */
    if (m.todayShift.value.id!.isEmpty) {
      Variables().loading();
      await a.todayAttendance();
      Get.back();
    }

    SubmitAttendanceResponseModel? result = await submitAttendance(
      image: File(fileImage.path),
      note: noteC.text,
      now: presentTime,
    );

    debugPrint(
      'log: waktu pengiriman data ${DateTime.now().difference(temporary!)}',
    );

    if (!result!.status!) {
      await customDialog(result.message!);
      return;
    }

    isLoading(false);
    noteC.clear();
    Get.back();
    Get.back();
    Get.to(
      () => DetailStatusAttendanceView(),
      arguments: {
        'status': result.isLateOrEarly,
        'type': result.type,
        'time': result.attendance!.createdAt,
      },
    );
  }

  customDialog(String message) => Get.dialog(
    // ignore: deprecated_member_use
    WillPopScope(
      child: AlertDialog(
        content: Text(
          message,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        title: Text(
          'Informasi',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.offAll(() => MenuView());
            },
            child: Text('OK'),
          ),
        ],
      ),
      onWillPop: () async => false,
    ),
  );

  Future captureAndMatchFaces(String? id) async {
    temporary = DateTime.now();
    if (_isDefaultAvatar(m.u.value.avatar)) {
      // cek apakah masih menggunakan avatar default
      _showSnackbar(
        title: 'Peringatan!',
        message: 'anda memerlukan photo profile untuk absensi',
      );
      return;
    }

    picture = await camController.takePicture(); // ambil gambar

    if (picture!.path.isEmpty) {
      // jika gambar tidak ada
      _showSnackbar(title: 'Peringatan!', message: 'Wajah wajib terlihat');
      return;
    }

    // mengubah gambar menjadi mfImage2
    if (picture != null) {
      // ... dipotong dulu menjadi 1x1
      File croppper = await Variables().cropSquareImage(File(picture!.path));

      XFile? compress = await Variables().compressFile(croppper);
      picture = compress;

      // ... dimasukan kedalam variabel mfImage2
      mfImage2 = MatchFacesImage(
        File(compress!.path).readAsBytesSync(),
        ImageType.PRINTED,
      );

      // cara membuat agar fungsi ini ditunggu hanya 10 detik jika sudah lebih dari 10 detik maka gagalkan
      await matchFaces(picture, id);
    }
  }

  // ===== fitur baru untuk mengatasi masalah timeout =====

  Future<void> _handleMatchedFaces(
    String? id,
    XFile? fileImage,
    DateTime presentTime,
  ) async {
    switch (id) {
      case '0': // Submit attendance default
        await defaultSubmitAttendance(
          fileImage: fileImage,
          presentTime: presentTime,
        );
        break;
      case '2': // Input istirahat telat
        await lateBreakIn(fileImage, noteC.text);
        break;
      case '3': // Input presensi luar jangkauan kantor
        await submitOutOffRangeAttendance(fileImage, noteC.text);
        break;
      case '5': // Submit presensi lembur terbaru
        await submitOvertimeAttendance(image: fileImage, note: noteC.text);
        break;
      default:
        _showSnackbar(title: 'Peringatan!', message: 'ID tidak dikenali');
        break;
    }
  }

  bool _isDefaultAvatar(String? avatarUrl) {
    return avatarUrl == null ||
        avatarUrl.split('/').last == 'default.jpg' ||
        avatarUrl.contains('default.jpg');
  }

  void _showSnackbar({String title = '', String message = ''}) {
    snackbar.snackbar1(
      title,
      message,
      Iconsax.user_square,
      whiteColor,
      redColor,
    );
  }
}
