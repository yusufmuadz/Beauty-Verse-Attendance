import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controllers/api_controller.dart';
import '../../../controllers/model_controller.dart';
import '../../../core/components/custom_calendar.dart';
import '../../../core/constant/variables.dart';
import '../../../shared/button/button_1.dart';
import '../../../shared/images/images.dart';
import '../../../shared/snackbar/snackbar_1.dart';
import '../../../shared/textfield/textfield_1.dart';
import '../../../shared/utils.dart';

// ignore: must_be_immutable
class UpdateSubmissionView extends StatefulWidget {
  const UpdateSubmissionView({super.key});

  @override
  State<UpdateSubmissionView> createState() => _UpdateSubmissionViewState();
}

class _UpdateSubmissionViewState extends State<UpdateSubmissionView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 100)).then((value) async {
      agama = await a.getAgama();
    });
  }

  List? agama;

  List gender = ['Laki-laki', 'Perempuan'];

  List<String> listPengajuan = [];

  String dataSelected = '';

  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  RxList<XFile?> files = <XFile>[].obs;
  XFile? image;

  String? selectedValue;

  Rx<XFile?> file = Rx<XFile?>(null);

  final dataC = TextEditingController();
  final ubahC = TextEditingController();
  final descC = TextEditingController();
  final fileC = TextEditingController();

  void resetForm() {
    dataC.clear();
    ubahC.clear();
    descC.clear();
    fileC.clear();
    files.clear();
    image = null;
    selectedValue = null;
  }

  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    dataC.dispose();
    ubahC.dispose();
    descC.dispose();
    fileC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Ajukan perubahan data'),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                TextField1(
                  readOnly: true,
                  onTap: _selectedOptions,
                  controller: dataC,
                  fillColor: whiteColor,
                  isTextShowing: true,
                  preffixIcon: Icon(Iconsax.task_square_copy),
                  suffixIcon: Icon(Iconsax.arrow_bottom_copy),
                  hintText: 'Pilih data',
                ),
                const Gap(15),
                getRequiredField(),
                const Gap(15),
                TextField1(
                  controller: descC,
                  maxLines: 1,
                  maxLenght: 50,
                  fillColor: whiteColor,
                  isTextShowing: true,
                  preffixIcon: Icon(Iconsax.menu_1_copy),
                  hintText: 'Deskripsi',
                  requiredLabel: 'maksimal 50 karakter',
                ),
                const Gap(15),
                if (dataC.text != 'avatar')
                  TextField1(
                    controller: fileC,
                    fillColor: whiteColor,
                    readOnly: true,
                    isTextShowing: true,
                    preffixIcon: Icon(Iconsax.note_favorite_copy),
                    suffixIcon: Icon(Iconsax.add_square_copy),
                    hintText: 'Unggah file',
                    onTap: () {
                      if (dataC.text.isEmpty) {
                        Get.isSnackbarOpen ? Get.back() : null;
                        Snackbar().snackbar1(
                          'Peringatan',
                          'Harap pilih data terlebih dahulu',
                          Iconsax.box,
                          whiteColor,
                          redColor,
                        );
                        return;
                      }
                      Get.dialog(
                        AlertDialog(
                          content: SizedBox(
                            width: Get.width,
                            height: Get.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Tambahkan Lampiran',
                                  style: TextStyle(
                                    fontWeight: bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button1(
                                    title: 'Kamera',
                                    onTap: () async {
                                      XFile? file = await picker.pickImage(
                                        source: ImageSource.camera,
                                      );
                                      files.add(file);
                                      fileC.text = '${files.length} file';
                                      Get.back();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button1(
                                    title: 'Galeri',
                                    onTap: () async {
                                      XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      files.add(file);
                                      fileC.text = '${files.length} file';
                                      Get.back();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Button1(
                                    title: 'File',
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();

                                      if (result != null) {
                                        File file = File(
                                          result.files.single.path!,
                                        );
                                        files.add(XFile(file.path));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const Gap(10),
                Obx(
                  () => SizedBox(
                    width: Get.width,
                    height: 100,
                    child: Wrap(
                      children: List.generate(
                        files.length,
                        (index) => Stack(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              margin: const EdgeInsets.all(5),
                              child: Image.file(
                                File(files[index]!.path),
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: redColor,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.document_text_copy,
                                            color: redColor,
                                          ),
                                          Text(
                                            'Pdf',
                                            style: TextStyle(
                                              fontWeight: semiBold,
                                              color: redColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  files.removeAt(index);
                                  fileC.text = '${files.length} file';
                                  if (files.isEmpty) {
                                    fileC.text = '';
                                  }
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Iconsax.minus_cirlce,
                                    color: redColor.withAlpha(200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Button1(
                    backgroundColor: Colors.amber.shade400,
                    title: 'Ajukan',
                    onTap: () async => await submitUpdate(),
                  ),
                  const Gap(5),
                  Button1(
                    backgroundColor: Colors.red.shade400,
                    title: 'Batal',
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          content: Text(
                            'Apakah Anda yakin ingin membatalkan pengajuan?',
                            style: TextStyle(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Tidak", style: TextStyle()),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                Get.back();
                              },
                              child: Text("Ya", style: TextStyle()),
                            ),
                          ],
                        ),
                      );
                    },
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectedOptions() {
    resetForm();
    Get.dialog(
      AlertDialog(
        backgroundColor: whiteColor,
        content: SizedBox(
          width: Get.width,
          height: Get.height * 0.5,
          child: Column(
            children: [
              Text(
                "Pilih Perubahan Data",
                style: TextStyle(fontWeight: medium, fontSize: 16),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchOptionData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LinearProgressIndicator());
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      return ListView.builder(
                        itemCount: data.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String title = data[index];

                          return Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: TextButton(
                                  onPressed: () {
                                    // hilangkan data
                                    files.clear();
                                    fileC.text = '';

                                    // ubah data menjadi
                                    setState(() {
                                      dataC.text = title;
                                      ubahC.text = '';
                                      Get.back();
                                    });
                                  },
                                  child: Text(
                                    title.replaceAll('_', ' ').capitalizeFirst!,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 0.6,
                                color: greyColor,
                                height: 0,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  Future fetchOptionData() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/user/biodata/list'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Dekode response menjadi List
        final data = await response.stream.bytesToString();
        final List<String> relationships = json.decode(data).cast<String>();
        return relationships;
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Widget getRequiredField() {
    switch (dataC.text.toLowerCase()) {
      case 'status_pernikahan':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: greyColor.withAlpha(180)),
            color: whiteColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 45,
          width: Get.width,
          child: DropdownButton<String>(
            hint: Row(
              children: [
                Icon(Iconsax.magic_star_copy),
                const Gap(10),
                Text(
                  'Status pernikahan',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ],
            ),
            icon: Icon(Iconsax.arrow_bottom_copy),
            borderRadius: BorderRadius.circular(5),
            isExpanded: true,
            style: TextStyle(fontSize: 12, color: blackColor),
            underline: SizedBox(),
            items: [
              DropdownMenuItem(value: 'Menikah', child: Text('Menikah')),
              DropdownMenuItem(
                value: 'Belum Menikah',
                child: Text('Belum Menikah'),
              ),
            ],
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value; // Update the selected value
                ubahC.text = selectedValue!;
              });
            },
          ),
        );

      case 'agama':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: greyColor.withAlpha(180)),
            color: whiteColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 45,
          width: Get.width,
          child: DropdownButton<String>(
            hint: Row(
              children: [
                Icon(Iconsax.book_copy),
                const Gap(10),
                Text(
                  'Pilih Agama',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ],
            ),
            icon: Icon(Iconsax.arrow_bottom_copy),
            borderRadius: BorderRadius.circular(5),
            isExpanded: true,
            style: TextStyle(fontSize: 12, color: blackColor),
            underline: SizedBox(),
            items: agama!
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                )
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value; // Update the selected value
                ubahC.text = selectedValue!;
              });
            },
          ),
        );

      case 'jenis_kelamin':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jenis Kelamin',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Gap(5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade100),
                color: Colors.grey.shade50,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 52,
              width: Get.width,
              child: DropdownButton<String>(
                hint: Row(
                  children: [
                    Icon(Iconsax.book_copy, color: Colors.grey),
                    const Gap(10),
                    Text(
                      'Jenis Kelamin',
                      style: GoogleFonts.varelaRound(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                icon: Icon(Iconsax.arrow_bottom_copy, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                isExpanded: true,
                style: TextStyle(fontSize: 12, color: blackColor),
                underline: SizedBox(),
                items: gender
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.toString(),
                        child: Text(
                          e,
                          style: GoogleFonts.varelaRound(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value; // Update the selected value
                    ubahC.text = selectedValue!;
                  });
                },
              ),
            ),
          ],
        );

      case 'tanggal_lahir':
        return TextField1(
          controller: ubahC,
          isTextShowing: true,
          fillColor: Colors.white,
          hintText: 'Tanggal Lahir (yyyy-mm-dd)',
          preffixIcon: Icon(Iconsax.calendar_copy),
          readOnly: true,
          onTap: () {
            customCalendar(
              context: context,
              initialDateTime: ubahC.text.isEmpty
                  ? m.detailUser.value.user == null
                        ? DateTime.now()
                        : m.detailUser.value.user!.tanggalLahir!
                  : DateTime.parse(ubahC.text),
              maximumDate: DateTime.now(),
              minimumDate: DateTime(1950),
              onDateTimeChanged: (datetime) {
                setState(() {
                  ubahC.text = DateFormat(
                    'yyyy-MM-dd',
                    'id_ID',
                  ).format(datetime);
                });
              },
            );
          },
        );

      case 'avatar':
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      child: ImageNetwork(
                        boxFit: BoxFit.cover,
                        colors: Colors.amber.shade900,
                        url: '${m.u.value.avatar}',
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right_alt_rounded),
                  GestureDetector(
                    onTap: () async {
                      await _dialogOpsiPicture();
                    },
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: (image != null)
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Image.file(
                                  fit: BoxFit.fill,
                                  File(image!.path),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                                child: Icon(Icons.upload),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return TextField1(
          controller: ubahC,
          fillColor: whiteColor,
          isTextShowing: true,
          preffixIcon: Icon(Iconsax.edit_2_copy),
          hintText: 'Ubah menjadi',
          textInputType: _checkTypeKeyboard(),
        );
    }
  }

  TextInputType _checkTypeKeyboard() {
    switch (dataC.text.toLowerCase()) {
      case 'telepon':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  // dialog option
  _dialogOpsiPicture() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: Get.width * 0.8,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  pickImage(source: ImageSource.gallery).then((value) {
                    setState(() {
                      image = value;
                    });
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: greyColor,
                      ),
                      child: Center(
                        child: Icon(Iconsax.gallery_copy, color: whiteColor),
                      ),
                    ),
                    Text('Gallery', style: TextStyle()),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  pickImage(source: ImageSource.camera).then((value) {
                    setState(() {
                      image = value;
                    });
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: greyColor,
                      ),
                      child: Center(
                        child: Icon(Iconsax.camera_copy, color: whiteColor),
                      ),
                    ),
                    Text('Camera', style: TextStyle()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // pick image from
  Future<XFile?> pickImage({required ImageSource source}) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image == null) {
      return null;
    }

    // Pengecekan ukuran file
    final File file = File(image.path);
    int sizeInBytes = await file.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 1.5) {
      // Kompresi file jika lebih dari 1.5 MB
      final XFile? compressedImage = await Variables().compressFile(
        File(image.path),
      );
      if (compressedImage != null) {
        CroppedFile? afterCrop = await cropImage(image: compressedImage);
        return XFile(afterCrop!.path);
      }
    } else {
      // Lakukan crop jika ukuran file sudah sesuai
      CroppedFile? afterCrop = await cropImage(image: image);
      return XFile(afterCrop!.path);
    }

    return null; // Return null jika tidak ada gambar yang dipilih atau kompresi gagal
  }

  Future<CroppedFile?> cropImage({required XFile image}) async {
    return await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.circle,
          toolbarColor: Colors.amber.shade900,
          toolbarWidgetColor: whiteColor,
        ),
      ],
    );
  }

  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 40,
    );
    return result;
  }

  Future submitUpdateBiodata() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/update/biodata'),
    );

    // pengecekan ada avatar atau tidak
    if (image != null) {
      debugPrint(m.u.value.avatar!.split('/').last);
      request.fields.addAll({
        'type_approval': dataC.text,
        'reason_request': descC.text,
        'from': m.u.value.avatar!.split('/').last,
      });

      request.files.add(
        await http.MultipartFile.fromPath('image', image!.path),
      );
    } else {
      // jike pengajuan tidak avatar
      request.fields.addAll({
        'type_approval': dataC.text,
        'reason_request': descC.text,
        'from': '${getDataFrom(dataC.text)}',
        'to': ubahC.text,
      });

      if (files.isNotEmpty) {
        for (var data in files) {
          request.files.add(
            await http.MultipartFile.fromPath('files[]', data!.path),
          );
        }
      }
    }

    try {
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint(await response.stream.bytesToString());
        }
        return true;
      } else {
        if (kDebugMode) {
          debugPrint(response.reasonPhrase);
        }
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getDataFrom(String status) {
    switch (status) {
      case 'nama':
        return m.u.value.nama;
      case 'jenis_kelamin':
        return m.u.value.jenisKelamin;
      case 'tanggal_lahir':
        return m.u.value.tanggalLahir;
      case 'telepon':
        return m.u.value.telepon;
      case 'status_pernikahan':
        return m.u.value.statusPernikahan;
      case 'agama':
        return m.u.value.agama;
      case 'alamat':
        return m.u.value.alamat;
      case 'gol_darah':
        return m.u.value.golDarah;
      case 'tempat_lahir':
        return m.u.value.tempatLahir;
    }
  }

  Future<void> submitUpdate() async {
    Variables().loading();

    if (ubahC.text.isEmpty && dataC.text.toLowerCase() != 'avatar') {
      Get.back();
      Snackbar().snackbar1(
        'Perhatian',
        'Data yang diubah tidak boleh kosong',
        Iconsax.box,
        whiteColor,
        redColor,
      );
      return;
    }

    if (dataC.text.toLowerCase() == 'avatar' && image == null) {
      Get.back();
      Snackbar().snackbar1(
        'Perhatian',
        'Foto profil tidak boleh kosong',
        Iconsax.box,
        whiteColor,
        redColor,
      );
      return;
    }

    if (dataC.text.isEmpty) {
      Get.back();
      Snackbar().snackbar1(
        'Perhatian',
        'Tipe data tidak boleh kosong',
        Iconsax.box,
        whiteColor,
        redColor,
      );
      return;
    }

    if (file.value != null || dataC.text.isNotEmpty) {
      String value = dataC.text.toLowerCase();

      value = value.replaceAll(' ', '_');

      await submitUpdateBiodata().then((value) {
        if (value) {
          Get.back();
          Get.back();
        } else {
          Get.back();
        }
      });
    } else {
      Get.back();
      Get.rawSnackbar(
        backgroundColor: redColor,
        titleText: Text(
          'Gagal Upload',
          style: TextStyle(color: whiteColor, fontWeight: bold, fontSize: 16),
        ),
        messageText: Text('data kosong', style: TextStyle(color: whiteColor)),
      );
    }
  }
}
