import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class Loading1 extends StatelessWidget {
  const Loading1({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: transparentColor,
      elevation: 0,
      content: Center(child: CircularProgressIndicator()),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black.withValues(alpha: .3), // <<--- Lebih transparan
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            const Gap(10),
            DefaultTextStyle(
              style: GoogleFonts.outfit(
                fontSize: 12.0,
                color: Colors.white, // Pastikan teks tetap terlihat
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'Loading...',
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                isRepeatingAnimation: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
