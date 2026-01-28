import 'package:flutter/material.dart';

import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';

import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/core/constant/time_format_schedule.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/change_shift_response_model.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/detail_pengajuan_shift.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/pengajuan_pergantian_shift_view.dart';

import '../../../../shared/button/button_1.dart';
import '../../../../shared/textfield/textfield_1.dart';
import '../../../../shared/utils.dart';

class DaftarAbsenShiftView extends StatefulWidget {
  const DaftarAbsenShiftView({super.key});

  @override
  State<DaftarAbsenShiftView> createState() => _DaftarAbsenShiftViewState();
}

class _DaftarAbsenShiftViewState extends State<DaftarAbsenShiftView> {
  TextEditingController calendarC = TextEditingController();

  int sYear = DateTime.now().year;
  int sMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    calendarC.text = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime(sYear, sMonth));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Column(
      children: [
        const Gap(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField1(
            readOnly: true,
            suffixIcon: Icon(Iconsax.arrow_down_1_copy, size: 15),
            preffixIcon: Icon(Iconsax.calendar_1_copy),
            fillColor: whiteColor,
            hintText: calendarC.text,
            controller: calendarC,
            onTap: () {
              showMonthPicker(
                context,
                onSelected: (month, year) {
                  sYear = year;
                  sMonth = month;

                  setState(() {
                    calendarC.text = DateFormat(
                      'MMMM yyyy',
                      'id_ID',
                    ).format(DateTime(year, month));
                  });
                },
                initialSelectedMonth: sMonth,
                initialSelectedYear: sYear,
                firstYear: 2000,
                lastYear: 2025,
                selectButtonText: 'OK',
                cancelButtonText: 'Cancel',
                highlightColor: Colors.amber.shade900,
                textColor: Colors.black,
                contentBackgroundColor: Colors.white,
                dialogBackgroundColor: Colors.grey[200],
              );
            },
          ),
        ),
        FutureBuilder(
          future: initShiftChange(
            DateFormat('yyyy-MM', 'id_ID').format(DateTime(sYear, sMonth)),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Expanded(child: Variables().loadingWidget());
            } else if (snapshot.hasData) {
              final ChangeShiftResponseModel data = snapshot.data!;
              if (data.data!.isEmpty) {
                return const Expanded(
                  child: CustomEmptySubmission(
                    title: "Belum ada pengajuan",
                    subtitle:
                        "Belum ada pengajuan shift, silahkan ajukan pergantian shift jika diperlukan!",
                  ),
                );
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15.0),
                    itemCount: data.data!.length,
                    itemBuilder: (context, index) {
                      final ChangeShift shift = data.data![index];

                      return CustomTileStatus(
                        onTap: () async {
                          if (shift.id!.isEmpty) {
                            Get.closeCurrentSnackbar();
                            Get.rawSnackbar(
                              backgroundColor: Colors.orange,
                              titleText: Text(
                                'Pemberitahuan',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              messageText: Text(
                                'Shift flexible tidak perlu proses persetujuan.',
                                style: GoogleFonts.outfit(color: Colors.white),
                              ),
                            );
                            return;
                          }

                          await Get.to(
                            DetailPengajuanShiftView(),
                            arguments: shift,
                          );
                          setState(() {});
                        },
                        status: shift.status!,
                        mainTitle: 'Pengajuan untuk tanggal',
                        mainSubtitle: DateFormat(
                          'dd MMM yyyy',
                          'id_ID',
                        ).format(shift.dateRequestFor!),
                        secTitle: 'Shift lama',
                        secSubtitle: settingShiftAndSchedule(shift, 'old'),
                        thirdTitle: 'Shift baru',
                        thirdSubtitle: settingShiftAndSchedule(shift, 'new'),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const Expanded(child: CustomEmptySubmission());
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Button1(
            title: 'Pengajuan Shift',
            onTap: () async {
              await Get.to(() => PengajuanPergantianShiftView());
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  String settingShiftAndSchedule(ChangeShift shift, String type) {
    String scheduleInNew = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleInNew ?? '00:00:00',
    );
    String scheduleOutNew = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleOutNew ?? '00:00:00',
    );

    if (type == 'new') {
      return '${shift.shiftNameNew} ($scheduleInNew-$scheduleOutNew)';
    }

    String scheduleInOld = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleInOld ?? '00:00:00',
    );
    String scheduleOutOld = TimeFormatSchedule().timeOfDayFormat(
      shift.scheduleOutOld ?? '00:00:00',
    );
    return '${shift.shiftNameOld} ($scheduleInOld-$scheduleOutOld)';
  }

  Future initShiftChange(String date) async {
    final m = Get.find<ModelController>();

    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/user/fetch/change/shift?date=$date'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final shifts = ChangeShiftResponseModel.fromJson(str);
      return shifts;
    } else {
      print(response.reasonPhrase);
    }
  }
}
