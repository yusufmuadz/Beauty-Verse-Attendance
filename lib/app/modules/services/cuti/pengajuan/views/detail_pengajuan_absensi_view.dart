import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/model_controller.dart';
import '../../../../../core/components/my_button.dart';
import '../../../../../core/components/my_textfield.dart';
import '../../../../../core/constant/time_format_schedule.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/submission_attendance_response_model.dart';
import '../../../../../models/detail_atendance.dart';
import '../../../../../shared/attach/show_multiple_file.dart';
import '../../../../../shared/loading/loading1.dart';
import '../../../../../shared/utils.dart';

class DetailPengajuanAbsensiView extends StatefulWidget {
  const DetailPengajuanAbsensiView({super.key});

  @override
  State<DetailPengajuanAbsensiView> createState() =>
      _DetailPengajuanAbsensiViewState();
}

class _DetailPengajuanAbsensiViewState
    extends State<DetailPengajuanAbsensiView> {
  late Submission sub;
  late String idAttendance;
  Content? content;
  RxBool isShowing = false.obs;
  final contentNotNull = false.obs;
  final contentStatusLine = ''.obs;

  final m = Get.find<ModelController>();
  final keteranganC = TextEditingController();

  @override
  void initState() {
    super.initState();
    idAttendance = Get.arguments;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  Future fetchAttendanceById({required String idAttendance}) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/find/approval/attendance/$idAttendance'),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      debugPrint(
        'URL: ${Variables.baseUrl}/find/approval/attendance/$idAttendance',
      );
      debugPrint('Response Status Code: ${response.statusCode}');
      // debugPrint('Response Body: ${await response.stream.bytesToString()}');

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();

        final data = RespModelAttendance.fromJson(str);
        isShowing.value = true;
        if (data.content != null) {
          contentNotNull.value = true;
          contentStatusLine.value = data.content?.statusLine ?? '';
        }
        return data;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Detail Pengajuan Absensi'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(result: true),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Get.back(result: true);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder(
            future: fetchAttendanceById(idAttendance: this.idAttendance),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              } else if (snapshot.data == null) {
                return Center(child: Text('Tidak ada data'));
              } else if (snapshot.connectionState == ConnectionState.done) {
                RespModelAttendance detail =
                    snapshot.data as RespModelAttendance;
                Content content = detail.content!;
                this.content = detail.content!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: '-',
                              progressIndicatorBuilder:
                                  (context, url, progress) =>
                                      const CupertinoActivityIndicator(),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.account_circle_rounded),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${content.nama}',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Pengajuan Presensi',
                              style: TextStyle(
                                fontFamily: 'Figtree',
                                fontWeight: regular,
                                color: Colors.grey,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(11.5),
                    Text(
                      "Halo, kami ingin memberi tahu bahwa ${content.nama} telah mengirimkan permintaan kehadiran pada ${DateFormat('dd MMM yyyy', 'id_ID').format(content.dateRequestFor!)}. Mohon ditinjau, ya!",
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                    const Gap(20),
                    _tileDetailTimeOff('Shift', content.shift!.shiftName ?? ''),
                    if (content.shift!.scheduleIn != null) ...[
                      _tileDetailTimeOff(
                        'Jam Kerja',
                        TimeFormatSchedule().timeOfDayFormat(
                              content.shift!.scheduleIn!,
                            ) +
                            ' - ' +
                            TimeFormatSchedule().timeOfDayFormat(
                              content.shift!.scheduleOut!,
                            ),
                      ),
                    ],
                    if (content.clockinTime != null) ...[
                      _tileDetailTimeOff(
                        'Pengajuan Clock In',
                        TimeFormatSchedule().timeOfDayFormat(
                          content.clockinTime!,
                        ),
                      ),
                    ],
                    if (content.clockoutTime != null) ...[
                      _tileDetailTimeOff(
                        'Pengajuan Clock Out',
                        TimeFormatSchedule().timeOfDayFormat(
                          content.clockoutTime!,
                        ),
                      ),
                    ],
                    _tileDetailTimeOff('Alasan', content.reasonRequest ?? '-'),
                    if (content.attachmentUrl != null) ...{
                      Text(
                        "Lampiran",
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(Loading1());
                          openFile(
                            url: content.attachmentUrl!,
                            name: content.attachmentUrl!.split('/').last,
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade900,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.document_scanner, color: Colors.white),
                              const Gap(3),
                              Text(
                                content.attachmentUrl!.split('.').last,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                    // if (sub.attachmentUrl != null) ...{
                    //   InkWell(
                    //     onTap: () {
                    //       Get.dialog(Loading1());
                    //       openFile(
                    //           url: sub.attachmentUrl!,
                    //           name: sub.attachmentUrl!.split('/').last);
                    //     },
                    //     child: Container(
                    //       width: 58,
                    //       height: 58,
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey.shade100,
                    //         borderRadius: BorderRadius.circular(5),
                    //         border: Border.all(width: 1.5, color: Colors.grey.shade200),
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(Iconsax.document_1_copy),
                    //           const Gap(5.0),
                    //           Text(
                    //             sub.attachmentUrl!.split('/').last,
                    //             style: TextStyle(fontSize: 10),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // },
                    const Gap(10),
                    if (content.statusLine != 'Pending')
                      Container(
                        width: Get.width,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: content.statusLine == 'Approved'
                              ? Colors.amber
                              : Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            'Anda ${content.statusLine == "Approved" ? 'Menyetujui' : 'Menolak'} Absensi ini',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(child: Text('terjadi kesalahan'));
              }
            },
          ),
        ),
      ),
      bottomSheet: Obx(() {
        // debugPrint('isShowing: ${isShowing.value}');
        // debugPrint('content: ${contentNotNull.value}');
        // debugPrint('statusLine: ${contentStatusLine.value}');
        // debugPrint(
        //   'statusLine: ${isShowing.value && !contentNotNull.value && contentStatusLine.value == "Pending"}',
        // );
        if (isShowing.value &&
            contentNotNull.value &&
            contentStatusLine.value == "Pending") {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, -1),
                  color: greyColor.withAlpha(25),
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextfield(
                  controller: keteranganC,
                  showTxt: false,
                  hintText: 'Contoh: Jangan di ulangi lagi yaa...',
                  prefix: Icon(Iconsax.note_1_copy),
                ),
                const Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        txtBtn: 'Tolak',
                        color: Colors.red,
                        onTap: () {
                          Get.dialog(Loading1());
                          _onPressed(0, content!.id!);
                        },
                      ),
                    ),
                    Expanded(
                      child: MyButton(
                        txtBtn: 'Setujui',
                        color: Colors.green,
                        onTap: () {
                          Get.dialog(Loading1());
                          _onPressed(1, content!.id!);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Future<void> _onPressed(int line_status, String idSubmission) async {
    approvePengajuanAttendance(line_status, idSubmission).then((value) {
      Get.back();
      Get.back(result: true);
    });
  }

  Future approvePengajuanAttendance(
    int line_status,
    String id_submission,
  ) async {
    final m = Get.find<ModelController>();

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/line/status/attendance'),
      );
      request.body = json.encode({
        "line_status": "$line_status",
        "id_submission_attendance": "$id_submission",
        "reason_line": "${keteranganC.text}",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // debugPrint(await response.stream.bytesToString());
      } else {
        // debugPrint('${response.reasonPhrase}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Column _tileDetailTimeOff(String title, String subTilte) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                subTilte,
                textAlign: TextAlign.right,
                style: GoogleFonts.outfit(fontSize: 12),
              ),
            ),
          ],
        ),
        Divider(thickness: .5, color: Colors.grey.shade300),
      ],
    );
  }
}
