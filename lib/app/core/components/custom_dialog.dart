import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lancar_cat/app/core/components/my_button.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  VoidCallback? onConfirm = () => Get.back();
  VoidCallback? onCancel = () => Get.back();

  CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(content, style: GoogleFonts.outfit(fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Expanded(
                    child: MyButton(
                      padding: 0,
                      txtBtn: cancelText ?? "Batalkan",
                      color: Colors.red,
                      onTap: onCancel,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: MyButton(
                      padding: 0,
                      txtBtn: confirmText ?? "Mengerti",
                      color: Colors.amber.shade400,
                      onTap: onConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
