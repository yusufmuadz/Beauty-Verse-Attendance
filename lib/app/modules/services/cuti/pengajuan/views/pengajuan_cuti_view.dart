import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../controllers/api_controller.dart';
import '../../../../../controllers/model_controller.dart';
import '../../../../../models/time_off.dart';
import '../../../../../shared/button/button_1.dart';
import '../../../../../shared/loading/loading1.dart';
import '../../../../../shared/snackbar/snackbar_1.dart';
import '../../../../../shared/textfieldform.dart';
import '../../../../../shared/utils.dart';

class PengajuanCutiView extends StatefulWidget {
  const PengajuanCutiView({super.key});

  @override
  State<PengajuanCutiView> createState() => _PengajuanCutiViewState();
}

class _PengajuanCutiViewState extends State<PengajuanCutiView> {
  final jenisC = TextEditingController();
  final alasanC = TextEditingController();
  final calendarC = TextEditingController();
  final dilegasiC = TextEditingController();

  TimeOff? _selectedTimeOff;

  final a = Get.put(ApiController());
  final m = Get.find<ModelController>();

  @override
  void initState() {
    super.initState();
    sortingTimeOff.value = m.timeOff;
  }

  @override
  void dispose() {
    jenisC.dispose();
    alasanC.dispose();
    calendarC.dispose();
    dilegasiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Pengajuan Cuti',
          style: TextStyle(fontFamily: 'Masion', color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                TextfieldForm(
                  controller: jenisC,
                  labelText: 'Jenis Cuti',
                  hintText: 'Jenis cuti',
                  prefixIcon: Icon(Iconsax.briefcase_copy),
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  readOnly: true,
                  filled: true,
                  fillColor: Colors.white,
                  onTap: () => _showJenisCuti(),
                ),
                const Gap(15),
                TextfieldForm(
                  controller: calendarC,
                  readOnly: true,
                  hintText: 'Pilih tanggal',
                  labelText: 'Pilih tanggal',
                  prefixIcon: Icon(Iconsax.calendar_1_copy),
                  filled: true,
                  fillColor: Colors.white,
                  onTap: () async {
                    await _pickCalendar();
                    setState(() {});
                  },
                ),
                const Gap(15),
                TextfieldForm(
                  controller: alasanC,
                  hintText: 'contoh: mau jalan-jalan yuhuu...',
                  labelText: 'Alasan',
                  prefixIcon: Icon(Iconsax.textalign_left_copy),
                  filled: true,
                  fillColor: Colors.white,
                ),
                const Gap(15),
                if (_selectedTimeOff != null &&
                    _selectedTimeOff!.attachmentRequest == '1')
                  TextfieldForm(
                    controller: fileC,
                    readOnly: true,
                    hintText: 'Unggah file',
                    labelText: 'Unggah file',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Iconsax.folder_add_copy),
                    filled: true,
                    onTap: () async => await _pickFileFrom(),
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
                                File(files[index].path),
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
            bottom: 15,
            left: 15,
            right: 15,
            child: Button1(title: 'Kirim Cuti', onTap: _submitPengajuanCuti),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPengajuanCuti() async {
    // pengecekan cuti hari ini jika sudah clock-in tidak bisa cuti

    /**
     * cek apakah waktu pengambilan cuti sesuai dengan kuota yang tersedia
     */

    if ((_selectedTimeOff != null &&
        _selectedTimeOff!.attachmentRequest == '1')) {
      if (files.isEmpty) {
        Snackbar().snackbar1(
          'Perhatian',
          'Anda wajib mengunggah berkas cuti.',
          Iconsax.folder_add_copy,
          whiteColor,
          redColor,
        );
        return;
      }
    }

    if (_selectedTimeOff == null) {
      Snackbar().snackbar1(
        'Perhatian',
        'Anda harus melengkapi data pengajuan cuti.',
        null,
        whiteColor,
        orangeColor,
      );
      return;
    }

    if (_selectedTimeOff != null) {
      if (_startDate == null || _endDate == null) {
        Snackbar().snackbar1(
          'Perhatian',
          'Waktu pengajuan cuti harus diisi',
          null,
          whiteColor,
          redColor,
        );
        return;
      }
    }

    int longLeave = _endDate!.difference(_startDate!).inDays + 1;
    // lakukan pengecekan untuk waktu pengambilan cuti

    if (longLeave > _selectedTimeOff!.balance &&
        _selectedTimeOff!.specialLeave != '1' &&
        _selectedTimeOff!.isBalance == '1') {
      Snackbar().snackbar1(
        'Peringatan',
        'Anda mengambil cuti melebihi kuota cuti anda',
        Iconsax.calendar_2_copy,
        whiteColor,
        redColor,
      );
    } else {
      Get.dialog(Loading1());

      final result = await a.submitTimeOff(
        files: files,
        alasan: alasanC.text,
        timeOffMasterId: timeOffMasterId,
        startTimeOff: _startDate!,
        endTimeOff: _endDate!,
      );

      if (result.status == true) {
        Get.back();
        Get.back();
        Snackbar().snackbar1(
          'Berhasil',
          'Cuti dalam pengajuan',
          null,
          whiteColor,
          greenColor,
        );
      } else {
        Get.back();
        Get.defaultDialog(
          title: 'Informasi',
          radius: 10,
          titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          content: Text(
            result.message ?? 'file yang dikirimkan harus pdf, jpg, jpeg, png',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          buttonColor: Colors.amber,
          confirmTextColor: whiteColor,
          onConfirm: () {
            Get.back();
          },
        );
      }
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;

  RxList<XFile> files = RxList<XFile>();
  TextEditingController fileC = TextEditingController();
  String timeOffMasterId = '';

  Future<void> _pickFileFrom() async {
    ImagePicker picker = ImagePicker();

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
                style: TextStyle(fontWeight: bold, fontSize: 16),
              ),
              SizedBox(
                height: 40,
                child: Button1(
                  title: 'Kamera',
                  onTap: () async {
                    XFile? file = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    files.add(file!);
                    fileC.text = '${files.length} file';
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                height: 40,
                child: Button1(
                  title: 'Multi Part Image',
                  onTap: () async {
                    var data = await picker.pickMultiImage();
                    for (var file in data) {
                      files.add(file);
                    }
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
                    files.add(file!);
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
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles();

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      files.add(XFile(file.path));
                    }
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickCalendar() async {
    var results = await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            primaryTextTheme: TextTheme(
              displayLarge: GoogleFonts.varelaRound(),
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.amber.shade600,
              onPrimary: Colors.white,
              surface: Colors.pink,
              onSurface: Colors.black,
              secondary: Colors.amber.shade100,
            ),
            dialogBackgroundColor: Colors.amber[900],
          ),
          child: child!,
        );
      },
      locale: const Locale('id', 'ID'),
      context: context,
      firstDate: DateTime.now().add(const Duration(days: -25)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih Tanggal',
      currentDate: DateTime.now(),
      confirmText: 'Simpan',
      cancelText: 'Batal',
      saveText: 'Simpan',
      errorFormatText: 'Format Tidak Valid',
      errorInvalidText: 'Tidak Valid',
      fieldStartHintText: 'Mulai',
      fieldEndHintText: 'Selesai',
      fieldStartLabelText: 'Mulai',
      fieldEndLabelText: 'Selesai',
    );

    if (results != null) {
      _startDate = results.start;
      _endDate = results.end;

      log(_startDate!.toIso8601String());
      log(_endDate!.toIso8601String());

      DateTime sd = results.start;
      DateTime dc = DateTime(sd.year, sd.month, sd.day);

      bool isSameDate =
          dc.year == DateTime.now().year &&
          dc.month == DateTime.now().month &&
          dc.day == DateTime.now().day;

      if (m.ci.value.id != null && isSameDate) {
        return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Anda tidak bisa melakukan \ncuti hari ini!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Gap(15),
                  Text(
                    'Anda tidak bisa mengajukan cuti untuk hari ini\nkarena anda sudah melakukan absensi!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      if (results.start.isAtSameMomentAs(results.end)) {
        calendarC.text =
            '${DateFormat('dd MMMM', 'id_ID').format(results.start)}';
      } else {
        calendarC.text =
            '${DateFormat('dd MMMM', 'id_ID').format(results.start)} - ${DateFormat('dd MMMM', 'id_ID').format(results.end)}';
      }
    }
  }

  RxList<TimeOff> sortingTimeOff = RxList<TimeOff>([]);

  // bottom sheet
  void _showJenisCuti() {
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      backgroundColor: whiteColor,
      isScrollControlled: true,
      enableDrag: true,
      Container(
        height: Get.height * 0.8,
        width: Get.width,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Material(
              color: Colors.white,
              child: Column(
                children: [
                  Text('Tipe Cuti', style: TextStyle(fontSize: 16)),
                  const Gap(10),
                ],
              ),
            ),
            Obx(
              () => Expanded(
                child: sortingTimeOff.isEmpty ?
                Center(child: Text('Opsi cuti Anda belum di setting oleh HR')) :
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: sortingTimeOff.length,
                  itemBuilder: (context, index) {
                    TimeOff model = m.timeOff[index];

                    return ListTile(
                      onTap: () {
                        _selectedTimeOff = model;
                        jenisC.text = model.name;
                        timeOffMasterId = model.timeoffId;
                        setState(() {});
                        Get.back();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      tileColor: (index % 2 == 0)
                          ? greyColor.withAlpha(40)
                          : whiteColor,
                      title: SizedBox(
                        width: Get.width * 0.4,
                        child: Text(
                          '${model.name}',
                          style: TextStyle(fontSize: 13, fontWeight: regular),
                        ),
                      ),
                      trailing: (model.specialLeave == '1')
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.shade200,
                              ),
                              child: Text(
                                ' ${model.specialLeave == '1' ? 'Special Leave' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: regular,
                                ),
                              ),
                            )
                          : (model.isBalance != '1')
                          ? SizedBox()
                          : Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.shade200,
                              ),
                              child: Text(
                                'Sisa: ${model.balance}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: regular,
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   *  Tahunan tidak special leave
   *  special leave = durasi
   *  tahunan = sisa cuti 
   * 
   */
}
