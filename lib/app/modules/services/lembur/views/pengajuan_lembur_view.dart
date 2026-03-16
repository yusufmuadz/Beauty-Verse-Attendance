// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../controllers/model_controller.dart';
import '../../../../core/components/custom_tile_status.dart';
import '../../../../core/components/my_button.dart';
import '../../../../core/constant/variables.dart';
import '../../../../data/model/agreement_overtime_response_model.dart';
import '../../../../models/shift.dart';
import '../../../../shared/button/button_1.dart';
import '../../../../shared/dialog.dart';
import '../../../../shared/snackbar/snackbar_1.dart';
import '../../../../shared/textfield/textfield_1.dart';
import '../controllers/lembur_controller.dart';
import 'detail_pengajuan_lembur_user_view.dart';

class PengajuanLemburView extends StatefulWidget {
  const PengajuanLemburView({super.key});

  @override
  State<PengajuanLemburView> createState() => _PengajuanLemburViewState();
}

class _PengajuanLemburViewState extends State<PengajuanLemburView> {
  final controller = Get.put(LemburController());
  Shift selectedShift = Shift();
  final m = Get.find<ModelController>();

  @override
  void dispose() {
    controller.dateController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengajuan Lembur'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField1(
            controller: controller.dateController,
            isTextShowing: true,
            hintText: 'Pilih Tanggal',
            onTap: () async {
              controller.isHoliday(false);
              final date = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime.now().add(const Duration(days: -7)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                locale: const Locale('id', 'ID'),
              );

              if (date != null) {
                Variables().loading();
                await checkHoliday(DateFormat('yyyy-MM-dd').format(date));

                controller.selectedDate(date);
                selectedShift = await selectedDate(
                  DateFormat('yyyy-MM-dd').format(date),
                );

                controller.shiftController.text = (controller.isHoliday.value)
                    ? 'National Holiday'
                    : selectedShift.shiftName!;

                // remove all data
                controller.jadwalMasukController.clear();
                controller.jadwalKeluarController.clear();
                controller.durasiLemburController.clear();
                controller.durasiIstirahatController.clear();
                controller.catatanKerjaController.clear();

                // clear sebelum shift
                controller.jadwalKeluarSebelumShift.clear();
                controller.jadwalMasukSebelumShift.clear();
                controller.durasiLemburSebelumShift.clear();
                controller.durasiIstirahatSebelumShift.clear();

                // clear sesudah shift
                controller.jadwalKeluarSesudahShift.clear();
                controller.jadwalMasukSesudahShift.clear();
                controller.durasiLemburSesudahShift.clear();
                controller.durasiIstirahatSesudahShift.clear();

                setState(() {
                  controller.dateController.text = DateFormat(
                    'EEE, dd MMMM yyyy',
                    'id_ID',
                  ).format(date);
                });
                Get.back();
              }
            },
            preffixIcon: const Icon(Iconsax.calendar_1_copy),
            suffixIcon: (controller.dateController.text.isNotEmpty)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        controller.dateController.clear();
                      });
                    },
                    icon: const Icon(Icons.close),
                  )
                : const Icon(Icons.keyboard_arrow_down_rounded),
            readOnly: true,
          ),
          const Gap(10),
          if (controller.dateController.text.isNotEmpty)
            ...selectedInputField(selectedShift.dayoff!),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Button1(
                title: controller.title.value,
                onTap: () async {
                  if (controller.catatanKerjaController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Catatan kerja belum terisi, mohon lengkapi.",
                          style: GoogleFonts.varelaRound(),
                        ),
                        action: SnackBarAction(
                          label: 'Tutup',
                          onPressed: () => ScaffoldMessenger.of(
                            context,
                          ).hideCurrentSnackBar(),
                        ),
                      ),
                    );
                    return;
                  }

                  if (controller.dateController.value.text.isEmpty) {
                    Snackbar().snackbar1(
                      "Gagal",
                      "Pilih tanggal terlebih dahulu",
                      Iconsax.close_circle_copy,
                      Colors.white,
                      Colors.orange,
                    );
                    return;
                  }

                  if (controller.isClicked.value) {
                    controller.isClicked(false);
                    Variables().loading(message: 'Mengajukan lembur...');

                    await submitOvertime();

                    controller.isClicked(true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future checkHoliday(String date) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${Variables.baseUrl}/v1/user/check/lembur/holiday?date_request_for=$date',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      log(date);

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        if (str.isEmpty) {
          controller.isHoliday(false);
          return;
        }
        controller.isHoliday(true);
      } else {
        debugPrint(response.reasonPhrase);
        controller.isHoliday(false);
      }
    } catch (e) {
      controller.isHoliday(false);
    }
  }

  bool checkNextStep() {
    // Ambil semua nilai dari controller
    String durasiLemburSebelumShift = controller.durasiLemburSebelumShift.text;
    String durasiIstirahatSebelumShift =
        controller.durasiIstirahatSebelumShift.text;
    String durasiLemburSesudahShift = controller.durasiLemburSesudahShift.text;
    String durasiIstirahatSesudahShift =
        controller.durasiIstirahatSesudahShift.text;

    String jadwalMasuk = controller.jadwalMasukController.text;
    String jadwalKeluar = controller.jadwalKeluarController.text;
    String durasiLembur = controller.durasiLemburController.text;
    String durasiIstirahat = controller.durasiIstirahatController.text;

    // Cek apakah salah satu field tidak kosong
    if (durasiLemburSebelumShift.isNotEmpty ||
        durasiIstirahatSebelumShift.isNotEmpty ||
        durasiLemburSesudahShift.isNotEmpty ||
        durasiIstirahatSesudahShift.isNotEmpty ||
        jadwalMasuk.isNotEmpty ||
        jadwalKeluar.isNotEmpty ||
        durasiLembur.isNotEmpty ||
        durasiIstirahat.isNotEmpty) {
      // Jika salah satu tidak kosong, bisa melanjutkan ke step berikutnya
      debugPrint("Lanjut ke step berikutnya");
      return false;
      // Lanjut ke next step, bisa memanggil navigator atau logic yang sesuai
    } else {
      // Jika semua field kosong, tampilkan pesan error atau alert
      debugPrint("Harap isi minimal satu field untuk melanjutkan");
      return true;
    }
  }

  Future submitOvertime() async {
    if (checkNextStep()) {
      Get.back();
      Snackbar().snackbar1(
        "Gagal",
        "Harap isi minimal satu field untuk melanjutkan",
        Iconsax.close_circle_copy,
        Colors.white,
        Colors.orange,
      );
      return;
    }

    log(controller.durasiLemburSebelumShift.text);
    log(controller.durasiIstirahatSebelumShift.text);
    log(controller.durasiLemburSesudahShift.text);
    log(controller.durasiIstirahatSesudahShift.text);

    log(controller.jadwalMasukController.text);
    log(controller.jadwalKeluarController.text);
    log(controller.durasiLemburController.text);
    log(controller.durasiIstirahatController.text);

    if (m.u.value.job!.approvalLembur == null) {
      Get.back();

      Get.defaultDialog(
        radius: 12,
        title: 'INFORMASI',
        titleStyle: GoogleFonts.varelaRound(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        content: Text(
          'Anda perlu menghubungi personalia untuk mendapatkan line approval',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        confirm: Button1(title: 'Kembali', onTap: () => Get.back()),
      );
      controller.isClicked(true);
    }

    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/submit/lembur'),
      );

      log(m.u.value.job!.approvalLembur!);

      request.fields.addAll({
        'approval_line': m.u.value.job!.approvalLembur!,
        'date_request_for': controller.selectedDate.value.toIso8601String(),

        // shift
        'duration_before_shift': controller.durasiLemburSebelumShift.text,
        'duration_after_shift': controller.durasiLemburSesudahShift.text,
        'break_before_shift': controller.durasiIstirahatSebelumShift.text,
        'break_after_shift': controller.durasiIstirahatSesudahShift.text,

        // day off
        'time_in_dayoff': controller.jadwalMasukController.text,
        'time_out_dayoff': controller.jadwalKeluarController.text,
        'duration_overtime_dayoff': controller.durasiLemburController.text,
        'break_overtime_dayoff': controller.durasiIstirahatController.text,
        'notes': controller.catatanKerjaController.text,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        log(str.toString());
        final data = json.decode(str);
        bool status = data['status'];

        if (!status) {
          Get.back();

          if (data['data'] == null) {
            Get.dialog(
              barrierDismissible: false,
              AlertDialog(
                title: Text(
                  'INFORMASI',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  data['message'],
                  softWrap: true,
                  maxLines: 3,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actionsAlignment: MainAxisAlignment.end,
                actionsPadding: const EdgeInsets.only(bottom: 20),
                actions: [
                  MyButton(
                    txtBtn: 'Mengerti',
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            );
            return;
          }

          controller.isClicked(true);
          DetailOvertime detail = DetailOvertime.fromMap(data['data']);
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Anda sudah mengajukan lembur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(10),
                    CustomTileStatus(
                      onTap: () {
                        Get.back();
                        Get.back();
                        Get.to(
                          () => DetailPengajuanLemburUser(),
                          arguments: detail,
                        );
                      },
                      status: detail.status ?? 'Pending',
                      mainTitle: 'Diajukan pada',
                      mainSubtitle: DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(detail.createdAt!),
                      secTitle: 'Alasan Lembur',
                      secSubtitle: detail.notes ?? '-',
                      thirdTitle: 'Lembur untuk tanggal',
                      thirdSubtitle: DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(detail.dateRequestFor!),
                    ),
                  ],
                ),
              );
            },
          );

          return;
        }

        Get.back();
        Get.back();
        Snackbar().snackbar1(
          'Berhasil!',
          'Berhasil mengajukan lembur!',
          Iconsax.clock_1_copy,
          Colors.white,
          Colors.amber,
        );
      } else {
        Get.back();
        controller.isClicked(true);
      }
    } catch (e) {
      controller.isClicked(true);
    }
  }

  selectedInputField(String value) {
    if (value.isEmpty) {
      return const SizedBox();
    }

    if (value == '1' || controller.isHoliday.value) {
      // dayoff

      return [
        TextField1(
          hintText: 'Shift',
          isTextShowing: true,
          readOnly: true,
          controller: controller.shiftController,
        ),
        const Gap(10),
        TextField1(
          hintText: 'Jadwal Masuk',
          isTextShowing: true,
          requiredLabel: 'Wajib diisi',
          controller: controller.jadwalMasukController,
          readOnly: true,
          onTap: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input,
            );

            if (result != null) {
              controller.jamMasuk(result);

              controller.jadwalMasukController.text = time1FormatInput(
                result.format(context),
              );

              controller.durasiIstirahatController.text =
                  calculateDurationMinute(
                    int.parse(
                      timeChecker(
                        controller.jamMasuk.value.hour,
                        controller.jamMasuk.value.minute,
                        controller.jamKeluar.value.hour,
                        controller.jamKeluar.value.minute,
                      ),
                    ),
                  );
              setState(() {});
            }
          },
        ),
        TextField1(
          hintText: 'Jadwal Keluar',
          isTextShowing: true,
          controller: controller.jadwalKeluarController,
          requiredLabel: 'Wajib diisi',
          readOnly: true,
          onTap: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.input,
            );

            if (result != null) {
              controller.jamKeluar(result);
              controller.durasiIstirahatController.text =
                  controller.jadwalKeluarController.text = time1FormatInput(
                    result.format(context),
                  );

              controller.durasiLemburController.text = calculateDuration(
                controller.jadwalMasukController.text,
                controller.jadwalKeluarController.text,
              );
              controller.durasiIstirahatController.text =
                  calculateDurationMinute(
                    int.parse(
                      timeChecker(
                        controller.jamMasuk.value.hour,
                        controller.jamMasuk.value.minute,
                        controller.jamKeluar.value.hour,
                        controller.jamKeluar.value.minute,
                      ),
                    ),
                  );
              setState(() {});
            }
          },
        ),
        TextField1(
          hintText: 'Durasi Lembur',
          readOnly: true,
          isTextShowing: true,
          controller: controller.durasiLemburController,
        ),
        const Gap(10),
        TextField1(
          hintText: 'Durasi Istirahat',
          isTextShowing: true,
          controller: controller.durasiIstirahatController,
          textInputType: TextInputType.number,
          readOnly: true,
          onTap: () async {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialEntryMode: TimePickerEntryMode.input,
            ).then((value) {
              if (value != null) {
                controller.durasiIstirahatController.text = timeFormatInput(
                  value.format(context),
                );
              }
            });
          },
        ),
        const Gap(10),
        TextField1(
          hintText: 'Catatan Kerja',
          isTextShowing: true,
          controller: controller.catatanKerjaController,
        ),
      ];
    } else {
      // masuk

      return [
        TextField1(
          hintText: 'Shift',
          isTextShowing: true,
          readOnly: true,
          controller: controller.shiftController,
        ),
        const Gap(10),
        Text(
          "Sebelum Shift",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        TextField1(
          hintText: 'Durasi Lembur',
          readOnly: true,
          isTextShowing: true,
          controller: controller.durasiLemburSebelumShift,
          textInputType: TextInputType.number,
          onTap: () async {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialEntryMode: TimePickerEntryMode.input,
            ).then((value) {
              if (value != null) {
                controller.durasiLemburSebelumShift.text = timeFormatInput(
                  value.format(context),
                );
                controller.durasiIstirahatSebelumShift.text = timeFormatInput(
                  '00.30',
                );
              }
            });
          },
        ),
        const Gap(10),
        TextField1(
          hintText: 'Durasi Istirahat',
          isTextShowing: true,
          readOnly: true,
          controller: controller.durasiIstirahatSebelumShift,
          textInputType: TextInputType.number,
          onTap: () async {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialEntryMode: TimePickerEntryMode.input,
            ).then((value) {
              if (value != null) {
                controller.durasiIstirahatSebelumShift.text = timeFormatInput(
                  value.format(context),
                );
              }
            });
          },
        ),
        const Gap(10),
        Text(
          "Sesudah Shift",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        TextField1(
          hintText: 'Durasi Lembur',
          readOnly: true,
          isTextShowing: true,
          controller: controller.durasiLemburSesudahShift,
          textInputType: TextInputType.number,
          onTap: () async {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialEntryMode: TimePickerEntryMode.input,
            ).then((value) {
              if (value != null) {
                controller.durasiLemburSesudahShift.text = timeFormatInput(
                  value.format(context),
                );
                controller.durasiIstirahatSesudahShift.text = timeFormatInput(
                  "00.30",
                );
              }
            });
          },
        ),
        const Gap(10),
        TextField1(
          hintText: 'Durasi Istirahat',
          isTextShowing: true,
          readOnly: true,
          controller: controller.durasiIstirahatSesudahShift,
          textInputType: TextInputType.number,
          onTap: () async {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: 0, minute: 0),
              initialEntryMode: TimePickerEntryMode.input,
            ).then((value) {
              if (value != null) {
                controller.durasiIstirahatSesudahShift.text = timeFormatInput(
                  value.format(context),
                );
              }
            });
          },
        ),
        const Gap(10),
        TextField1(
          hintText: 'Catatan Kerja',
          isTextShowing: true,
          controller: controller.catatanKerjaController,
        ),
      ];
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

      // debugPrint('URL: ${request.url}');
      // debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final jsonR = json.decode(str);
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

      debugPrint('Error Pengajuan Lembur: $e');
    }
  }

  String timeFormatInput(String timeString) {
    // Pisahkan string berdasarkan titik untuk mendapatkan jam dan menit
    List<String> parts = timeString.split('.');
    int hours = int.parse(parts[0]); // Ambil bagian jam
    int minutes = int.parse(parts[1]); // Ambil bagian menit

    // Buat objek DateTime menggunakan jam dan menit
    DateTime dateTime = DateTime(0, 0, 0, hours, minutes);

    // Format ke bentuk "HH:mm:ss"
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

    return formattedTime;
  }

  String time1FormatInput(String timeString) {
    // Pisahkan string berdasarkan titik untuk mendapatkan jam dan menit
    List<String> parts = timeString.split('.');
    int hours = int.parse(parts[0]); // Ambil bagian jam
    int minutes = int.parse(parts[1]); // Ambil bagian menit

    // Buat objek DateTime menggunakan jam dan menit
    DateTime dateTime = DateTime(0, 0, 0, hours, minutes);

    // Format ke bentuk "HH:mm:ss"
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }

  String timeChecker(int jamA, int menitA, int jamB, int menitB) {
    DateTime now = controller.selectedDate.value;

    // Mendefinisikan waktu masuk dan keluar
    DateTime masuk = DateTime(now.year, now.month, now.day, jamA, menitA);
    DateTime keluar = DateTime(now.year, now.month, now.day, jamB, menitB);

    // Mendefinisikan waktu batas jam 12 siang dan jam 6 sore
    DateTime twelvePM = DateTime(now.year, now.month, now.day, 12, 0);
    DateTime sixPM = DateTime(now.year, now.month, now.day, 18, 0);

    // Variabel untuk menyimpan nilai tambahan
    int tambahan = 0;

    // Mengecek apakah rentang waktu antara masuk dan keluar melewati jam 12 siang atau jam 6 sore
    if ((masuk.isBefore(twelvePM) && keluar.isAfter(twelvePM))) {
      tambahan += 30;
    }
    if ((masuk.isBefore(sixPM) && keluar.isAfter(sixPM))) {
      tambahan += 30;
    }

    return '${tambahan}'; // Mengembalikan nilai tambahan dalam format string
  }

  String calculateDuration(String text, String text2) {
    if (text.isEmpty || text2.isEmpty) {
      return '0j 0m';
    }

    String start = text;
    String end = text2;

    int startHour = int.parse(start.substring(0, 2));
    int startMinute = int.parse(start.substring(3, 5));
    int endHour = int.parse(end.substring(0, 2));
    int endMinute = int.parse(end.substring(3, 5));

    int durationHour = endHour - startHour;
    int durationMinute = endMinute - startMinute;
    if (durationMinute < 0) {
      durationHour--;
      durationMinute += 60;
    }

    return timeFormatInput('${durationHour}.${durationMinute}');
  }

  String calculateDurationReturnMinute(String text, String text2) {
    if (text.isEmpty || text2.isEmpty) {
      return '0j 0m';
    }

    String start = text;
    String end = text2;

    int startHour = int.parse(start.substring(0, 2));
    int startMinute = int.parse(start.substring(3, 5));
    int endHour = int.parse(end.substring(0, 2));
    int endMinute = int.parse(end.substring(3, 5));

    // ignore: unused_local_variable
    int durationHour = endHour - startHour;
    int durationMinute = endMinute - startMinute;
    if (durationMinute < 0) {
      durationHour--;
      durationMinute += 60;
    }

    return durationMinute.toString();
  }

  String calculateDurationMinute(int totalMinutes) {
    if (totalMinutes < 0) {
      return '0j 0m'; // Validasi jika input kurang dari 0
    }

    int durationHour = totalMinutes ~/ 60; // Menghitung jumlah jam
    int durationMinute = totalMinutes % 60; // Menghitung sisa menit

    return timeFormatInput('${durationHour}.${durationMinute}');
  }
}
