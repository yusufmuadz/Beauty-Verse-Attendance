import 'package:lancar_cat/app/core/components/my_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/models/time_off.dart';
import 'package:lancar_cat/app/modules/services/cuti/pengajuan/views/pengajuan_cuti_view.dart';
import 'package:lancar_cat/app/modules/services/cuti/views/cuti_pengajuan.dart';
import 'package:lancar_cat/app/shared/textfieldform.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class CutiView extends StatefulWidget {
  const CutiView({Key? key}) : super(key: key);

  @override
  State<CutiView> createState() => _CutiViewState();
}

class _CutiViewState extends State<CutiView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    tabController = TabController(length: 2, vsync: this);
  }

  initializeDateFormatting() {
    filterCalendar.text = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());
  }

  int inputYear = DateTime.now().year;
  int inputMonth = DateTime.now().month;
  final a = Get.put(ApiController());
  final filterCalendar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuti'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: FutureBuilder(
            future: a.getCuti(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingCuti();
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<TimeOff>? cuti = snapshot.data;
                return CutiTile(cuti: cuti);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      // ignore: deprecated_member_use
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextfieldForm(
                controller: filterCalendar,
                hintText: 'Masukan tanggal pengajuan',
                readOnly: true,
                prefixIcon: Icon(Iconsax.calendar_1_copy),
                suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                onTap: () async {
                  await filterCalendarInput(context: context);
                },
              ),
            ),
            Expanded(
              child: CutiPengajuan(time: DateTime(inputYear, inputMonth)),
            ),
            const Gap(50),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: MyButton(
          txtBtn: 'Pengajuan Cuti',
          onTap: () async {
            await Get.to(
              () => PengajuanCutiView(),
              transition: Transition.cupertino,
            );
            setState(() {});
          },
        ),
      ),
      // bottomSheet: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(4),
      //   ),
      //   padding: const EdgeInsets.symmetric(vertical: 10),
      //   child: MyButton(
      //     txtBtn: 'Pengajuan Cuti',
      //     onTap: () async {
      //       await Get.to(() => PengajuanCutiView(),
      //           transition: Transition.cupertino);
      //       setState(() {});
      //     },
      //   ),
      // ),
    );
  }

  filterCalendarInput({required BuildContext context}) async {
    return showMonthPicker(
      context,
      onSelected: (month, year) {
        filterCalendar.text = DateFormat(
          'MMMM yyyy',
          'id_ID',
        ).format(DateTime(year, month));
        inputMonth = month;
        inputYear = year;
        setState(() {});
      },
      initialSelectedMonth: inputMonth,
      initialSelectedYear: inputYear,
      firstYear: DateTime.now().year - 1,
      lastYear: DateTime.now().year + 1,
      selectButtonText: 'OK',
      highlightColor: Colors.amber,
    );
  }
}

class CutiTile extends StatelessWidget {
  const CutiTile({super.key, required this.cuti});

  final List<TimeOff>? cuti;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        color: Colors.amber.shade900,
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: greyColor),
          ),
          child: Column(
            children: [
              Text('Sisa Cuti Tahunan', style: GoogleFonts.varelaRound()),
              const Gap(5),
              Text(
                ' ${(cuti != null
                    ? cuti!.where((element) => element.name == 'Cuti Tahunan').isNotEmpty
                          ? cuti!.where((element) => element.name == 'Cuti Tahunan').first.balance
                          : '0'
                    : '0')}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingCuti extends StatelessWidget {
  const LoadingCuti({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        color: Colors.amber.shade900,
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: greyColor),
            color: Colors.white,
          ),
          child: Skeletonizer(
            enabled: true,
            child: Column(
              children: [Text('sisa cuti tahunan'), const Gap(5), Text('20')],
            ),
          ),
        ),
      ),
    );
  }
}
