import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/model_controller.dart';
import '../../../shared/tile/tile2.dart';
import '../../../shared/utils.dart';

class JobInformationView extends GetView {
  JobInformationView({super.key});

  final m = Get.find<ModelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Pekerjaan',
          style: TextStyle(color: Colors.white),
        ),
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 2,
      ),
      body: ListView(
        children: [
          const Gap(10),
          ListTile2(
            title: 'ID Karyawan',
            subTitle: m.u.value.job != null ? m.u.value.job!.idKaryawan! : '-',
            icons: Icons.badge, // 🆔 identitas
            iconColor: Colors.indigo, // biru tua = formal
          ),
          ListTile2(
            title: 'Barcode',
            subTitle: m.u.value.job != null ? m.u.value.job!.idKaryawan! : '-',
            icons: Icons.qr_code, // 📱 barcode / QR
            iconColor: Colors.deepPurple, // ungu = teknologi
          ),
          ListTile2(
            title: 'Nama Perusahaan',
            subTitle: 'Andi Offset Yogyakarta',
            icons: Icons.business, // 🏢 perusahaan
            iconColor: Colors.amber, // biru = corporate
          ),
          ListTile2(
            title: 'Penempatan Pertama',
            subTitle:
                m.u.value.job!.penempatanPertama != null &&
                    m.u.value.job!.penempatanPertama!.isNotEmpty
                ? m.u.value.job!.penempatanPertama!
                : '-',
            icons: Icons.apartment, // 🏬 Penempatan Pertama
            iconColor: Colors.orange, // oranye = lokasi
          ),
          ListTile2(
            title: 'Penempatan Saat Ini',
            subTitle: m.u.value.cabang!.nama ?? '-',
            icons: Icons.location_city, // 🏬 Penermpatan saat ini
            iconColor: Color(0xFF3B82F6), // biru = lokasi
          ),
          ListTile2(
            title: 'Nama Organisasi',
            subTitle: m.u.value.divisi ?? '-',
            icons: Icons.account_tree, // 🌳 struktur organisasi
            iconColor: Colors.amber, // hijau = struktur, growth
          ),
          ListTile2(
            title: 'Posisi Pekerjaan',
            subTitle: m.u.value.jabatan ?? '-',
            icons: Icons.work, // 💼 pekerjaan
            iconColor: Colors.teal, // teal = profesionalisme
          ),
          ListTile2(
            title: 'Level Pekerjaan',
            subTitle: m.u.value.job != null
                ? m.u.value.job!.levelPekerjaanId!
                : '-',
            icons: Icons.stacked_bar_chart, // 📊 level / ranking
            iconColor: Colors.amber, // kuning emas = level
          ),
          ListTile2(
            title: 'Status Pekerjaan',
            subTitle: m.u.value.job != null
                ? m.u.value.job!.statusPekerjaan!
                : '-',
            icons: Icons.verified_user, // ✅ status kerja
            iconColor: Colors.cyan, // biru muda = validasi
          ),
          ListTile2(
            title: 'Status PTKP',
            subTitle:
                m.u.value.job!.statusPTKP != null && m.u.value.job!.statusPTKP!.isNotEmpty
                ? m.u.value.job!.statusPTKP!
                : '-',
            icons: Icons.paid, // ✅ status PTKP
            iconColor: Color(0xFF059669), // emerald = keuangan / pajak
          ),
          ListTile2(
            title: 'Tanggal Bergabung',
            subTitle: (m.u.value.job != null)
                ? DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(m.u.value.job!.tglBergabung!)
                : '-',
            icons: Icons.event_available, // 📅 bergabung
            iconColor: Colors.lightGreen, // hijau muda = start
          ),
          ListTile2(
            title: 'Masa Berakhir Kontrak',
            subTitle: (m.u.value.job != null)
                ? DateFormat(
                    'dd MMMM yyyy',
                    'id_ID',
                  ).format(m.u.value.job!.tglBerakhir!)
                : '-',
            icons: Icons.event_busy, // 🗓️ kontrak selesai
            iconColor: Colors.redAccent, // merah = warning
          ),
          ListTile2(
            title: 'Masa Kerja',
            subTitle: (m.u.value.job != null)
                ? calculateWorkDuration(
                    m.u.value.job!.tglBergabung!,
                    DateTime.now(),
                  )
                : '-',
            icons: Icons.timeline, // 📈 durasi / timeline
            iconColor: Colors.brown, // coklat = waktu / timeline
          ),
        ],
      ),
    );
  }
}

String calculateWorkDuration(DateTime startDate, DateTime endDate) {
  // Calculate the difference in years, months, and days
  int years = endDate.year - startDate.year;
  int months = endDate.month - startDate.month;
  int days = endDate.day - startDate.day;

  // Adjust for negative values
  if (days < 0) {
    final previousMonth = DateTime(endDate.year, endDate.month, 0);
    days += previousMonth.day;
    months -= 1;
  }

  if (months < 0) {
    months += 12;
    years -= 1;
  }

  return '$years year${years != 1 ? 's' : ''} $months month${months != 1 ? 's' : ''} $days day${days != 1 ? 's' : ''}';
}
