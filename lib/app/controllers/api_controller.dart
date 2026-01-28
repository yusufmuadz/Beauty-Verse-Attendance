import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:gap/gap.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:hive/hive.dart";
import "package:http/http.dart" as http;
import "package:iconsax_flutter/iconsax_flutter.dart";

import "package:lancar_cat/app/controllers/calendar_controller.dart";
import "package:lancar_cat/app/controllers/geolocator_controller.dart";
import "package:lancar_cat/app/controllers/model_controller.dart";
import "package:lancar_cat/app/core/components/custom_dialog.dart";
import "package:lancar_cat/app/core/constant/variables.dart";
import "package:lancar_cat/app/data/model/agreement_overtime_response_model.dart";
import "package:lancar_cat/app/data/model/attendance_response_model.dart";
import "package:lancar_cat/app/data/model/identify_job_scope_response_model.dart";
import "package:lancar_cat/app/data/model/leave_response_model.dart";
import "package:lancar_cat/app/data/model/login_response_model.dart";
import "package:lancar_cat/app/data/model/submission_attendance_response_model.dart";
import "package:lancar_cat/app/data/model/time_off_response_model.dart";
import "package:lancar_cat/app/data/model/timeoff_submission_response_model.dart";
import "package:lancar_cat/app/data/model/today_attendance_response_model.dart";
import "package:lancar_cat/app/models/attendance.dart";
import "package:lancar_cat/app/models/location.dart";
import "package:lancar_cat/app/models/resp_approval_leave.dart";
import "package:lancar_cat/app/models/resp_approval_overtime.dart";
import "package:lancar_cat/app/models/schedule.dart";
import "package:lancar_cat/app/models/time_off.dart";
import "package:lancar_cat/app/models/time_off_request.dart";
import "package:lancar_cat/app/modules/authentication/views/sign_in_view.dart";
import "package:lancar_cat/app/modules/camera_capture/controllers/camera_capture_controller.dart";
import "package:lancar_cat/app/modules/home/views/menu_view.dart";
import "package:lancar_cat/app/shared/snackbar/snackbar_1.dart";
import "package:lancar_cat/app/shared/utils.dart";
import "package:lancar_cat/app/models/shift.dart" as a;
import "package:intl/intl.dart";

class ApiController extends GetxController {
  final _box = Hive.box("andioffset");
  final m = Get.find<ModelController>();
  final g = Get.put(GeolocatorController());
  final c = Get.put(CalendarController());

  // ===== authentication =====

  Future<void> login({required String email, required String password}) async {
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/v2/user/login'),
      );
      request.body = json.encode({"email": email, "password": password});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      final data = json.decode(await response.stream.bytesToString());

      if (response.statusCode == 401) {
        if (Get.isSnackbarOpen) Get.back();
        Get.back();
        Snackbar().snackbar1(
          "Informasi",
          data["message"] ?? "Unauthorized",
          Iconsax.info_circle,
          whiteColor,
          Colors.red,
        );
        return;
      }

      if (response.statusCode == 200) {
        final result = LoginResponseModel.fromMap(data);
        log('log_info: $result');
        m.detailUser(result);

        // Save token
        await _box.put("token", result.token);
        m.token(result.token);

        // Fetch current user and navigate to MenuView
        await fetchCurrentUser();
        Get.offAll(() => MenuView(), transition: Transition.cupertino);

        log('log_info: selesai');
        Get.back();
        return;
      }

      // Handle other status codes
      Get.back();
      Snackbar().snackbar1(
        "Error",
        data["message"] ?? "Unknown error occurred",
        Iconsax.warning_2,
        whiteColor,
        Colors.red,
      );
    } on TimeoutException {
      Get.back();
      Get.bottomSheet(_buildNoInternetBottomSheet());
    } on HttpException catch (e) {
      log('log_info: $e');
      Snackbar().snackbar1(
        "Peringatan",
        e.message,
        Iconsax.lock_1_copy,
        whiteColor,
        Colors.red,
      );
    } catch (e) {
      log('log_info: $e');
      Get.back();
      Get.bottomSheet(_buildNoInternetBottomSheet());
    }
  }

  Widget _buildNoInternetBottomSheet() {
    return Container(
      color: whiteColor,
      width: Get.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_cellular_connected_no_internet_0_bar_rounded,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 8),
          Text(
            "Jaringan tidak tersedia",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Periksa jaringan Anda, kemudian coba kembali",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ===== end authentication =====

  Future isAccountDeleted() async {
    await _box.delete("token");

    // Hapus data gambar dan nama yang tersimpan di Hive
    var box = await Hive.openBox('avatarBox');

    await box.deleteAll(['avatarFileName', 'avatarImage']);
    await box.clear();

    Uri url = Uri.parse("${Variables.baseUrl}/token/logout");

    try {
      await http
          .delete(url, headers: {"Authorization": "Bearer ${m.token.value}"})
          .then((value) {
            // Bersihkan semua data model terkait akun yang logout
            m.clearModel();

            // Kembali ke halaman sebelumnya
            Get.back();
          });
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }

    // Setelah semua data dihapus, arahkan user ke halaman login (SignInView)
    Get.offAll(() => SignInView(), transition: Transition.cupertino);
  }

  Future<String?> isAccountAvailable() async {
    if (m.token.isNotEmpty) {
      return m.token.value;
    }

    String? token = _box.get("token");
    m.token(token);
    log(token!);
    return token;
  }

  Future getAgama() async {
    Uri url = Uri.parse("${Variables.baseUrl}/agama/list");

    try {
      var result = await http.get(url);

      if (result.statusCode == 200) {
        List agama = json.decode(result.body);

        return agama;
      }
    } on HttpException catch (e) {
      log(e.message);
    }
  }

  Future findApprovedBySuperAdmin() async {
    Uri url = Uri.parse("${Variables.baseUrl}/approved/superadmin/id");

    try {
      var res = await http.get(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
      );

      if (res.statusCode == 200) {
        List data = json.decode(res.body)["data"];
        List<TimeOffRequest> result = data
            .map((e) => TimeOffRequest.fromJson(e))
            .toList();
        return result;
      } else {}
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TimeoffSubmissionResponseModel> submitTimeOff({
    required List<XFile?> files,
    required String alasan,
    required String timeOffMasterId,
    required DateTime startTimeOff,
    required DateTime endTimeOff,
  }) async {
    var headers = {
      "Authorization": "Bearer ${m.token.value}",
      "Accept": "application/json",
    };

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${Variables.baseUrl}/timeoff/submit"),
    );

    request.fields.addAll({
      "approval_line": m.u.value.job!.approvalAbsensi!,
      "time_off_master_id": timeOffMasterId,
      "reason": alasan,
      "start_time_off": startTimeOff.toIso8601String(),
      "end_time_off": endTimeOff.toIso8601String(),
    });

    for (var file in files) {
      String format = file!.path.split('.').last;
      XFile? data = file;
      if (format == 'png' || format == 'jpeg' || format == 'jpg') {
        data = await Variables().compressFile(File(file.path));
      }

      request.files.add(
        await http.MultipartFile.fromPath("file[]", data!.path),
      );
    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      final str = await response.stream.bytesToString();
      final data = TimeoffSubmissionResponseModel.fromJson(str);

      return data;
    } catch (e) {
      return TimeoffSubmissionResponseModel();
    }
  }

  Future findSubmissionByUserId() async {
    log('where');
    final m = Get.find<ModelController>();
    Uri url = Uri.parse('${Variables.baseUrl}/v1/line/fetch/attendance');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${m.token.value}'},
      );
      if (response.statusCode == 200) {
        final result = SubmissionApprovalResponseModel.fromJson(response.body);
        m.attendanceSize(result.pendingLenght);
        return result.submission!.isEmpty ? null : result;
      } else {
        m.attendanceSize(0);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future lenghtCountShiftLine() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/line/fetch/count/shift'),
    );

    try {
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = json.decode(str);
        m.changeShift(data);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } on SocketException catch (e) {
      m.dialogNoInternet();
      throw SocketException(e.message);
    }
  }

  Future<RespApprovalOvertime?> approvalOvertime({
    required int month,
    required int year,
  }) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v2/approval/overtime/$month/$year'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = RespApprovalOvertime.fromRawJson(str);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future findOvertimeByLine() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v1/line/fetch/lembur'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = AgreementOvertimeResponseModel.fromJson(str);
        m.overtimeSize(data.pendingLenght);
        return data;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // agreement
  Future<RespAppLeave?> fetchApprovalAgreement(month, year) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v2/approval/leave/$month/$year'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = RespAppLeave.fromJson(str);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future getAgreementLine() async {
    Uri url = Uri.parse("${Variables.baseUrl}/find/line");

    try {
      var req = await http.get(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
      );

      if (req.statusCode == 200) {
        final results = LeaveResponseModel.fromJson(req.body);
        m.leaveSize(results.pendingLenght ?? 0);
        return results;
      }
    } on HttpException catch (e) {
      //
      log(e.message);
    } catch (e) {
      //
      log(e.toString());
    }
  }

  // approval cuti

  Future getAllApproval({required DateTime date}) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v2/timeoff/filter'),
      );

      request.fields.addAll({
        'date': DateFormat('yyyy-MM', 'id_ID').format(date),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final leave = TimeOffResponseModel.fromJson(data);
        return leave.content;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // end approval cuti

  Future findScheduleByUserId() async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};
    var url = Uri.parse("${Variables.baseUrl}/schedule/id");
    try {
      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        m.schedule = Schedule.fromJson(data["data"]);
        m.effectiveDate = m.schedule!.schedule!.effectiveDate;
      } else {
        log(response.body);
      }
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }
  }

  Future identifyJobScope({String? date, String? subordinate = ''}) async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};
    var request = http.Request(
      'GET',
      Uri.parse(
        '${Variables.baseUrl}/v1/user/job-scope?date=$date&subordinate=$subordinate',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      return IdentifyJobScopeResponseModel.fromJson(str);
    } else {
      debugPrint('log_error: ${response.reasonPhrase}');
    }
  }

  Future<dynamic> fetchUsers(String nama, int? page) async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};
    var request = http.Request(
      "GET",
      Uri.parse("${Variables.baseUrl}/users?page=$page&nama=$nama"),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final users = IdentifyJobScopeResponseModel.fromJson(str);
      return users.data;
    } else {
      return false;
    }
  }

  Future fetchCurrentUser() async {
    // log("fetch Current User");
    // log("${m.token.value}");
    try {
      final response = await http.get(
        Uri.parse("${Variables.baseUrl}/v3/user"),
        headers: {"Authorization": "Bearer ${m.token.value}"},
      );

      if (response.statusCode == 200) {
        m.u(User.fromJson(response.body));
      } else {
        Get.offAll(() => SignInView());
      }
    } on SocketException catch (_) {
      Get.dialog(
        AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.wifi_copy, size: 40),
                const Gap(10),
                Text(
                  'Tidak dapat terhubung ke jaringan, Coba lagi nanti',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.figtree(fontSize: 14),
                ),
                const Gap(10),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.figtree(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } on HttpException catch (e) {
      log(e.message);
      // Get.offAll(() => SignInView());
    } catch (e) {
      Get.offAll(() => SignInView());
    }
  }

  Future<void> todayAttendance() async {
    await findScheduleByUserId();
    // await fetchShift();
    await CameraCaptureController().loadNetworkImage();

    // URL untuk API request
    Uri url = Uri.parse('${Variables.baseUrl}/v2/user/today/attendance/input');
    // Uri url = Uri.parse("${Variables.baseUrl}/v2/user/today/attendance");
    debugPrint(m.token.value);

    // Membuat permintaan HTTP GET
    try {
      var response = await http.post(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
        body: {'date': DateTime.now().toIso8601String()},
      );

      // // Memeriksa status kode respons
      if (response.statusCode == 200) {
        m.ci(Attendance());
        m.co(Attendance());
        m.todayShift(a.Shift());
        final data = TodayAttendanceResponseModel.fromJson(response.body);
        // log(data.toJson());
        m.todayShift(data.shift);
        m.ci(
          data.attendance!.firstWhereOrNull(
            (element) => element.type == "clockin",
          ),
        );
        m.co(
          data.attendance!.firstWhereOrNull(
            (element) => element.type == "clockout",
          ),
        );
        m.timeOffMaster(data.timeoff);
      } else if (response.statusCode == 404) {
        // Menangani kasus data tidak ditemukan
        m.ci(Attendance());
        m.co(Attendance());
        log("== masuk sini ==");
      } else {
        // Menangani respons selain 200 dan 404
        m.ci(Attendance());
        m.co(Attendance());
      }
    } catch (e) {
      // Menangani pengecualian atau error
      m.ci(Attendance());
      m.co(Attendance());
      log("Error: $e");
    }
  }

  // authentication change password
  Future changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    Uri url = Uri.parse("${Variables.baseUrl}/user/change-password");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${m.token.value}",
        },
        body: {
          "old_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmPassword,
        },
      );

      if (response.statusCode == 401) {
        Get.back();
        Snackbar().snackbar1(
          "Gagal",
          json.decode(response.body)["message"],
          Iconsax.close_circle,
          Colors.white,
          Colors.red,
        );

        return false;
      }

      return true;
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future submitAttendance(File image, String? note) async {
    log("=== storeAttendance ===");

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark pm = placemarks.first;

      String address =
          "${pm.street}, ${pm.locality}, ${pm.postalCode}, ${pm.country}";
      var headers = {
        "Authorization": "Bearer ${m.token.value}",
        "Content-Type": "multipart/form-data",
      };
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${Variables.baseUrl}/v2/testing/submit/attendance"),
      );

      request.fields.addAll({
        "lat": "${position.latitude}",
        "lang": "${position.longitude}",
        "address": address,
        "catatan": note ?? "-",
        "shift_id": "${m.todayShift.value.id}",
      });

      Get.dialog(AlertDialog(content: Image.file(File(image.path))));

      request.files.add(await http.MultipartFile.fromPath("image", image.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final results = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        // Check for correct status code
        final data = AttendanceResponseModel.fromRawJson(results);
        if (kDebugMode) {
          debugPrint(data.toJson().toString());
        }
        return data;
      } else {
        if (kDebugMode) {
          debugPrint("Error response: $results");
          debugPrint("Error reason: ${response.reasonPhrase}");
          debugPrint("Error status code: ${response.statusCode}");
        }
        return null;
      }
    } on HttpException catch (e) {
      log(e.message);
      Get.dialog(AlertDialog(title: Text(e.message)));
      return null;
      // return false; // Return false on HttpException
    } catch (e) {
      log(e.toString());
      Get.dialog(AlertDialog(title: Text(e.toString())));
      return null;
      // return false; // Return false on general exceptions
    }
  }

  Future fetchHistoryAttendance() async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};
    Uri url = Uri.parse("${Variables.baseUrl}/attendance/history");

    try {
      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        List data = json.decode(res.body);
        List<Attendance> listAtt = data
            .map((e) => Attendance.fromJson(e))
            .toList();

        m.attendance(listAtt);
        return listAtt;
      }
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }
  }

  Future locations() async {
    Uri url = Uri.parse("${Variables.baseUrl}/locations/user");

    try {
      var res = await http.get(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        m.locations.value = Locations.fromJson(data);
        return Locations.fromJson(data);
      }

      return null;
    } on HttpException catch (e) {
      log(e.message);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(new RegExp(r".jp"));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 40,
    );

    print(file.lengthSync());

    return result;
  }

  Future updateProfile(XFile? image, String? data, String? value) async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${Variables.baseUrl}/user/update"),
    );

    request.fields.addAll({"data": data ?? "", "value": value ?? ""});

    if (image != null) {
      XFile? file = await compressFile(File(image.path));
      // jika gambar tidak null maka disertakan
      request.files.add(await http.MultipartFile.fromPath("image", file!.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      return true;
    } else {
      log(response.reasonPhrase!);
      return false;
    }
  }

  // cuti
  Future getCuti() async {
    m.timeOff([]);
    log('cuti');

    Uri url = Uri.parse("${Variables.baseUrl}/timeoff/available");

    try {
      var res = await http.get(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
      );

      if (res.statusCode == 200) {
        List data = json.decode(res.body)["data"];
        List<TimeOff> result = data.map((e) => TimeOff.fromJson(e)).toList();
        m.timeOff(result);
        return result;
      } else {
        log(json.decode(res.body));
      }
    } catch (e) {
      log('something error: $e');
      throw Exception(e);
    }
  }

  Future approveCuti(String approval_id, String comment, String approve) async {
    Uri url = Uri.parse("${Variables.baseUrl}/approve");

    try {
      var res = await http.post(
        url,
        headers: {"Authorization": "Bearer ${m.token.value}"},
        body: {
          "id": approval_id,
          "approve": approve,
          "comment_approval_line": comment,
        },
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(data);
      } else {
        log(json.decode(res.body));
      }
    } on HttpException catch (e) {
      log(e.message);
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

  Future calculateDelayDuration({
    required File image,
    String catatan = "-",
  }) async {
    var headers = {"Authorization": "Bearer ${m.token.value}"};

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

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("${Variables.baseUrl}/v1/user/late/break"),
    );

    request.fields.addAll({
      "attendance_id": m.ci.value.userAttendanceId!,
      "lat": m.lat.value.toString(),
      "lang": m.lng.value.toString(),
      "address": address,
      "catatan": catatan,
      "time": DateTime.now().toIso8601String(),
    });

    XFile? file = await compressFile(image);

    request.files.add(await http.MultipartFile.fromPath("image", file!.path));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        final results = await response.stream.bytesToString();
        log("Success response: $results");
        return true;
      } else {
        final str = await response.stream.bytesToString();
        final jsn = json.decode(str);
        Get.dialog(
          CustomDialog(
            title: 'Gagal..!',
            content: jsn['message'],
            onConfirm: () {
              Get.back();
              Get.back();
              Get.back();
              Get.back();
            },
            onCancel: () {
              Get.back();
              Get.back();
              Get.back();
              Get.back();
            },
          ),
        );
        return false;
      }
    } on HttpException catch (e) {
      log(e.message);
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
