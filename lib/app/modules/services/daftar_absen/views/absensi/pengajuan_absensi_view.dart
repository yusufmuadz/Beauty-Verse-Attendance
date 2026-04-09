import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/model_controller.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/selected_date_response_model.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/snackbar/snackbar_1.dart';
import '../../../../../shared/textfieldform.dart';
import '../../../../../shared/utils.dart';
import '../daftar_absen_view.dart';

class PengajuanAbsensiView extends StatefulWidget {
  const PengajuanAbsensiView({super.key});

  @override
  State<PengajuanAbsensiView> createState() => _PengajuanAbsensiViewState();
}

class _PengajuanAbsensiViewState extends State<PengajuanAbsensiView> {
  final m = Get.find<ModelController>();

  final dateController = TextEditingController();
  final alasanController = TextEditingController();
  final clockinController = TextEditingController();
  final clockoutController = TextEditingController();
  final clockinControllerInput = TextEditingController();
  final clockoutControllerInput = TextEditingController();

  String hiddenClockIn = '';
  String hiddenClockOut = '';

  RxBool isButtonEnable = false.obs;
  RxBool isButtonClicked = false.obs;

  RxBool clock_in_check_box = false.obs;
  RxBool clock_out_check_box = false.obs;

  var _selectedDate = DateTime.now();

  final _selectedDateKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(clockinController.text);
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Presensi'), titleSpacing: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const Gap(15),
            Form(
              key: _selectedDateKey,
              child: TextfieldForm(
                controller: dateController,
                labelText: 'Tanggal',
                hintText: 'Masukan tanggal',
                fillColor: Colors.white70,
                prefixIcon: Icon(Iconsax.calendar_1_copy),
                filled: true,
                readOnly: true,
                onTap: () {
                  isButtonEnable(false);
                  showDatePicker(
                    context: context,
                    locale: Locale("id", "ID"),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light(useMaterial3: false).copyWith(
                          datePickerTheme: DatePickerThemeData(
                            backgroundColor: Colors.white,
                            headerBackgroundColor: Colors.amber.shade900,
                            rangePickerHeaderHeadlineStyle:
                                GoogleFonts.figtree(),
                            rangePickerHeaderHelpStyle: GoogleFonts.figtree(),
                            cancelButtonStyle: ButtonStyle(
                              textStyle: WidgetStatePropertyAll(
                                GoogleFonts.figtree(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            confirmButtonStyle: ButtonStyle(
                              textStyle: WidgetStatePropertyAll(
                                GoogleFonts.figtree(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    firstDate: DateTime.now().add(const Duration(days: -30)),
                    initialDate: _selectedDate,
                    lastDate: DateTime.now(),
                  ).then(
                    (value) => setState(() {
                      if (value == null) return;
                      _selectedDate = value;
                      dateController.text = DateFormat(
                        'yyyy-MM-dd',
                        'id_ID',
                      ).format(value);
                    }),
                  );

                  clock_in_check_box(false);
                  clock_out_check_box(false);
                  clockinControllerInput.text = '';
                  clockoutControllerInput.text = '';
                },
                validator: (validator) {
                  if (validator!.isEmpty) {
                    return 'Pilih tanggal terlebih dahulu';
                  }
                  return null;
                },
              ),
            ),
            const Gap(10),
            FutureBuilder(
              future: getScheduleSelected(dateController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextfieldForm(
                              prefixIcon: Icon(Iconsax.clock_copy),
                              controller: clockinController,
                              labelText: 'Clock in',
                              readOnly: true,
                            ),
                          ),
                          const Gap(10),
                          Flexible(
                            child: TextfieldForm(
                              prefixIcon: Icon(Iconsax.clock_copy),
                              controller: clockoutController,
                              labelText: 'Clock out',
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  SelectedDateResponseModel data =
                      snapshot.data ?? SelectedDateResponseModel();

                  // initial
                  clockinController.text = data.clockin == null
                      ? ''
                      : DateFormat(
                          'HH:mm',
                          'id_ID',
                        ).format(data.clockin!.createdAt!);
                  clockoutController.text = data.clockout == null
                      ? ''
                      : DateFormat(
                          'HH:mm',
                          'id_ID',
                        ).format(data.clockout!.createdAt!);
                  // == end

                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextfieldForm(
                              prefixIcon: Icon(Iconsax.clock_copy),
                              controller: clockinController,
                              hintText: 'Clock in',
                              readOnly: true,
                            ),
                          ),
                          const Gap(10),
                          Flexible(
                            child: TextfieldForm(
                              prefixIcon: Icon(Iconsax.clock_copy),
                              controller: clockoutController,
                              hintText: 'Clock out',
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                    ],
                  );
                }

                return SizedBox();
              },
            ),
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: clock_in_check_box.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(width: 1, color: Colors.grey),
                    onChanged: (value) async {
                      if (!_selectedDateKey.currentState!.validate()) {
                        return;
                      }

                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }

                      if (!clockinController.text.contains(':') &&
                          clockoutControllerInput.text.isNotEmpty) {
                        /**
                           * jika clockin kosong dan juga belum melakukan clockin sebelumnya maka tidak bisa mengajukan clock-out
                           */
                        clockoutControllerInput.text = '';
                        clock_out_check_box.value = false;
                      }

                      if (value == false) {
                        clockinControllerInput.text = '';
                        hiddenClockIn = '';
                        clock_in_check_box.value = value!;
                      } else {
                        // final TimeOfDay? picked = await showTimePicker(
                        //   context: context,
                        //   initialEntryMode: TimePickerEntryMode.inputOnly,
                        //   initialTime: TimeOfDay.now(),
                        // );
                        await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          initialTime: m.todayShift.value.scheduleIn == null
                              ? TimeOfDay.now()
                              : TimeOfDay(
                                  hour: int.parse(
                                    '${m.todayShift.value.scheduleIn![0]}${m.todayShift.value.scheduleIn![1]}',
                                  ),
                                  minute: int.parse(
                                    '${m.todayShift.value.scheduleIn![3]}${m.todayShift.value.scheduleIn![4]}',
                                  ),
                                ),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              // alwaysUse24HourFormat: true,
                              viewInsets: EdgeInsets.zero,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            child: child ?? const SizedBox.shrink(),
                          ),
                        ).then((value) {
                          // if (value == null) return;
                          String formattedTime =
                              '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                          clockinControllerInput.text = formattedTime;
                        });

                        clock_in_check_box.value = value!;
                      }
                    },
                  ),
                  Flexible(
                    child: TextfieldForm(
                      controller: clockinControllerInput,
                      readOnly: true,
                      labelText: 'Edit Clock in',
                      suffixIcon: Icon(Iconsax.edit_copy),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(width: 1, color: Colors.grey),
                    value: clock_out_check_box.value,
                    onChanged: (value) async {
                      if (!_selectedDateKey.currentState!.validate()) {
                        return;
                      }

                      if (Get.isDialogOpen!) {
                        Navigator.pop(context);
                      }

                      if (value == false) {
                        clockoutControllerInput.text = '';
                        hiddenClockOut = '';
                      }

                      if (!clockinController.text.contains(':') &&
                          clockinControllerInput.text.isEmpty) {
                        /**
                           * jika clockin kosong dan juga belum melakukan clockin sebelumnya maka tidak bisa mengajukan clock-out
                           */
                        Snackbar().snackbar1(
                          'Informasi',
                          'Anda harus mengajukan Clock-In terlebih dahulu',
                          null,
                          Colors.white,
                          Colors.orange,
                        );
                        return;
                      }

                      if (value!) {
                        await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                          initialTime: m.todayShift.value.scheduleOut == null
                              ? TimeOfDay.now()
                              : TimeOfDay(
                                  hour: int.parse(
                                    '${m.todayShift.value.scheduleOut![0]}${m.todayShift.value.scheduleOut![1]}',
                                  ),
                                  minute: int.parse(
                                    '${m.todayShift.value.scheduleOut![3]}${m.todayShift.value.scheduleOut![4]}',
                                  ),
                                ),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              // alwaysUse24HourFormat: true,
                              viewInsets: EdgeInsets.zero,
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            child: child ?? const SizedBox.shrink(),
                          ),
                        ).then((value) {
                          String formattedTime =
                              value!.hour.toString().padLeft(2, '0') +
                              ':' +
                              value.minute.toString().padLeft(2, '0');

                          clockoutControllerInput.text = formattedTime;
                        });
                      }

                      clock_out_check_box.value = value;
                    },
                  ),
                  Flexible(
                    child: TextfieldForm(
                      controller: clockoutControllerInput,
                      suffixIcon: Icon(Iconsax.edit_copy),
                      readOnly: true,
                      labelText: 'Edit Clock out',
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            TextfieldForm(
              controller: alasanController,
              hintText: 'contoh: kuota habis',
              labelText: 'Alasan',
              maxLines: 1,
              prefixIcon: Icon(Iconsax.text_copy),
            ),
            const Gap(10),
            TextfieldForm(
              controller: fileC,
              hintText: 'Unggah file',
              labelText: 'File',
              readOnly: true,
              prefixIcon: Icon(Iconsax.folder_cloud_copy),
              onTap: () async {
                if (files.length >= 1) {
                  Snackbar().snackbar1(
                    'Informasi!',
                    'hanya 1 file yang dapat diupload',
                    Iconsax.folder_copy,
                    Colors.white,
                    Colors.orange,
                  );
                  return;
                }
                await _pickFileFrom();
              },
            ),
            const Gap(10),
            Obx(
              () => Wrap(
                children: List.generate(
                  files.length,
                  (index) => Stack(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        margin: const EdgeInsets.all(5),
                        child: Image.file(
                          File(files[index].path),
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: redColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.document_text_copy,
                                      color: redColor,
                                    ),
                                    Text(
                                      'Pdf',
                                      style: TextStyle(
                                        fontWeight: semiBold,
                                        color: redColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            files.removeAt(index);
                            fileC.text = '${files.length} file';
                            if (files.isEmpty) {
                              fileC.text = '';
                            }
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Icon(
                              Iconsax.minus_cirlce,
                              color: redColor.withAlpha(200),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(10),
            Obx(
              () => (isButtonEnable.value)
                  ? Button1(title: 'Kirim Pengajuan', onTap: _submitAttendance)
                  : const SizedBox(),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAttendance() async {
    log('submit attendance');
    if (isButtonClicked.value) return;
    isButtonClicked.value = true;

    Variables().loading(message: 'mengirimkan presensi');

    if (alasanController.text.isEmpty) {
      Get.back();
      isButtonClicked.value = false;
      Snackbar().snackbar1(
        'Gagal',
        'Alasan wajib diisi',
        Iconsax.information_copy,
        Colors.white,
        Colors.red,
      );
      return;
    }

    if (clockinControllerInput.text.isEmpty &&
        clockoutControllerInput.text.isEmpty) {
      Get.back();
      isButtonClicked.value = false;
      Snackbar().snackbar1(
        'Gagal',
        'Clock-in atau Clock-out wajib diisi',
        Iconsax.information_copy,
        Colors.white,
        Colors.red,
      );
      return;
    }

    bool result = await submitSubmissionAttendance();

    if (result) {
      Get.off(() => DaftarAbsenView(), arguments: 'menu');
    }

    isButtonClicked.value = false;
  }

  Future<bool> submitSubmissionAttendance() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/submission/attendance/submit'),
      );

      request.fields.addAll({
        'date_request_for': dateController.text, // tanggal pengajuan
        'clockin_time': clockinControllerInput.text, // jam pengajuan clock-in
        'clockout_time':
            clockoutControllerInput.text, // jam pengajuan clock-out
        'reason_request': alasanController.text, // alasan pengajuan
      });

      if (files.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('file', files[0].path),
        );
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        final data = await response.stream.bytesToString();
        final jsonR = json.decode(data);

        Snackbar().snackbar1(
          'Berhasil',
          jsonR['message'],
          Iconsax.information_copy,
          Colors.white,
          Colors.amber,
        );
        return true;
      } else {
        final data = await response.stream.bytesToString();
        final jsonR = json.decode(data);

        Get.back();
        Get.dialog(
          AlertDialog(
            title: Text(
              'Gagal..!',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              jsonR['message'],
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        log('submit submission attendance => $e');
      }
      return false;
    }
  }

  RxList<XFile> files = RxList<XFile>();
  TextEditingController fileC = TextEditingController();

  Future<void> _pickFileFrom() async {
    ImagePicker picker = ImagePicker();

    Get.dialog(
      AlertDialog(
        content: SizedBox(
          width: Get.width,
          height: Get.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Tambahkan Lampiran',
                style: TextStyle(fontWeight: bold, fontSize: 16),
              ),
              SizedBox(
                height: 40,
                child: Button1(
                  title: 'Kamera',
                  onTap: () async {
                    XFile? file = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    files.add(file!);
                    fileC.text = '${files.length} file';
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: Button1(
                  title: 'Galeri',
                  onTap: () async {
                    XFile? file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    files.add(file!);
                    fileC.text = '${files.length} file';
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: Button1(
                  title: 'File',
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles();

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      files.add(XFile(file.path));
                    }
                    fileC.text = '${files.length} file';

                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getScheduleSelected(String date) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    log(date);
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v2/testing/find/date?date=$date'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final results = SelectedDateResponseModel.fromJson(
        await response.stream.bytesToString(),
      );

      isButtonEnable(true);
      return results;
    } else if (response.statusCode != 200) {
      final str = await response.stream.bytesToString();
      final data = json.decode(str);

      Snackbar().snackbar1(
        'Peringatan',
        data['message'],
        Iconsax.information_copy,
        Colors.white,
        Colors.red,
      );

      isButtonEnable(false);
    } else {
      debugPrint('${response.reasonPhrase}');
    }
  }
}
