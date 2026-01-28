import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.items,
    this.leadingIcons,
    this.onSelected,
  });

  final TextEditingController controller;
  final String label, hintText;
  final IconData? leadingIcons;
  final List<Map<String, dynamic>> items;
  final void Function(dynamic)? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: DropdownMenu(
        trailingIcon: const Icon(Icons.keyboard_arrow_down_outlined),
        leadingIcon: leadingIcons != null ? Icon(leadingIcons) : null,
        label: Text(label, style: GoogleFonts.urbanist(fontSize: 13)),
        initialSelection: null, // Tidak ada default selection
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.amber, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          hintStyle: GoogleFonts.urbanist(fontSize: 13),
        ),
        controller: controller,
        onSelected: onSelected,
        expandedInsets: EdgeInsets.zero,
        hintText: hintText,
        textStyle: GoogleFonts.urbanist(fontSize: 13),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          shadowColor: WidgetStateProperty.all(Colors.black26),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
        dropdownMenuEntries: items
            .map(
              (e) => DropdownMenuEntry(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  overlayColor: WidgetStateProperty.all(Colors.grey.shade200),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  ),
                ),
                value: e['id'],
                label: e['value'],
                labelWidget: Text(
                  e['value'],
                  style: GoogleFonts.urbanist(fontSize: 13),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
