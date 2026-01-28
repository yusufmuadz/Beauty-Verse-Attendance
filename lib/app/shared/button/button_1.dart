import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils.dart';

class Button1 extends StatelessWidget {
  const Button1({
    super.key,
    this.onTap,
    required this.title,
    this.color,
    this.backgroundColor,
    this.widget,
    this.showOutline = true,
    this.outlineColor,
  });

  final Function()? onTap;
  final String title;
  final Widget? widget;
  final Color? color;
  final Color? backgroundColor;
  final Color? outlineColor;
  final bool? showOutline;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 45,
        width: Get.width,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.amber.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: (widget == null)
              ? Center(
                  child: Text(
                    "$title".toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: color != null ? color : whiteColor,
                    ),
                  ),
                )
              : Center(child: widget),
        ),
      ),
    );
  }
}
