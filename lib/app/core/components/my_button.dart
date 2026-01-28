import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String txtBtn;
  final Color? color;
  final double? padding;
  const MyButton({
    super.key,
    this.onTap,
    required this.txtBtn,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 20),
      child: Material(
        color: color ?? Colors.amber.shade900,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
            height: 42,
            alignment: Alignment.center,
            child: Text(
              txtBtn,
              style: GoogleFonts.figtree(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
