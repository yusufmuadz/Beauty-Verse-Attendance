import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Snackbar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar1(
    String title,
    String message,
    IconData? icons,
    Color textColor,
    Color backgroundColor,
  ) {
    if (Get.isSnackbarOpen || Get.isBottomSheetOpen! || Get.isDialogOpen!) Get.back();

    return ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: textColor,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor.withOpacity(0.8),
      )
    );
  }
}
