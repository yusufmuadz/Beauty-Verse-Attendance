import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/components/detail_absensi_bottom_sheet.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/models/approval_index.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_lembur_view.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_list_view.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_shift.dart';
import 'package:lancar_cat/app/modules/inbox/views/submission/submission_absensi_view.dart';

class AgreementView extends StatefulWidget {
  const AgreementView({super.key});

  @override
  State<AgreementView> createState() => _AgreementViewState();
}

class _AgreementViewState extends State<AgreementView> {
  final a = Get.find<ApiController>();
  final m = Get.find<ModelController>();

  // Ubah future menjadi state yang dapat diperbarui

  Future<void> initialized() async {
    await a.getAgreementLine();
    await a.findSubmissionByUserId();
    await a.findOvertimeByLine();
    await a.lenghtCountShiftLine();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await initialized();
        setState(() {});
      },
      child: FutureBuilder(
        future: fetchApprovalIndex(), // Gunakan future yang dapat di-refresh
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Variables().loadingWidget(message: 'Memuat...');
          } else if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data as ResponseApprovalIndex;
            if (data.data == null) {
              return SizedBox();
            }

            ApprovalIndex value = data.data!;

            return ListView(
              children: [
                TileAgreement(
                  color: HexColor('#C792FF'),
                  title: 'Cuti',
                  picture: 'assets/icons/ic_leave.png',
                  icons: Iconsax.clock,
                  trailing: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('#e1faff').withValues(alpha: 0.6),
                    ),
                    child: Text(
                      "${value.timeOff ?? 0}",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        color: HexColor('#01bdd8'),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => AgreementListView());
                  },
                ),
                TileAgreement(
                  color: HexColor('#85FFFF'),
                  title: 'Presensi',
                  picture: 'assets/icons/ic_presensi.png',
                  icons: Iconsax.calendar_2,
                  trailing: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('#e1faff').withValues(alpha: 0.6),
                    ),
                    child: Text(
                      "${value.attendance ?? 0}",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        color: HexColor('#01bdd8'),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => SubmissionAbsensiView());
                  },
                ),
                TileAgreement(
                  color: HexColor('#94FF6C'),
                  title: 'Lembur',
                  picture: 'assets/icons/ic_overtime.png',
                  icons: Iconsax.timer_start,
                  trailing: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('#e1faff').withValues(alpha: 0.6),
                    ),
                    child: Text(
                      "${value.overtime ?? 0}",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        color: HexColor('#01bdd8'),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => AgreementLemburView());
                  },
                ),
                TileAgreement(
                  color: HexColor('#94FF6C'),
                  title: 'Perubahan Shift',
                  picture: 'assets/icons/ic_clockin.png',
                  icons: Iconsax.timer_start,
                  trailing: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor('#e1faff').withValues(alpha: 0.6),
                    ),
                    child: Text(
                      "${value.shift ?? 0}",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        color: HexColor('#01bdd8'),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await Get.to(() => AgreementShiftView());
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

Future<ResponseApprovalIndex?> fetchApprovalIndex() async {
  var headers = {'Authorization': 'Bearer ${m.token.value}'};
  var request = http.Request(
    'GET',
    Uri.parse('${Variables.baseUrl}/v1/user/approval/line'),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (kDebugMode) {
    debugPrint("response => ${response.statusCode}");
  }

  if (response.statusCode == 200) {
    final str = await response.stream.bytesToString();
    return ResponseApprovalIndex.fromJson(str);
  } else {
    return null;
  }
}

class TileAgreement extends StatelessWidget {
  const TileAgreement({
    super.key,
    required this.title,
    required this.icons,
    required this.color,
    this.onTap,
    this.trailing,
    this.picture,
  });

  final String title;
  final IconData icons;
  final Widget? trailing;
  final Function()? onTap;
  final Color color;
  final String? picture;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      onTap: onTap,
      leading: picture != null
          ? Image.asset(picture!, width: 30, height: 30)
          : Icon(icons, color: color, size: 20),
      minLeadingWidth: 10,
      title: Text(
        '${title}',
        style: GoogleFonts.quicksand(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontSize: 13,
        ),
      ),
      trailing: (trailing != null)
          ? trailing
          : Icon(Icons.keyboard_arrow_right_outlined),
    );
  }
}
