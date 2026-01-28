import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/components/my_button.dart';

class DialogCustom {
  dialog({
    required String title,
    required String subtitle,
    required Function()? onTap,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        content: Text(
          subtitle,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        actions: [MyButton(txtBtn: 'Mengerti', onTap: onTap)],
      ),
    );
  }
}
