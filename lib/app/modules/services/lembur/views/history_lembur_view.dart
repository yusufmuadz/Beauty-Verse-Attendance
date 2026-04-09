import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";

import "package:flutter_custom_month_picker/flutter_custom_month_picker.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:iconsax_flutter/iconsax_flutter.dart";
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;

import "../../../../controllers/model_controller.dart";
import "../../../../core/components/custom_empty_submission.dart";
import "../../../../core/components/custom_tile_status.dart";
import "../../../../core/constant/variables.dart";
import "../../../../data/model/agreement_overtime_response_model.dart";
import "../../../../shared/button/button_1.dart";
import "../../../../shared/textfield/textfield_1.dart";
import "../../../home/views/menu_view.dart";
import "../controllers/lembur_controller.dart";
import "detail_pengajuan_lembur_user_view.dart";
import "pengajuan_lembur_view.dart";

class LemburView extends StatefulWidget {
  const LemburView({super.key});

  @override
  State<LemburView> createState() => _LemburViewState();
}

class _LemburViewState extends State<LemburView> {
  final controller = Get.put(LemburController());
  final searchC = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    searchC.text = DateFormat.yMMMM().format(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MenuView());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("History Lembur"),
          centerTitle: true,
          elevation: 2,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField1(
                controller: searchC,
                isTextShowing: false,
                suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                hintText: "Pilih Bulan",
                preffixIcon: const Icon(Iconsax.calendar_1_copy),
                onTap: () {
                  showMonthPicker(
                    context,
                    onSelected: (month, year) async {
                      selectedMonth = DateTime(year, month);
                      setState(() {
                        controller.monthC.value = month;
                        controller.yearC.value = year;
                        searchC.text = DateFormat(
                          "MMMM yyyy",
                          "id_ID",
                        ).format(DateTime(year, month));
                      });
                    },
                    initialSelectedMonth: controller.monthC.value,
                    initialSelectedYear: controller.yearC.value,
                    lastYear: DateTime.now().year,
                    selectButtonText: "OK",
                    cancelButtonText: "Cancel",
                    highlightColor: Colors.amber.shade600,
                    textColor: Colors.white,
                    contentBackgroundColor: Colors.white,
                    dialogBackgroundColor: Colors.grey[200],
                  );
                },
                readOnly: true,
              ),
              const Gap(10),
              Expanded(
                child: FutureBuilder(
                  future: fetchLembur(
                    DateFormat('yyyy-MM', 'id_ID').format(selectedMonth),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      List<DetailOvertime> overtimeList =
                          snapshot.data as List<DetailOvertime>;

                      if (overtimeList.isEmpty) {
                        return CustomEmptySubmission(
                          title: 'Belum ada pengajuan lembur',
                          subtitle: 'Belum ada pengajuan lembur, silahkan ajukan pengajuan lembur anda',
                        );
                      }

                      overtimeList.sort(
                        (a, b) =>
                            b.createdAt?.compareTo(
                              a.createdAt ?? DateTime.now(),
                            ) ??
                            0,
                      );
                      return ListView.builder(
                        itemCount: overtimeList.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DetailOvertime overtime = overtimeList[index];

                          return CustomTileStatus(
                            onTap: () async {
                              await Get.to(
                                () => DetailPengajuanLemburUser(),
                                arguments: overtime,
                              );
                              setState(() {});
                            },
                            status: overtime.status ?? '',
                            mainTitle: 'Diajukan pada',
                            mainSubtitle: DateFormat(
                              "dd MMMM yyyy",
                              "id_ID",
                            ).format(overtime.createdAt ?? DateTime.now()),
                            secTitle: 'Lembur untuk',
                            secSubtitle:
                                overtime.notes ??
                                "pengajuan dikirimkan oleh superadmin",
                            thirdTitle: 'Jadwal lembur',
                            thirdSubtitle: DateFormat(
                              'dd MMM yyyy',
                              'id_ID',
                            ).format(overtime.dateRequestFor ?? DateTime.now()),
                          );
                        },
                      );
                    }

                    return CustomEmptySubmission();
                  },
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(top: 015),
                  child: Button1(
                    title: 'Pengajuan Lembur',
                    onTap: () async {
                      await Get.to(() => PengajuanLemburView());
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchLembur(String lembur) async {
    try {
      final m = Get.find<ModelController>();

      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${Variables.baseUrl}/v1/user/fetch/lembur?sort_date=$lembur',
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        final data = json.decode(str)['data'] as List;
        List<DetailOvertime> overtimeList = data
            .map((e) => DetailOvertime.fromMap(e))
            .toList();
        return overtimeList;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
