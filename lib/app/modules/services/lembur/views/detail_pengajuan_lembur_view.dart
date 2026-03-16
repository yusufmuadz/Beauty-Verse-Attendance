import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../controllers/model_controller.dart';
import '../../../../core/components/my_button.dart';
import '../../../../core/constant/variables.dart';
import '../../../../data/model/agreement_overtime_response_model.dart';
import '../../../../models/detail_overtime.dart';
import '../../../../shared/images/images.dart';
import '../../../../shared/utils.dart';

class DetailPengajuanLemburView extends StatefulWidget {
  const DetailPengajuanLemburView({super.key});

  @override
  State<DetailPengajuanLemburView> createState() =>
      _DetailPengajuanLemburViewState();
}

class _DetailPengajuanLemburViewState extends State<DetailPengajuanLemburView> {
  DetailOvertime overtime = DetailOvertime();
  final m = Get.find<ModelController>();
  late String idOvertime;
  Content? content;
  RxBool isDone = false.obs;

  @override
  void initState() {
    super.initState();
    idOvertime = Get.arguments;
    debugPrint('log: id overtime => $idOvertime');
  }

  Future fetchOvertimeById({required String id}) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v2/user/find/lembur/id/$id'),
    );

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      // debugPrint('log: ${response.statusCode}');
      // debugPrint('log: ${m.token.value}');

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = RespModelOvertime.fromJson(str);
        content = data.content!;
        isDone.value = true;
        return data;
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengajuan Lembur')),
      body: FutureBuilder(
        future: fetchOvertimeById(id: idOvertime),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasData) {
            RespModelOvertime overtime = snapshot.data!;
            Content content = overtime.content!;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailProfile(content),
                  const Gap(20),
                  Text(
                    content.type ?? "",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  ...checkIsDayOff(content),
                  Text(
                    'Alasan Lembur',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    content.notes ?? "",
                    style: GoogleFonts.outfit(fontSize: 12),
                  ),
                  if (content.statusLine != 'Pending') ...[
                    const Gap(30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: content.statusLine == 'Approved'
                            ? Colors.amber
                            : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        content.statusLine ?? "",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('tidak ada data yang tersedia'));
          } else {
            return const Center(child: Text('terjadi kesalahan'));
          }
        },
      ),
      bottomSheet: Obx(() {
        if (isDone.value) {
          return (content!.statusLine == 'Pending')
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      new Flexible(
                        child: MyButton(
                          txtBtn: 'TOLAK',
                          color: Colors.red,
                          onTap: () async {
                            await decisionLine(
                              id: content!.id ?? '',
                              approve: '0',
                            );
                          },
                        ),
                      ),
                      new Flexible(
                        child: MyButton(
                          txtBtn: 'SETUJU',
                          color: Colors.amber,
                          onTap: () async {
                            await decisionLine(
                              id: content!.id ?? '',
                              approve: '1',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox();
        }

        return SizedBox();
      }),
    );
  }

  Future decisionLine({required String id, required String approve}) async {
    final m = Get.find<ModelController>();
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/line/submit/lembur'),
    );
    request.fields.addAll({'id': id, 'status_line': approve});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
      Get.back();
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  List<dynamic> checkIsDayOff(Content overtime) {
    if (overtime.type == 'Day off') {
      return [
        const Gap(20),
        _tileDetailTimeOff('Jam Masuk Lembur', overtime.timeInDayoff ?? ""),
        _tileDetailTimeOff('Jam Pulang Lembur', overtime.timeOutDayoff ?? ""),
        _tileDetailTimeOff(
          'Durasi Total Lembur',
          overtime.durationOvertimeDayoff ?? "",
        ),
        _tileDetailTimeOff(
          'Durasi Istirahat Lembur',
          overtime.breakOvertimeDayoff ?? "",
        ),
        const Gap(20),
      ];
    } else {
      return [
        const Gap(20),
        if (overtime.durationBeforeShift != null) ...[
          _tileDetailTimeOff(
            'Durasi Lembur Sebelum Shift',
            formatTime(overtime.durationBeforeShift!),
          ),
          _tileDetailTimeOff(
            'Durasi Istrirahat Sebelum Shift',
            formatTime(overtime.breakBeforeShift!),
          ),
        ],
        if (overtime.durationAfterShift != null) ...[
          _tileDetailTimeOff(
            'Durasi Lembur Sesudah Shift',
            formatTime(overtime.durationAfterShift!),
          ),
          _tileDetailTimeOff(
            'Durasi Istrirahat Sesudah Shift',
            formatTime(overtime.breakAfterShift!),
          ),
        ],
        const Gap(20),
      ];
    }
  }

  String formatTime(String time) {
    // Memisahkan jam, menit, dan detik menggunakan karakter ":"
    List<String> parts = time.split(':');

    // Mengubah bagian string menjadi integer
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Menggabungkan jam dan menit dengan format "3j 18m"
    String formattedTime = '${hours} Jam ${minutes} Menit';

    return formattedTime;
  }

  Row DetailProfile(Content content) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: ImageNetwork(url: content.avatar!, boxFit: BoxFit.cover),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${content.nama}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.amber.shade600,
              ),
            ),
            Text(
              'Pengajuan Lembur Kerja',
              style: GoogleFonts.outfit(fontWeight: regular, fontSize: 12),
            ),
            Text(
              '${DateFormat('dd MMM yyyy').format(content.dateRequestFor!)}',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
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
              flex: 1,
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
