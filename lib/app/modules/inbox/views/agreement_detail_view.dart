import 'dart:developer';

import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/models/detail_leave.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/core/components/detail_absensi_bottom_sheet.dart';
import 'package:lancar_cat/app/data/model/leave_response_model.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_list_view.dart';
import 'package:lancar_cat/app/shared/attach/show_multiple_file.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/images/images.dart';
import 'package:lancar_cat/app/shared/loading/loading1.dart';
import 'package:lancar_cat/app/shared/textfield/textfield_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class AgreementDetailView extends StatefulWidget {
  AgreementDetailView({Key? key}) : super(key: key);

  @override
  State<AgreementDetailView> createState() => _AgreementDetailViewState();
}

class _AgreementDetailViewState extends State<AgreementDetailView> {
  Leave? model;
  late String idPengajuan;
  final a = Get.put(ApiController());
  TextEditingController keteranganC = TextEditingController();

  @override
  void initState() {
    super.initState();
    idPengajuan = Get.arguments;
  }

  checkColorPallete(data) {
    switch (data) {
      case 'Approved':
        return greenColor;
      case 'Rejected':
        return redColor;
    }
  }

  Future fetchDetailCutiById({required String id}) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/find/line/$id'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final data = RespModelLeave.fromJson(str);
      return data;
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(title: const Text('Detail Cuti'), centerTitle: true),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          Get.off(
            () => AgreementListView(),
            transition: Transition.cupertinoDialog,
          );
          return await true;
        },
        child: FutureBuilder(
          future: fetchDetailCutiById(id: idPengajuan),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              RespModelLeave data = snapshot.data as RespModelLeave;
              log(data.toJson());
              Content user = data.content!;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: Hero(
                                tag: user.id!,
                                child: ImageNetwork(
                                  url: user.avatar!,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.nama}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: medium,
                                    color: HexColor('4338CA'),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Pengajuan Cuti',
                                  style: GoogleFonts.outfit(
                                    fontWeight: regular,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(20),
                        Text(
                          '${user.nama} ingin mengajukan cuti pada tanggal berikut:',
                          style: GoogleFonts.outfit(fontSize: 12),
                        ),
                        const Gap(20),
                        _myCustomInfo(title: 'Tipe Cuti', data: user.tipeCuti!),
                        _myCustomInfo(
                          title: 'Tanggal Cuti',
                          data:
                              "${DateFormat('EEE, dd MMM yyyy', 'id_ID').format(user.startTimeOff!)} \ns/d ${DateFormat('EEE, dd MMM yyyy', 'id_ID').format(user.endTimeOff!)}",
                        ),
                        _myCustomInfo(
                          title: 'Lama Cuti',
                          data:
                              '${user.endTimeOff!.difference(user.startTimeOff!).inDays + 1} Hari',
                        ),
                        _myCustomInfo(
                          title: 'Alasan Cuti',
                          data: user.reason ?? '-',
                        ),
                        const Gap(20),
                        ShowMultipleFile(
                          attachment: user.attachments,
                          attach: [],
                        ),
                        const Gap(30),
                        if (user.status == 'Approved' ||
                            user.status == 'Rejected')
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: checkColorPallete(user.status),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Kamu ${user.statusLine} status permintaan ini',
                                style: GoogleFonts.outfit(
                                  fontWeight: regular,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (user.statusLine == 'Pending')
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(15),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField1(
                              isTextShowing: false,
                              controller: keteranganC,
                              fillColor: whiteColor,
                              hintText: 'Masukan keterangan...',
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Expanded(
                                  child: Button1(
                                    onTap: () async {
                                      Get.dialog(Loading1());
                                      await a.approveCuti(
                                        user.id!,
                                        keteranganC.text,
                                        '0',
                                      );
                                      Get.back();
                                      Get.off(
                                        () => AgreementListView(),
                                        transition: Transition.cupertinoDialog,
                                      );
                                    },
                                    title: 'Tolak',
                                    backgroundColor: whiteColor,
                                    color: redColor,
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Button1(
                                    onTap: () async {
                                      Get.dialog(Loading1());
                                      await a.approveCuti(
                                        user.id!,
                                        keteranganC.text,
                                        '1',
                                      );
                                      Get.back();
                                      Get.off(
                                        () => AgreementListView(),
                                        transition: Transition.cupertinoDialog,
                                      );
                                    },
                                    title: 'Setuju',
                                    backgroundColor: indigoColor,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  _myCustomInfo({required String title, required String data}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                data,
                textAlign: TextAlign.right,
                style: GoogleFonts.outfit(fontSize: 12),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
