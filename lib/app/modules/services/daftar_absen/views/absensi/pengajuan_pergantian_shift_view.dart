import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/components/custom_empty_submission.dart';
import '../../../../../core/components/detail_absensi_bottom_sheet.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/list_shift_response_model.dart';
import '../../../../../models/shift.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/dialog.dart';
import '../../../../../shared/snackbar/snackbar_1.dart';
import '../../../../../shared/textfieldform.dart';
import '../../../../home/controllers/home_controller.dart';

class PengajuanPergantianShiftView extends StatefulWidget {
  const PengajuanPergantianShiftView({super.key});

  @override
  State<PengajuanPergantianShiftView> createState() =>
      _PengajuanPergantianShiftViewState();
}

class _PengajuanPergantianShiftViewState
    extends State<PengajuanPergantianShiftView> {
  DateTime _selectedDate = DateTime.now();
  Shift selectedShift = Shift();
  Shift? newShift = Shift();
  RxBool isFlexible = false.obs;

  final formKey = GlobalKey<FormState>();

  final homeController = Get.put(HomeController());

  final dateController = TextEditingController();
  final oldShiftController = TextEditingController();
  final newShiftController = TextEditingController();
  final alasanController = TextEditingController();

  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();
  final breakTimeController = TextEditingController();
  final breakTimeEndController = TextEditingController();

  final searchController = TextEditingController();

  Timer? _debounce;

  RxList<Shift> listShift = <Shift>[].obs;

  @override
  void initState() {
    super.initState();
    fetchShift("", selectedDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Pergantian Shift"),
        centerTitle: true,
        elevation: 1.5,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchShift('', selectedDate: _selectedDate);
        },
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            const Gap(5),
            TextfieldForm(
              controller: dateController,
              labelText: 'Pilih Tanggal',
              prefixIcon: Icon(Iconsax.calendar_1_copy),
              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
              readOnly: true,
              onTap: () => showDatePickerCalendar(),
            ),
            const Gap(20),
            TextfieldForm(
              controller: oldShiftController,
              prefixIcon: Icon(Iconsax.calendar_1_copy),
              labelText: 'Shift Sekarang',
              readOnly: true,
            ),
            const Gap(20),
            TextfieldForm(
              controller: newShiftController,
              hintText: 'Shift Baru',
              labelText: 'Shift Baru',
              prefixIcon: Icon(Iconsax.clock_copy),
              suffixIcon: Icon(Icons.keyboard_arrow_down),
              onTap: () => showOptionShift(),
              readOnly: true,
            ),
            const Gap(20),
            Obx(() {
              {
                if (!isFlexible.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextfieldForm(
                        controller: alasanController,
                        hintText: 'contoh: Acara keluarga',
                        labelText: 'Alasan',
                        prefixIcon: Icon(Iconsax.note_1_copy),
                      ),
                    ],
                  );
                } else {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextfieldForm(
                          controller: checkInController,
                          prefixIcon: Icon(Iconsax.clock_copy),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          labelText: 'Waktu Masuk',
                          readOnly: true,
                          onTap: () => _onTimeChangePressed(
                            controller: checkInController,
                          ),
                          validator: (value) => _validatorMessage(
                            value!,
                            'Waktu Masuk harus di isi',
                          ),
                        ),
                        const Gap(20),
                        TextfieldForm(
                          controller: checkOutController,
                          prefixIcon: Icon(Iconsax.clock_copy),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          labelText: 'Waktu Pulang',
                          readOnly: true,
                          onTap: () => _onTimeChangePressed(
                            controller: checkOutController,
                          ),
                          validator: (value) => _validatorMessage(
                            value!,
                            'Waktu Pulang harus di isi',
                          ),
                        ),
                        const Gap(20),
                        TextfieldForm(
                          controller: breakTimeController,
                          prefixIcon: Icon(Iconsax.clock_copy),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          labelText: 'Jam Mulai Istirahat',
                          readOnly: true,
                          onTap: () => _onTimeChangePressed(
                            controller: breakTimeController,
                          ),
                          validator: (value) => _validatorMessage(
                            value!,
                            'Jam Mulai Istirahat harus di isi',
                          ),
                        ),
                        const Gap(20),
                        TextfieldForm(
                          controller: breakTimeEndController,
                          prefixIcon: Icon(Iconsax.clock_copy),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          labelText: 'Jam Selesai Istirahat',
                          readOnly: true,
                          onTap: () => _onTimeChangePressed(
                            controller: breakTimeEndController,
                          ),
                          validator: (value) => _validatorMessage(
                            value!,
                            'Jam Selesai Istirahat harus di isi',
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                  );
                }
              }
            }),
            const Gap(20),
            Button1(
              title: 'Kirim pengajuan',
              onTap: () async {
                if (isFlexible.value) {
                  if (!formKey.currentState!.validate()) return;

                  Variables().loading(message: 'Mengirim pengajuan...');

                  await submitSubmissionShiftFlex(
                    shiftId: newShift!.id!,
                    scheduleIn: checkInController.text.trim(),
                    scheduleOut: checkOutController.text.trim(),
                    breakStart: breakTimeController.text.trim(),
                    breakEnd: breakTimeEndController.text.trim(),
                    period: DateFormat(
                      'yyyy-MM-dd',
                      'id_ID',
                    ).format(_selectedDate),
                  );
                } else {
                  if (dateController.text.isEmpty) {
                    // jika belum memilih tanggal ganti shift
                    _getSnackBar('Tgl. absen harus dipilih');
                    return;
                  }

                  if (newShiftController.text.isEmpty) {
                    // jika belum memilih shift baru
                    _getSnackBar('Shift baru harus dipilih');
                    return;
                  }

                  if (alasanController.text.isEmpty) {
                    // jika alasan pengajuan kosong
                    _getSnackBar('Alasan pengajuan harus di isi');
                    return;
                  }

                  Variables().loading(message: 'Mengirim pengajuan...');

                  await submitSubmissionShift(
                    shiftIdOld: selectedShift.id!,
                    shiftIdNew: newShift!.id!,
                    notes: alasanController.text,
                    approvalLine: m.u.value.job!.approvalShift!,
                    dateRequestFor: DateFormat(
                      'yyyy-MM-dd',
                      'id_ID',
                    ).format(_selectedDate),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _getSnackBar(
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Alasan pengajuan harus di isi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  String? _validatorMessage(String value, String message) {
    if (value.isEmpty) {
      return message;
    }
    return null;
  }

  void _onTimeChangePressed({required TextEditingController controller}) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    ).then((value) {
      if (value != null) {
        controller.text = DateFormat('HH:mm:ss').format(
          DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            value.hour,
            value.minute,
          ),
        );
      }
    });
  }

  Future<void> showOptionShift() async {
    Get.closeCurrentSnackbar();

    await showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: false,
      scrollControlDisabledMaxHeightRatio: 0.8,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            TextfieldForm(
              controller: searchController,
              hintText: "contoh: dayoff",
              labelText: "Cari shift",
              prefixIcon: Icon(Iconsax.search_normal_1_copy),
              onChanged: (value) {
                // Cancel any existing timer to prevent duplicate calls
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                // Set a new timer that triggers fetchShift after a delay
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  fetchShift(value, selectedDate: _selectedDate);
                  setState(() {}); // Trigger rebuild after fetching
                });
              },
            ),
            Obx(
              () => (listShift.isEmpty)
                  ? const Expanded(
                      child: Center(
                        child: CustomEmptySubmission(
                          title: "Tidak ada shift",
                          subtitle: 'Belum ada shift yang di setting oleh HRD.',
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listShift.length,
                        itemBuilder: (context, index) {
                          Shift shift = listShift[index];
                          return ListTile(
                            onTap: () {
                              newShift = shift;
                              isFlexible.value = newShift!.isFlexible == 1
                                  ? true
                                  : false;
                              newShiftController.text =
                                  "${shift.shiftName!} (${h.timeOfDayFormat(shift.scheduleIn)} - ${h.timeOfDayFormat(shift.scheduleOut)})";
                              Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 10,
                            ),
                            title: Text(
                              shift.shiftName!,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              "(${h.timeOfDayFormat(shift.scheduleIn)} - ${h.timeOfDayFormat(shift.scheduleOut)})",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void showDatePickerCalendar() {
    Get.closeCurrentSnackbar();

    showDatePicker(
      context: context,
      locale: Locale("id", "ID"),
      firstDate: DateTime.now(),
      initialDate: _selectedDate,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((value) async {
      if (value != null) {
        Variables().loading();

        selectedShift = await selectedDate(value.toIso8601String());

        dateController.text = DateFormat("dd MMMM yyyy", "id_ID").format(value);
        _selectedDate = value;
        fetchShift('', selectedDate: _selectedDate);

        if (selectedShift.dayoff == '0') {
          oldShiftController.text =
              "${selectedShift.shiftName!} (${h.timeOfDayFormat(selectedShift.scheduleIn)} - ${h.timeOfDayFormat(selectedShift.scheduleOut)})";
        } else {
          oldShiftController.text =
              "${selectedShift.shiftName!} (00:00 - 00:00)";
        }

        Get.back();
        setState(() {});
      }
    });
  }

  Future submitSubmissionShift({
    required String shiftIdOld,
    required String shiftIdNew,
    required String notes,
    required String approvalLine,
    required String dateRequestFor,
  }) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/submit/change/shift'),
    );

    request.fields.addAll({
      'shift_id_old': shiftIdOld,
      'shift_id_new': shiftIdNew,
      'notes': notes,
      'approval_line': approvalLine,
      'date_request_for': dateRequestFor,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final str = await response.stream.bytesToString();
    final jsonR = json.decode(str);

    if (response.statusCode == 201) {
      Get.back();
      Get.back();

      Snackbar().snackbar1(
        'Informasi',
        jsonR['message'],
        Icons.check,
        Colors.white,
        Colors.amber,
      );
    } else {
      Get.back();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Informasi'),
          content: Text(jsonR['message']),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future submitSubmissionShiftFlex({
    required String shiftId,
    required String scheduleIn,
    required String scheduleOut,
    required String breakStart,
    required String breakEnd,
    required String period,
  }) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/submit/flexible/shift'),
    );

    debugPrint('Url => ${request.url}');

    request.fields.addAll({
      'shift_id': shiftId,
      'schedule_in': scheduleIn,
      'schedule_out': scheduleOut,
      'break_start': breakStart,
      'break_end': breakEnd,
      'period': period,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final str = await response.stream.bytesToString();
    final jsonR = json.decode(str);

    if (response.statusCode == 200) {
      Get.back();
      Get.back();

      Snackbar().snackbar1(
        'Informasi',
        jsonR['message'],
        Icons.check,
        Colors.white,
        Colors.amber,
      );
    } else {
      Get.back();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Informasi'),
          content: Text(jsonR['message']),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future selectedDate(String date) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/user/check/shift?date=$date'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonR = json.decode(str);

      // debugPrint('URL: ${request.url}');
      // debugPrint('Response Status Code: ${response.statusCode}');
      // debugPrint('Response Body Attendance: ${jsonR}');

      if (jsonR['data'] == null) {
        if (Get.isDialogOpen!) Get.back();
        DialogCustom().dialog(title: 'Gagal!', subtitle: jsonR['message'], onTap: () => Get.back());
        return;
      }
      selectedShift = Shift.fromMap(jsonR['data']);
      return selectedShift;
    } else {
      debugPrint(response.reasonPhrase);
    }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      DialogCustom().dialog(title: "Gagal", subtitle: e.toString(), onTap: () => Get.back());
    }
  }

  Future fetchShift(String name, {required DateTime selectedDate}) async {
    var date = DateFormat('yyyy-MM-dd').format(selectedDate);
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/user/shifts?date=$date&name=$name'),
    );

    request.headers.addAll(headers);
    debugPrint('Fetching shifts for date: $date with name filter: $name');

    try {
      http.StreamedResponse response = await request.send();

      debugPrint('URL: ${request.url}');
      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${await response.stream.bytesToString()}');

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final result = ListShiftResponseModel.fromJson(str);
        listShift.value = result.data!;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      CustomDialog(title: "Gagal", content: e.toString());
    }
  }
}
