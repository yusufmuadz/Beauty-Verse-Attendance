import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/shift.dart';

class LemburController extends GetxController {
  RxBool isClicked = true.obs;
  RxString title = "Kirim pengajuan".obs;

  RxInt monthC = DateTime.now().month.obs;
  RxInt yearC = DateTime.now().year.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> jamMasuk = TimeOfDay.now().obs;
  Rx<TimeOfDay> jamKeluar = TimeOfDay.now().obs;
  Rx<Shift> todayShift = Shift().obs;

  RxBool isHoliday = false.obs;

  // dayoff
  final dateController = TextEditingController();
  final shiftController = TextEditingController();
  final jadwalMasukController = TextEditingController(text: "00:00");
  final jadwalKeluarController = TextEditingController(text: "00:00");
  final durasiLemburController = TextEditingController(text: "00:00");
  final durasiIstirahatController = TextEditingController(text: "00:00");
  final catatanKerjaController = TextEditingController();

  // dayin sebelum shift
  final jadwalMasukSebelumShift = TextEditingController();
  final jadwalKeluarSebelumShift = TextEditingController();
  final durasiLemburSebelumShift = TextEditingController(text: '00:30');
  final durasiIstirahatSebelumShift = TextEditingController(text: '00:30');

  Rx<TimeOfDay> jamMasukA = TimeOfDay.now().obs;
  Rx<TimeOfDay> jamKeluarA = TimeOfDay.now().obs;

  // dayin sesudah shift
  final jadwalMasukSesudahShift = TextEditingController();
  final jadwalKeluarSesudahShift = TextEditingController();
  final durasiLemburSesudahShift = TextEditingController();
  final durasiIstirahatSesudahShift = TextEditingController();

  Rx<TimeOfDay> jamMasukB = TimeOfDay.now().obs;
  Rx<TimeOfDay> jamKeluarB = TimeOfDay.now().obs;

  @override
  void dispose() {
    dateController.clear();
    super.dispose();
  }
}
