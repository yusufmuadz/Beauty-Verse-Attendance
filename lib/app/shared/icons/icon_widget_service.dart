import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class IconWidgetService extends StatelessWidget {
  const IconWidgetService({
    super.key,
    this.onTap,
    required this.title,
    required this.icons,
    required this.colors,
    this.iconsColor = Colors.white,
    this.size = 24.0,
    this.picture,
  });

  final Function()? onTap;
  final String title;
  final IconData icons;
  final Color? iconsColor;
  final double? size;
  final Color colors;
  final String? picture;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3),
        width: Get.width / 4 - 16,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: .5, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset(picture!, width: 25, height: 25),
            ),
            const Gap(3),
            Text(
              title.capitalize!,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
