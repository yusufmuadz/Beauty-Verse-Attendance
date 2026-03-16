import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../controllers/model_controller.dart';
import '../../../core/components/custom_dialog.dart';
import '../../../core/components/my_button.dart';
import '../../../core/constant/variables.dart';
import '../../../models/permintaan_barang.dart';
import '../controllers/permintaan_controller.dart';

class DetailPermintaanView extends StatefulWidget {
  const DetailPermintaanView({super.key});

  @override
  State<DetailPermintaanView> createState() => _DetailPermintaanViewState();
}

class _DetailPermintaanViewState extends State<DetailPermintaanView> {
  late PermintaanBarang barang;
  final m = Get.find<ModelController>();
  final controller = Get.put(PermintaanController());

  @override
  void initState() {
    super.initState();
    barang = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text("Detail Permintaan")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            biodataUser(),
            const Gap(10),
            timelineTracker(),
            const Gap(10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outlined),
                        const Gap(7),
                        Text(
                          "Barang Permintaan",
                          style: GoogleFonts.outfit(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.5, color: Colors.grey, height: 0),
                  ...barang.listBarang!.map(
                    (e) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.namaStok ?? 'Permintaan Kustom',
                                style: GoogleFonts.outfit(fontSize: 14),
                              ),
                              Text(
                                "Jumlah Permintaan: ${e.jumlahPermintaan} ${e.quantitas ?? "Unit"}",
                                style: GoogleFonts.outfit(fontSize: 12),
                              ),
                            ],
                          ),
                          detailInformasiBarang(e),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            if (barang.itChecking == 1 &&
                (barang.statusPermintaan == "Disiapkan IT Sebagian" ||
                    barang.statusPermintaan == "Disiapkan IT"))
              MyButton(
                padding: 10,
                color: Colors.amber,
                txtBtn: barang.statusPermintaan == "Disiapkan IT Sebagian"
                    ? "Selesai Sebagian"
                    : barang.statusPermintaan == "Disiapkan IT"
                    ? "Selesai"
                    : barang.statusPermintaan ?? "",
                onTap: () async {
                  // ini buat apa?
                  Get.dialog(
                    CustomDialog(
                      title: 'Sudah Menerima Barang?',
                      content:
                          "Pastikan Anda sudah menerima barang dan sudah melakukan pengecekan ulang",
                      cancelText: "Batalkan",
                      confirmText: "Mengerti",
                      onConfirm: () async {
                        Get.back();
                        Variables().loading(message: 'Logout...');
                        await controller
                            .penerimaanPermintaan(
                              permintaanId: barang.permintaanId ?? "-",
                            )
                            .then((value) {
                              if (value != null && value['status']) {
                                Get.back();
                                Get.back();
                              } else {
                                Get.back();
                              }
                            });
                      },
                      onCancel: () {
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            const Gap(10),
            if (barang.trackingBarang!.length == 1)
              MyButton(
                padding: 10,
                txtBtn: 'Batalkan Permintaan',
                onTap: _batalkanPermintaan,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _batalkanPermintaan() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Hapus Permintaan',
            style: GoogleFonts.outfit(fontSize: 14),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Apakah anda yakin dengan keyakinan anda saat ini, akan menghapus permintaan ini?',
                style: GoogleFonts.outfit(fontSize: 12),
              ),
              const Gap(15),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    child: MyButton(
                      padding: 0,
                      txtBtn: 'Tidak',
                      color: Colors.grey.shade400,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: MyButton(
                      padding: 0,
                      txtBtn: 'Hapus',
                      color: Colors.red,
                      onTap: _hapusPermintaan,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return;
  }

  Future<void> _hapusPermintaan() async {
    Navigator.pop(context);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://web.aisystem.id/api/permintaan-material/delete'),
    );

    request.fields.addAll({
      'user_id': m.u.value.id!,
      'permintaan_id': barang.permintaanId!,
    });

    debugPrint('log: ${request.fields}');

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          content: Text(
            'Berhasil menghapus data',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else {
      final str = await response.stream.bytesToString();
      final data = json.decode(str);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            data['message'],
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget detailInformasiBarang(ListBarang e) {
    if (e.disetujuiAtasan != 1) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Ditolak Atasan",
          style: GoogleFonts.outfit(color: Colors.red),
        ),
      );
    }

    if (e.ditolakGudang == 1) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Ditolak Gudang",
          style: GoogleFonts.outfit(color: Colors.red),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Item Masuk : ${e.barangMasuk}",
          style: GoogleFonts.outfit(fontSize: 12),
        ),
        Text(
          "Telah disiapkan : ${e.barangKeluar}",
          style: GoogleFonts.outfit(fontSize: 12),
        ),
        if (e.tidakTerpenuhi != 0)
          Text(
            "Tidak Terpenuhi : ${e.tidakTerpenuhi}",
            style: GoogleFonts.outfit(fontSize: 12),
          ),
      ],
    );
  }

  Container timelineTracker() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Icon(Icons.info_outlined),
                const Gap(7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tanggal Permintaan ${DateFormat("dd MMMM yyyy, HH:mm", "id_ID").format(barang.tanggalPermintaan!)}",
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                    Text(
                      "No Permintaan: ${barang.noPermintaan}",
                      style: GoogleFonts.outfit(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 0.5, color: Colors.grey, height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: MyTimeLineTile(
              barang: barang.trackingBarang!,
              penerima: barang.penerimaBarang ?? 'Pemohon',
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Container biodataUser() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(imageUrl: m.u.value.avatar!),
            ),
          ),
          const Gap(9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                barang.pemohon ?? '',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,

                  fontSize: 14,
                ),
              ),
              Text(
                barang.jabatan ?? '',
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyTimeLineTile extends StatelessWidget {
  const MyTimeLineTile({
    super.key,
    required this.barang,
    required this.penerima,
  });

  final List<TrackingBarang> barang;
  final String penerima;

  @override
  Widget build(BuildContext context) {
    List<Widget> timelineWidget = [];

    if (barang.isNotEmpty) {
      for (int i = 0; i < barang.length; i++) {
        bool isFirst = i == 0;
        bool isLast = i == barang.length - 1;

        timelineWidget.add(
          TimelineTile(
            isFirst: isLast,
            isLast: isFirst,
            alignment: TimelineAlign.manual,
            lineXY: 0.2,
            startChild: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                DateFormat("dd MMM\nHH:mm", "id_ID").format(barang[i].tanggal!),
                textAlign: TextAlign.end,
                style: GoogleFonts.outfit(
                  color: isLast ? Colors.black : Colors.black45,

                  fontSize: 11,
                ),
              ),
            ),
            endChild: Container(
              padding: const EdgeInsets.only(
                bottom: 15,
                left: 10,
                top: 15,
                right: 10,
              ),
              child: Text(
                getStatusDescription(
                  "${barang[i].type!.toLowerCase()} ${barang[i].typeAction!.toLowerCase()}",
                  persetujuan: barang[i].nama,
                  pemohon: barang[i].nama!,
                  penerima: penerima,
                ),
                style: GoogleFonts.outfit(
                  color: isLast ? Colors.black : Colors.black45,
                  fontWeight: FontWeight.normal,

                  fontSize: 13,
                ),
              ),
            ),
            beforeLineStyle: LineStyle(color: Colors.black45, thickness: 0.5),
            afterLineStyle: LineStyle(color: Colors.black45, thickness: 0.5),
            indicatorStyle: IndicatorStyle(
              width: 7,
              color: isLast ? Colors.greenAccent : Colors.grey,
            ),
          ),
        );
      }
    }
    timelineWidget.reversed.toList();
    return Column(children: timelineWidget.reversed.toList());
  }

  IconData getStatusTypeIcon(String status) {
    log(status);
    switch (status) {
      case 'acc':
        return Icons.done_all_outlined;
      case 'decline':
        return Icons.do_disturb;
      case 'create':
        return Icons.create_new_folder_outlined;
      case 'partially done':
        return Icons.done;
      default:
        return Icons.error;
    }
  }

  String getStatusDescription(
    String status, {
    String? pemohon,
    required String? persetujuan,
    String? penerima,
  }) {
    switch (status) {
      case 'approval acc':
        return 'Disetujui oleh ${persetujuan!.toUpperCase()}';
      case 'approval decline':
        return 'Ditolak oleh ${persetujuan!.toUpperCase()}';
      case 'taking done':
        return 'Diserahkan ke ${penerima!.toUpperCase()} oleh ${persetujuan!.toUpperCase()}';
      case 'taking partially done':
        return 'Diserahkan sebagian ke ${penerima!.toUpperCase()} oleh ${persetujuan!.toUpperCase()}';
      case 'create create':
        return 'Permintaan diajukan oleh ${pemohon!.toUpperCase()}';
      case 'out acc':
        return 'Permintaan telah disiapkan oleh gudang';
      case 'out decline':
        return 'Permintaan ditolak oleh gudang';
      case 'out cancel':
        return 'Permintaan telah dibatalkan oleh gudang';
      case 'in acc':
        return 'Permintaan telah diterima oleh gudang';
      case 'in decline':
        return 'Permintaan telah ditolak oleh gudang';
      case 'disiapkan it':
        return 'Disiapkan IT';
      case 'diproses it':
        return 'Diproses IT';
      case 'diproses it sebagian':
        return 'Diproses IT Sebagian';
      case 'disiapkan it sebagian':
        return 'Disiapkan IT sebagian';
      case 'done acc':
        return "Menunggu diambil pemohon";
      default:
        return status;
    }
  }
}
