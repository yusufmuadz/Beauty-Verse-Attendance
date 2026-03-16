// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/model_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/button/button_1.dart';
import '../../../shared/utils.dart';
import '../../services/daftar_absen/views/daftar_absen_view.dart';

class DetailStatusAttendanceView extends StatefulWidget {
  const DetailStatusAttendanceView({super.key});

  @override
  State<DetailStatusAttendanceView> createState() =>
      _DetailStatusAttendanceViewState();
}

class _DetailStatusAttendanceViewState
    extends State<DetailStatusAttendanceView> {
  late DateTime sDate;
  late bool status = false;
  late String type = '';
  late DateTime time = DateTime.now();
  final m = Get.find<ModelController>();

  @override
  void initState() {
    super.initState();
    status = Get.arguments['status'];
    type = Get.arguments['type'];
    sDate = Get.arguments["time"] as DateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img_siap.png'),
            fit: BoxFit.cover,
            opacity: 0.28,
          ),
        ),
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.tick_square,
                    size: 100,
                    color: status ? Colors.red : Colors.amber,
                  ),
                  const Gap(15),
                  Text(
                    '${DateFormat('HH:mm').format(sDate)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: bold,
                      color: status ? Colors.red : Colors.amber,
                    ),
                  ),
                  const Gap(15),
                  Text(
                    'Anda Berhasil Absensi',
                    style: TextStyle(fontWeight: medium, fontSize: 16),
                  ),
                  const Gap(15),
                  _typeAttendance(type: type),
                  const Gap(15),
                  Text(
                    (m.todayShift.value.scheduleIn == null)
                        ? '${m.todayShift.value.shiftName}'
                        : '${m.todayShift.value.shiftName} (${m.todayShift.value.scheduleIn!.substring(0, 5)} - ${m.todayShift.value.scheduleOut!.substring(0, 5)})',
                    style: TextStyle(fontSize: 16, fontWeight: regular),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Button1(
                showOutline: true,
                outlineColor: Colors.amber.shade800,
                color: Colors.amber.shade800,
                backgroundColor: whiteColor,
                title: 'Daftar Absen',
                onTap: () {
                  Get.off(() => DaftarAbsenView());
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: Button1(
                title: 'Home',
                onTap: () {
                  Get.offAllNamed(Routes.HOME);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _typeAttendance({required String type}) {
    String ket = '';

    switch (type) {
      case 'clockin':
        ket = 'Clock-In';
        break;
      case 'clockout':
        ket = 'Clock-Out';
        break;
      default:
        break;
    }
    return Text(ket, style: TextStyle(fontSize: 16, fontWeight: medium));
  }
}
