import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? obsecure;
  final bool? showTxt;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  const MyTextfield({
    super.key,
    required this.controller,
    this.obsecure,
    this.hintText,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
    this.showTxt,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTxt ?? false)
            Text(hintText!, style: GoogleFonts.figtree(fontSize: 12)),
          const Gap(5),
          TextFormField(
            style: GoogleFonts.figtree(fontSize: 12),
            cursorWidth: 1.5,
            keyboardType: keyboardType,
            cursorColor: Colors.black54,
            controller: controller,
            obscureText: obsecure ?? false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(3),
              isDense: true,
              prefixIcon: prefix,
              suffixIcon: suffix,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(fontSize: 12),
              filled: true,
              fillColor: Colors.grey.shade100,
              errorStyle: GoogleFonts.outfit(color: Colors.red),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
