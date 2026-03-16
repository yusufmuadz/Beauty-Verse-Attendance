import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/model/leave_response_model.dart';
import '../../models/detail_leave.dart';
import '../loading/loading1.dart';

class ShowMultipleFile extends StatelessWidget {
  final Function()? onTap;
  final List<Attach> attach;
  final List<Attachment>? attachment;
  const ShowMultipleFile({
    super.key,
    this.onTap,
    required this.attach,
    this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data lampiran', style: GoogleFonts.outfit(fontSize: 16)),
        const Gap(7.0),
        if (attach.isEmpty || attachment == null)
          Text('Tidak ada lampiran', style: GoogleFonts.outfit(fontSize: 12)),
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: attach.isEmpty
              ? attachment == null
                    ? []
                    : attachment!
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                Get.dialog(Loading1());
                                openFile(
                                  url: e.url!,
                                  name: e.file!.split('/').last,
                                );
                              },
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.document_1_copy),
                                    const Gap(2.0),
                                    Text(
                                      e.file!.split('.').last,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList()
              : attach.map((e) {
                  return InkWell(
                    onTap: () {
                      Get.dialog(Loading1());
                      openFile(url: e.url!, name: e.file!.split('/').last);
                    },
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.document_1_copy),
                          const Gap(2.0),
                          Text(
                            e.file!.split('.').last,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
        ),
      ],
    );
  }
}

Future<void> openFile({required String url, required String name}) async {
  try {
    final file = await downloadFile(url: url, name: name);
    if (file == null) {
      debugPrint('Failed to download file.');
      return;
    }

    await Future.delayed(Duration(milliseconds: 300)).then((value) async {
      Get.back();
      await OpenFile.open(file.path);
    });
  } catch (e) {
    debugPrint('Exception opening file: $e');
  }
}

Future<File?> downloadFile({required String url, required String name}) async {
  late Directory directory;

  if (Platform.isAndroid) {
    // Note: Mengambil directory untuk Android
    var directories = await getExternalStorageDirectories();
    if (directories == null || directories.isEmpty) {
      return null;
    }
    directory = directories.first;
  } else if (Platform.isIOS) {
    // Note: Mengambil directory untuk iOS
    directory = await getApplicationSupportDirectory();
  } else {
    Get.defaultDialog(
      title: "Informasi",
      content: Text("Platform ini tidak didukung metode ini."),
    );
    return null;
  }

  final file = File('${directory.path}/$name');

  try {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(seconds: 0),
      ),
    );

    if (response.statusCode == 200) {
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      if (await file.exists()) {
        debugPrint('File exists at path: ${file.path}');
      } else {
        debugPrint('File does not exist at path: ${file.path}');
      }

      return file;
    } else {
      debugPrint('Failed to download file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error: $e');
  }

  return null;
}
