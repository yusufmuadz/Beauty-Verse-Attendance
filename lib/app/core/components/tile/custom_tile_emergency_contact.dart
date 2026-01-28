import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomTileEmergencyContact extends StatelessWidget {
  const CustomTileEmergencyContact({
    super.key,
    required this.nama,
    required this.hubungan,
    required this.notelp,
    this.onTapOption,
    this.onTapPhone,
  });

  final String nama;
  final String hubungan;
  final String notelp;
  final Function()? onTapOption;
  final Function()? onTapPhone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: UnderlineInputBorder(
        borderSide: BorderSide(width: 0.2, color: Colors.black),
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: onTapPhone,
            icon: Icon(Iconsax.whatsapp_copy),
          ),
          IconButton(
            onPressed: onTapOption,
            icon: Icon(Iconsax.more_copy),
          ),
        ],
      ),
      title: Text(
        nama,
        style: GoogleFonts.varelaRound(
          fontSize: 14,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: hubungan,
          style: GoogleFonts.varelaRound(
            color: Colors.grey,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: '\n$notelp',
              style: GoogleFonts.varelaRound(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
