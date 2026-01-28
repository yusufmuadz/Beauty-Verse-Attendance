import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TileInformation extends StatelessWidget {
  const TileInformation({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subTitle,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 20, thickness: 0.7),
        ],
      ),
    );
  }
}
