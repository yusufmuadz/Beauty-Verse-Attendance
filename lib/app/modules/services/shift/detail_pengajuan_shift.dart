import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../controllers/model_controller.dart';
import '../../../core/constant/time_format_schedule.dart';
import '../../../core/constant/variables.dart';
import '../../../models/detail_shift.dart';
import '../../../shared/button/button_1.dart';
import '../../../shared/textfield/textfield_1.dart';
import '../cuti/pengajuan/views/detail_pengajuan_cuti_view.dart';

class DetailPengajuanShiftView extends StatefulWidget {
  const DetailPengajuanShiftView({super.key});

  @override
  State<DetailPengajuanShiftView> createState() =>
      _DetailPengajuanShiftViewState();
}

class _DetailPengajuanShiftViewState extends State<DetailPengajuanShiftView> {
  final reasonLine = TextEditingController();
  final m = Get.find<ModelController>();
  late String idRequest;
  late Content content;
  RxBool isDone = false.obs;

  @override
  void initState() {
    super.initState();
    idRequest = Get.arguments;
  }

  Future fetchRequestShiftById({required String id}) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v1/shift/request/id/$idRequest'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = RespModelShift.fromJson(str);
        content = data.content!;
        isDone.value = true;
        return data;
      } else {
        if (kDebugMode) {
          debugPrint(response.reasonPhrase);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengajuan Shift')),
      body: FutureBuilder(
        future: fetchRequestShiftById(id: idRequest),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasData) {
            RespModelShift model = snapshot.data! as RespModelShift;
            Content content = model.content!;

            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: content.avatar!,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                          'Permintaan Pergantian Shift',
                          style: GoogleFonts.outfit(fontSize: 11),
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                            'id_ID',
                          ).format(content.dateRequestFor!),
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(20),
                Text(
                  '${content.nama} ingin mengajukan perubahan pergantian shift :',
                  style: GoogleFonts.outfit(fontSize: 12),
                ),
                const Gap(20),
                Text(
                  'Detail Pengajuan Perubahan Shift',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const Gap(15),
                CustomDetailPengajuan(
                  title: 'Shift Sebelum',
                  subTitle: settingShiftAndSchedule(
                    content.oldShift!,
                    content.newShift!,
                    'old',
                  ),
                ),
                CustomDetailPengajuan(
                  title: 'Shift Sesudah',
                  subTitle: settingShiftAndSchedule(
                    content.oldShift!,
                    content.newShift!,
                    'new',
                  ),
                ),
                CustomDetailPengajuan(
                  title: 'Alasan',
                  subTitle: content.notes!,
                ),
                if (content.statusLine != 'Pending') ...[
                  const Gap(50),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (content.statusLine == 'Approved')
                          ? Colors.amber
                          : Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        'Kamu ${content.statusLine} Permintaan Ini',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          } else {
            return Center(
              child: Text(
                'tidak ada content',
                style: GoogleFonts.outfit(fontSize: 12),
              ),
            );
          }
        },
      ),
      bottomSheet: Obx(() {
        if (isDone.value) {
          return (content.statusLine != 'Pending')
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField1(
                        controller: reasonLine,
                        hintText: 'Masukan alasan anda disini....',
                        maxLines: 2,
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Flexible(
                            child: Button1(
                              onTap: () async {
                                Variables().loading();

                                await decisionLine(
                                  id: content.id!,
                                  usersId: content.usersId!,
                                  decision: 0,
                                  reasonLine: reasonLine.text,
                                );

                                Get.back();
                                Get.back();
                              },
                              title: 'TOLAK',
                              backgroundColor: Colors.red,
                            ),
                          ),
                          const Gap(5),
                          Flexible(
                            child: Button1(
                              onTap: () async {
                                Variables().loading();

                                await decisionLine(
                                  id: content.id!,
                                  usersId: content.usersId!,
                                  decision: 1,
                                  reasonLine: reasonLine.text,
                                );

                                Get.back();
                                Get.back();
                              },
                              title: 'SETUJU',
                              backgroundColor: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        }
        return SizedBox();
      }),
    );
  }

  Future decisionLine({
    required String id,
    required String usersId,
    required int decision,
    String? reasonLine,
  }) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/line/fetch/decision/shift'),
    );

    request.fields.addAll({
      'id': id,
      'users_id': usersId,
      'decision': decision.toString(),
      'reason_line': reasonLine!,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (kDebugMode) {
        debugPrint(await response.stream.bytesToString());
      }
    } else {
      if (kDebugMode) {
        debugPrint(response.reasonPhrase);
      }
    }
  }

  String settingShiftAndSchedule(
    DetailShift oldShift,
    DetailShift newShift,
    String type,
  ) {
    String scheduleOutNew = TimeFormatSchedule().timeOfDayFormat(
      newShift.scheduleOut ?? '00:00:00',
    );
    String scheduleInNew = TimeFormatSchedule().timeOfDayFormat(
      newShift.scheduleIn ?? '00:00:00',
    );

    if (type == 'new') {
      return '${newShift.shiftName} ($scheduleInNew-$scheduleOutNew)';
    }

    String scheduleOutOld = TimeFormatSchedule().timeOfDayFormat(
      oldShift.scheduleOut ?? '00:00:00',
    );
    String scheduleInOld = TimeFormatSchedule().timeOfDayFormat(
      oldShift.scheduleIn ?? '00:00:00',
    );
    return '${oldShift.shiftName} ($scheduleInOld-$scheduleOutOld)';
  }
}
