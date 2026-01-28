import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lancar_cat/app/core/components/my_button.dart';

class CustomEmptySubmission extends StatelessWidget {
  const CustomEmptySubmission({
    super.key,
    this.title = "Tidak ada pengajuan",
    this.isButtonBackEnabled = false,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;
  final bool isButtonBackEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/ic_empty_box.png',
              width: 250,
              height: 250,
            ),
          ),
          const Gap(15),
          Text(
            title ?? 'Belum ada permintaan',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(5),
          Text(
            subtitle ??
                'Belum ada pengajuan barang yang anda minta,\nsilahkan ajukan barang permintaan anda',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const Gap(30),
          if (isButtonBackEnabled)
            MyButton(
              txtBtn: 'Kembali',
              onTap: () {
                Get.back();
              },
            ),
        ],
      ),
    );
  }
}
