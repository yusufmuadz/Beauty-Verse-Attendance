import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldForm extends StatelessWidget {
  const TextfieldForm({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onSaved,
    this.labelText,
    this.obsecureText = false,
    this.fillColor,
    this.filled,
    this.onChanged,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.isRequired = false,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Function(String?)? onSaved;
  final String? labelText;
  final bool obsecureText;
  final Color? fillColor;
  final bool? filled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.varelaRound(
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      autocorrect: false,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obsecureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 17,
        ),
        labelStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
        errorStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
        label: isRequired!
            ? RichText(
                text: TextSpan(
                  text: labelText,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(
                        fontFamily: "Figtree",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        labelText: isRequired! ? null : labelText,
        hintText: hintText,
        filled: filled,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade300),
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
