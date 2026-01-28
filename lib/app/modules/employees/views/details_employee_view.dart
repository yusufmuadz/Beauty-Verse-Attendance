import 'package:google_fonts/google_fonts.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

class DetailsEmployeeView extends StatefulWidget {
  const DetailsEmployeeView({super.key});

  @override
  State<DetailsEmployeeView> createState() => _DetailsEmployeeViewState();
}

class _DetailsEmployeeViewState extends State<DetailsEmployeeView> {
  late User model;

  @override
  void initState() {
    super.initState();
    model = Get.arguments as User;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Karyawan'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Hero(
                    tag: model.nama!,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage('${model.avatar}'),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    model.nama ?? "-",
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    model.jabatan ?? "-",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // Detail Section
            Text(
              "Detail Karyawan",
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Gap(12),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _tileEmployee(Icons.apartment, "Cabang", model.cabang?.nama),
                  _divider(),
                  _tileEmployee(Icons.badge, "ID Karyawan", model.idKaryawan),
                  _divider(),
                  _tileEmployee(Icons.work, "Posisi Pekerjaan", model.jabatan),
                  _divider(),
                  _tileEmployee(
                    Icons.account_tree,
                    "Nama Organisasi",
                    model.divisi,
                  ),
                  _divider(),
                  _tileEmployee(Icons.email, "Email", model.email),
                  _divider(),
                  _tileEmployee(Icons.phone, "Telepon", model.telepon),
                  _divider(),
                  _tileEmployee(Icons.home, "Alamat", model.alamat),
                  _divider(),
                  _tileEmployee(Icons.church, "Agama", model.agama),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    color: Colors.grey.shade300,
    indent: 16,
    endIndent: 16,
  );

  Widget _tileEmployee(IconData icon, String title, String? subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.greenAccent, size: 22),
      title: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
      subtitle: Text(
        subtitle ?? "-",
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
