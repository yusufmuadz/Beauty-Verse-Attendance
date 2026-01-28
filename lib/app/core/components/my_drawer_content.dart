import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/drawer_content.dart';

class MyDrawerContent extends StatelessWidget {
  final List<DrawerContent> drawer;
  final String title;
  const MyDrawerContent({super.key, required this.drawer, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        const Gap(5),
        ...drawer.map(
          (e) => ListTile(
            dense: true,
            onTap: e.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            minLeadingWidth: 24, // Atur lebar minimum agar seragam
            leading: Icon(e.icons, size: 24, color: Colors.black87),
            trailing: e.value != 0 && e.value != null
                ? Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.amber.shade100,
                    ),
                    child: Center(
                      child: Text(
                        e.value.toString(),
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : null,
            title: Text(
              e.title,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
