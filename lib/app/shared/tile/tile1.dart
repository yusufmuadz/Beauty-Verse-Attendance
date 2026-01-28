import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:lancar_cat/app/shared/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTile1 extends StatelessWidget {
  const ListTile1({
    super.key,
    required this.title,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.colors,
    this.widgetSuffix,
  });

  final String title;
  final Function()? onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? widgetSuffix;
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: whiteColor,
      contentPadding: const EdgeInsets.all(0),
      onTap: onTap,
      leading: prefixIcon != null
          ? Icon(prefixIcon!, color: colors ?? blackColor)
          : null,
      title: Text(
        title.capitalizeFirst!,
        style: GoogleFonts.outfit(
          color: colors ?? blackColor,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
      trailing: widgetSuffix != null
          ? widgetSuffix
          : suffixIcon != null
          ? Icon(suffixIcon!, color: colors ?? blackColor, size: 14)
          : null,
    );
  }
}
