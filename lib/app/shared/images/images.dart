import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constant/variables.dart';
import '../../modules/update/views/update_submission_view.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.url,
    this.borderRadius = 100,
    this.boxFit = BoxFit.fill,
    this.colors = Colors.white,
  });

  final Color? colors;
  final String url;
  final double? borderRadius;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    Future<File?> loadImage(String name) async {
      if (name.contains("/")) {
        name = name.split("/").last;
      }

      final directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;

      final String fileName = "$name"; // Nama file yang diinginkan
      final File localImage = File('$path/$fileName');

      if (await localImage.exists()) {
        return localImage;
      }
      return null;
    }

    if (url.split('/').last == 'default.jpg') {
      return SizedBox(
        width: 44,
        height: 44,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(Variables.avatarDefault, fit: BoxFit.cover),
        ),
      );
    }

    return FutureBuilder<File?>(
      future: loadImage(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeholderAvatar();
        }
        if (snapshot.hasData) {
          final imageFile = snapshot.data;
          if (imageFile != null) {
            try {
              return Image.network(
                url,
                fit: boxFit,
                loadingBuilder: (context, child, loadingProgress) =>
                    _placeholderAvatar(), // your loading builder,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholderAvatar(),
              );
            } catch (e) {
              return _placeholderAvatar();
            }
          }
        }
        try {
          return (url.isEmpty || !Uri.parse(url).isAbsolute)
              ? _placeholderAvatar()
              : GestureDetector(
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        content: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(imageUrl: url),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: boxFit,
                      placeholder: (context, url) => _placeholderAvatar(),
                      errorWidget: (context, url, error) =>
                          _placeholderAvatar(),
                    ),
                  ),
                );
        } catch (e) {
          return _placeholderAvatar();
        }
      },
    );
  }

  Widget _placeholderAvatar() {
    return GestureDetector(
      onTap: () {
        Get.to(UpdateSubmissionView());
      },
      child: Center(
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(Iconsax.gallery_copy, color: colors),
        ),
      ),
    );
  }
}
