import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Variables {
  static const String appName = "Lancar Presensi";
  // static const String baseUrl = "https://192.168.5.3:8000/api";
  static const String baseUrl = "https://apilancar.aisystem.id/api";
  static const String logoPath = "assets/logo/logo.png";

  static String FCMToken = '';

  Center loadingWidget({String? message}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black87.withAlpha(200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.white,
                strokeAlign: 0.1,
                strokeWidth: 2,
              ),
            ),
            const Gap(10),
            DefaultTextStyle(
              style: GoogleFonts.varelaRound(fontSize: 16.0),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    message ?? 'Memuat...',
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

  void loading({String? message}) {
    Get.dialog(
      AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black.withOpacity(0.5), // <<--- Lebih transparan
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
                        message ?? 'Loading...',
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      format: CompressFormat.jpeg,
      file.absolute.path,
      outPath,
      quality: 20,
    );
    return result;
  }

  // Fungsi untuk memotong gambar menjadi rasio 1:1
  Future<File> cropSquareImage(File imageFile) async {
    // Baca gambar dari file
    final image = img.decodeImage(await imageFile.readAsBytes());

    if (image == null) {
      throw Exception("Unable to decode image");
    }

    // Menentukan dimensi crop untuk 1:1 aspect ratio
    final cropSize = min(image.width, image.height);
    final offsetX = (image.width - cropSize + 2) ~/ 4;
    final offsetY = (image.height - cropSize + 2) ~/ 4;

    // Crop gambar menjadi persegi
    final cropped = img.copyCrop(
      image,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );

    // Simpan gambar yang sudah di-crop ke file baru
    final directory = await getTemporaryDirectory();
    final croppedImagePath = '${directory.path}/${Random().nextInt(10000)}.jpg';
    final croppedFile = File(croppedImagePath);
    await croppedFile.writeAsBytes(img.encodeJpg(cropped));

    return croppedFile;
  }

  Uint8List compressImage(Uint8List data) {
    img.Image? image = img.decodeImage(data);
    if (image != null) {
      img.Image resized = img.copyResize(
        image,
        width: 300,
        height: 300,
      ); // Resize image
      return Uint8List.fromList(
        img.encodeJpg(resized, quality: 40),
      ); // Compress image
    }
    return data;
  }
}
