import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/model_controller.dart';
import '../../../../../core/components/custom_dialog.dart';
import '../../../../../core/components/custom_stepper_approve.dart';
import '../../../../../core/constant/variables.dart';
import '../../../../../data/model/time_off_response_model.dart';
import '../../../../../shared/attach/show_multiple_file.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/images/images.dart';
import '../../../../../shared/snackbar/snackbar_1.dart';
import '../../../../../shared/utils.dart';

class DetailPengajuanCutiView extends StatefulWidget {
  const DetailPengajuanCutiView({super.key});

  @override
  State<DetailPengajuanCutiView> createState() =>
      _DetailPengajuanCutiViewState();
}

class _DetailPengajuanCutiViewState extends State<DetailPengajuanCutiView> {
  final m = Get.find<ModelController>();

  late Approval approval;
  var statusApproval = [];
  int indexStatus = 0;
  bool isRejected = false;

  @override
  void initState() {
    super.initState();

    approval = Get.arguments as Approval;
    if (approval.statusLine!.contains('Rejected')) {
      isRejected = true;
    }
    statusApproval = [
      'Cuti diajukan',
      '${_checkStatusApproval(approval.statusLine!, approval.status!.contains('Canceled'))}${approval.lineNama}',
      '${_checkStatusApproval(approval.statusSuperadmin ?? "Pending", approval.status!.contains('Canceled'))}${approval.superadminNama ?? 'Super Admin'}',
    ];
  }

  void _settingIndexApprove(String user, String line, String superAdmin) {
    if (user.contains('Rejected') || user.contains('Canceled')) {
      isRejected = true;
    }
    if (line.contains('Rejected')) {
      isRejected = true;
    }
    if (superAdmin.contains('Rejected')) {
      isRejected = true;
    }

    if (line.contains('Approved') || line.contains('Rejected')) {
      indexStatus = 1;
    }

    if (superAdmin.contains('Approved') || superAdmin.contains('Rejected')) {
      indexStatus = 2;
    }

    log(indexStatus.toString());
  }

  checkApprovalStatus(String status) {
    switch (status) {
      case 'pending':
        return orangeColor;
      case 'approved':
        return greenColor;
      case 'rejected':
        return redColor;
      case 'canceled':
        return redColor;
      default:
        return 'Menunggu Approval';
    }
  }

  @override
  Widget build(BuildContext context) {
    _settingIndexApprove(
      approval.status ?? 'Pending',
      approval.statusLine ?? 'Pending',
      approval.statusSuperadmin ?? 'Pending',
    );
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Detail Cuti'), titleSpacing: 0),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              const Gap(10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: Get.width,
                child: Column(
                  children: [
                    // status pengajuan cuti
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: checkApprovalStatus(
                          approval.status!.toLowerCase(),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        '${approval.status}',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // informasi pegawai cuti
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 55,
                            height: 55,
                            child: ImageNetwork(
                              url: m.u.value.avatar!,
                              borderRadius: 100,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${m.u.value.nama}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${m.u.value.jabatan}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // status pengajuan cuti
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Status Pengajuan',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // informasi pegawai cuti
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tanggal diajukan',
                            style: GoogleFonts.plusJakartaSans(fontSize: 14),
                          ),
                        ),
                        Text(':'),
                        Expanded(
                          child: Text(
                            ' ${DateFormat('dd MMM yyyy', 'id_ID').format(approval.dateRequest!)}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    // custom stepper
                    const Gap(15),
                    CustomStepperApprove(
                      listStepper: statusApproval,
                      activeIndex: indexStatus,
                      isRejected: isRejected,
                      listDate: [
                        approval.dateRequest,
                        approval.dateApprovalLine,
                        approval.dateApprovalSuperadmin,
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // status pengajuan cuti
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        'Detail Pengajuan',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // informasi pegawai cuti
                    CustomDetailPengajuan(
                      title: 'Tanggal Pengajuan',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(approval.dateRequest!),
                    ),
                    CustomDetailPengajuan(
                      title: 'Jenis Cuti',
                      subTitle: '${approval.masterCuti}',
                    ),
                    CustomDetailPengajuan(
                      title: 'Tanggal Awal Cuti',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(approval.startTimeOff!),
                    ),
                    CustomDetailPengajuan(
                      title: 'Tanggal Akhir Cuti',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(approval.endTimeOff!),
                    ),

                    CustomDetailPengajuan(
                      title: 'Terpakai',
                      subTitle:
                          '${approval.endTimeOff!.difference(approval.startTimeOff!).inDays + 1} Hari',
                    ),
                    CustomDetailPengajuan(
                      title: 'Alasan',
                      subTitle: approval.reason ?? '-',
                    ),
                  ],
                ),
              ),
              if (approval.attach != null) ...{
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ShowMultipleFile(attach: approval.attach!),
                ),
              },
              const Gap(10),
              if (approval.status != 'Approved' &&
                  approval.status != 'Rejected' &&
                  approval.status != 'Canceled') ...{
                Button1(
                  title: 'Batalkan Pengajuan Cuti',
                  backgroundColor: Colors.red,
                  onTap: cancelSubmissionTimeOff,
                ),
              },
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cancelSubmissionTimeOff() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Batalkan Cuti?',
            style: GoogleFonts.plusJakartaSans(fontSize: 16),
          ),
          content: Text(
            'Apakah anda yakin ingin membatalkan pengajuan cuti ini.',
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Tidak',
                    style: GoogleFonts.plusJakartaSans(color: Colors.amber),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    Get.dialog(Center(child: CircularProgressIndicator()));
                    final data = await cancelTimeOff(approval.id ?? '');
                    bool status = data['status'];
                    if (status) {
                      Get.back();
                      Get.back();
                      Snackbar().snackbar1(
                        'Berhasil',
                        'Anda telah membatalkan cuti!',
                        Iconsax.calendar_1_copy,
                        Colors.white,
                        Colors.amber,
                      );
                    } else {
                      Get.back();
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            title: 'Gagal!',
                            content: '${data['message']}',
                            onConfirm: () {
                              Get.back();
                            },
                            onCancel: () {},
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'Ya',
                    style: GoogleFonts.plusJakartaSans(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ========

  Future cancelTimeOff(String id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${m.token.value}',
    };
    var request = http.Request(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/timeoff/cancel'),
    );

    log(id.toString());

    request.body = json.encode({"id": id.toString()});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final str = await response.stream.bytesToString();
    return json.decode(str);
  }

  // ========

  _checkStatusApproval(String approval, bool isCanceled) {
    if (isCanceled) return 'Tidak dapat dilanjutkan ';
    switch (approval) {
      case "Pending":
        return 'Menunggu ';
      case "Approved":
        return 'Disetujui oleh ';
      case "Rejected":
        return 'Ditolak oleh ';
      default:
        break;
    }
  }

  checkSteper(String? approval, String? statusSuperAdmin) {
    log(approval!);
    switch (approval) {
      case 'pending':
        return 0;
      case 'approved':
        if (statusSuperAdmin == 'Approved') {
          return 2;
        }
        return 1;
      case 'rejected':
        return 1;
    }
  }
}

class CustomDetailPengajuan extends StatelessWidget {
  const CustomDetailPengajuan({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Text(':  ', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
          Expanded(
            flex: 1,
            child: Text(
              subTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
