import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/core/components/detail_absensi_bottom_sheet.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/submission_attendance_response_model.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/detail_absensi_view.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/pengajuan_absensi_view.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';

import '../../../../shared/textfield/textfield_1.dart';
import '../../../../shared/utils.dart';

class DaftarAbsenAbsensiView extends StatefulWidget {
  DaftarAbsenAbsensiView({Key? key}) : super(key: key);

  @override
  State<DaftarAbsenAbsensiView> createState() => _DaftarAbsenAbsensiViewState();
}

class _DaftarAbsenAbsensiViewState extends State<DaftarAbsenAbsensiView> {
  TextEditingController calendarC = TextEditingController();

  int sYear = DateTime.now().year;
  int sMonth = DateTime.now().month;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    calendarC.text =
        '${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(_selectedDate.year, _selectedDate.month))}';
  }

  @override
  Widget build(BuildContext context) {
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
                    calendarC.text =
                        '${DateFormat('MMMM yyyy ', 'id_ID').format(DateTime(year, month))}';
                  });
                },
                initialSelectedMonth: sMonth,
                initialSelectedYear: sYear,
                firstYear: 2000,
                lastYear: 2025,
                selectButtonText: 'OK',
                cancelButtonText: 'Cancel',
                highlightColor: Colors.amber,
                textColor: Colors.black,
                contentBackgroundColor: Colors.white,
                dialogBackgroundColor: Colors.grey[200],
              );
            },
          ),
        ),
        FutureBuilder(
          future: fetchSubmissionByUserId(
            '${DateFormat('yyyy-MM ', 'id_ID').format(DateTime(sYear, sMonth, DateTime.now().day))}',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return skletonizerEmpty();
            } else if (snapshot.hasData) {
              SubmissionApprovalResponseModel request = snapshot.data;

              if (request.submission!.isEmpty) {
                return Expanded(
                  child: CustomEmptySubmission(title: 'Belum ada pengajuan'),
                );
              }

              request.submission!.sort(
                (a, b) => b.dateRequest!.compareTo(a.dateRequest!),
              );

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  itemCount: request.submission!.length,
                  itemBuilder: (context, index) {
                    Submission data = request.submission![index];
                    return CustomTileStatus(
                      onTap: () async {
                        await Get.to(
                          () => DetailPengajuanAbsensi(),
                          arguments: data,
                        );
                        setState(() {});
                      },
                      status: data.status ?? "Pending",
                      mainTitle: "Tanggal pengajuan",
                      mainSubtitle:
                          "${DateFormat('dd MMMM', 'id_ID').format(data.dateRequest!)}",
                      secTitle: "Pengajuan untuk",
                      secSubtitle:
                          "${data.clockinTime == null ? '' : 'Clock-In'}${data.clockinTime != null && data.clockoutTime != null ? ' & ' : ''}${data.clockoutTime == null ? '' : 'Clock-Out'}",
                      thirdTitle: "Untuk tanggal",
                      thirdSubtitle:
                          (data.clockinTime == null &&
                              data.clockoutTime == null)
                          ? ''
                          : "${DateFormat('dd MMM yyyy', 'id_ID').format(data.dateRequestFor!)}, ${_formatDate(data.clockinTime == null ? data.clockoutTime : data.clockinTime)}",
                    );
                  },
                ),
              );
            }
            return const Expanded(child: const CustomEmptySubmission());
          },
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Button1(
            title: 'Pengajuan Presensi',
            onTap: () async {
              await Get.to(() => PengajuanAbsensiView());
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Expanded skletonizerEmpty() {
    return Expanded(
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 6,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.amber.shade50.withOpacity(0.5),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Keputusan',
                            style: TextStyle(fontSize: 12, fontWeight: regular),
                          ),
                          const Gap(5),
                          Text(
                            '${DateFormat('MMMM dd, yyyy', 'id_ID').format(DateTime.now())}',
                            style: TextStyle(fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "disapproved",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.5, color: Colors.grey.shade300),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keputusan Oleh',
                            style: TextStyle(fontSize: 12, fontWeight: regular),
                          ),
                          const Gap(5),
                          Text(
                            " data.su",
                            style: TextStyle(fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Keputusan Oleh',
                            style: TextStyle(fontSize: 12, fontWeight: regular),
                          ),
                          const Gap(5),
                          Text(
                            "data.supe",
                            style: TextStyle(fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _formatDate(String time) {
    // Parsing string ke DateTime
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    // Mengubah ke format yang diinginkan
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  Future fetchSubmissionByUserId(String? date) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '${Variables.baseUrl}/v1/user/submission/attendance?date=$date',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final results = await response.stream.bytesToString();
      return SubmissionApprovalResponseModel.fromJson(results);
    } else {
      print(response.reasonPhrase);
    }
  }
}
