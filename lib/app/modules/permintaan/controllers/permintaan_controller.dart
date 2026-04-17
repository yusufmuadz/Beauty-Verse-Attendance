import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/model_controller.dart';
import '../../../core/constant/variables.dart';
import '../../../models/barang_permintaan.dart';
import '../../../models/permintaan_barang.dart';
import '../../../models/tipe_permintaan.dart';
import '../../../shared/dropdown/custom_dropdown.dart';
import '../../../shared/textfieldform.dart';
import '../views/gudang_stok_view.dart';
import '../views/history_permintaan_view.dart';

class PermintaanController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await fetchRolePermintaan();
  }

  @override
  void onClose() {
    debounce?.cancel();
    super.onClose();
  }

  RxInt page = 1.obs;
  RxBool isError = false.obs;
  RxBool isClicked = false.obs;
  RxList<Barang> listBarang = <Barang>[].obs;
  RxList<Barang> selectedBarang = <Barang>[].obs;

  final m = Get.find<ModelController>();

  // permintaan & barang
  String idPermintaan = '';
  String slugPermintaan = '';
  String idTipeBarang = '';
  String kategoriPermintaanText = '';
  int isUrgent = 0;

  RxBool isLoading = false.obs;
  RxBool isEmpty = true.obs;

  Timer? debounce; // Variabel untuk menyimpan Timer debounce

  final kategoriPermintaan = TextEditingController();
  final tipePermintaan = TextEditingController();
  final tipeBarang = TextEditingController();
  final barang = TextEditingController();
  final cariBarang = TextEditingController();

  List<Map<String, dynamic>> sTiperBarang = [
    {"value": "Barang Baru", "id": "barang-baru"},
    {"value": "Barang Pengganti", "id": "barang-pengganti"},
  ];

  Rx<ResponseModelTipePermintaan?> responseModelTipePermintaan =
      Rx<ResponseModelTipePermintaan?>(null);

  Future<void> fetchRolePermintaan() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/permintaan/role'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = ResponseModelTipePermintaan.fromJson(
          await response.stream.bytesToString(),
        );
        responseModelTipePermintaan.value = data;
        log('response model');
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } on SocketException catch (e) {
      // alert jika jaringan error
      throw SocketException(e.toString());
    } catch (e) {
      throw Exception(e);
      // alert jika ada error
    }
  }

  Future<void> fetchBarangByPermintaan({
    required String idPermintaan,
    String? namaBarang = '',
  }) async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    final String uri =
        "${Variables.baseUrl}/permintaan/barang/$idPermintaan?page=${page.value}&nama_barang=$namaBarang";
    final url = Uri.parse(uri);

    debugPrint(uri);

    var request = http.MultipartRequest('GET', url);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = ResponseModelBarangPermintaan.fromJson(
          await response.stream.bytesToString(),
        );
        if (listBarang.isEmpty || page.value == 1) {
          listBarang.assignAll(result.content!);
        } else {
          listBarang.addAll(result.content!);
        }
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logReachedBottom() async {
    page.value = page.value + 1;
    await fetchBarangByPermintaan(idPermintaan: idPermintaan);
    isLoading(false);
  }

  // permintaan custom
  final cDari = TextEditingController();
  final cUntuk = TextEditingController();
  final cNamaBarang = TextEditingController();
  final cJumlah = TextEditingController();
  final cSpesifikasi = TextEditingController();
  final cKebutuhanLain = TextEditingController();
  final cCatatan = TextEditingController();
  final cDiharapSelesai = TextEditingController();
  final cUrgent = TextEditingController();

  bool sUrgent = false;
  final _keyKustom = GlobalKey<FormState>();
  final _keyKertasOrderBesar = GlobalKey<FormState>();
  //

  // permintaan kertas isi buku order besar

  Widget menuPermintaan({
    required String tipePermintaan,
    required BuildContext context,
  }) {
    final result = tipePermintaan.toLowerCase().replaceAll(' ', '-');
    log(result);
    switch (result) {
      case "permintaan-kustom":
        cDari.text = m.u.value.nama!;
        return permintaanKustom(context);
      case "permintaan-material":
        return permintaanMaterial();
      case "permintaan-kertas-cover":
        return permintaanKertasIsiBukuOrderBesar();
      case "permintaan-kertas-isi-buku-order-besar":
        return permintaanKertasIsiBukuOrderBesar();
      case "permintaan-kertas-order-kecil-luar":
        return permintaanKertasOrderKecil();
      case "permintaan-kertas-kesalahan-kekurangan":
        return permintaanKertasOrderKecil();
      default:
        return const Center(child: Text("Terjadi Kesalahan"));
    }
  }

  final cNamaOrder = TextEditingController();
  final cNomorORder = TextEditingController();
  final cJumlahOrder = TextEditingController();
  final _keyKertasOrderKecil = GlobalKey<FormState>();

  Widget permintaanKertasOrderKecil() {
    return Form(
      key: _keyKertasOrderKecil,
      child: Column(
        children: [
          TextfieldForm(
            controller: cNamaOrder,
            labelText: settingsTextfield()[0],
            isRequired: true,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Nomor Order Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cNomorORder,
            labelText: settingsTextfield()[1],
            isRequired: true,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Judul Buku Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cJumlahOrder,
            labelText: settingsTextfield()[2],
            isRequired: true,
            keyboardType: TextInputType.number,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Jumlah Cetak Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "List Barang Diminta",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              IconButton.outlined(
                onPressed: () async {
                  page.value = 1;
                  listBarang.clear();
                  await fetchBarangByPermintaan(
                    idPermintaan: idPermintaan,
                    namaBarang: '',
                  ).then(
                    (value) => Get.to(
                      () => const GudangStokView(),
                      arguments: {
                        "permintaan": this.tipePermintaan.text,
                        "barang": barang.text,
                      },
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Obx(() {
            if (selectedBarang.isEmpty) {
              return Center(
                child: Text(
                  "Belum ada barang diminta",
                  style: GoogleFonts.urbanist(fontSize: 16),
                ),
              );
            } else {
              return Column(
                children: [
                  ...selectedBarang.map(
                    (e) => StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () {
                              final _dialogKey = GlobalKey<FormState>();
                              // Inisialisasi TextEditingController di luar blok if/else untuk menghindari duplikasi
                              final rangkap = TextEditingController();
                              final controller = TextEditingController(
                                text: "${e.jumlahBarang}",
                              );
                              final jenisKertas = TextEditingController();
                              final gramatur = TextEditingController();
                              final warna = TextEditingController();
                              final format = TextEditingController();
                              final urgensi = TextEditingController(
                                text: 'Tidak',
                              );
                              bool? isUrgensi = false;

                              if (e.data != null) {
                                rangkap.text = e.data!['rangkap'] ?? '';
                                jenisKertas.text =
                                    e.data!["jenis_kertas"] ?? '';
                                gramatur.text = e.data!["gramatur"] ?? '';
                                warna.text = e.data!["warna"] ?? '';
                                urgensi.text = e.data!['urgensi']
                                    ? "Ya"
                                    : "Tidak";
                                format.text = e.data!["format"] ?? '';
                                isUrgensi = e.data!['urgensi'] ?? '';
                              }

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    titlePadding: const EdgeInsets.all(15),
                                    title: Text(
                                      e.namaStok ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                    titleTextStyle: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                    content: SizedBox(
                                      width: Get.width,
                                      child: Form(
                                        key: _dialogKey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: rangkap,
                                                labelText: "Rangkap",
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: format,
                                                labelText: "Format",
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: controller,
                                                isRequired: true,
                                                labelText: "Jumlah Barang",
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (p0) {
                                                  if (int.parse(p0!) < 1) {
                                                    return "Jumlah tidak boleh kurang dari 1";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: jenisKertas,
                                                isRequired: true,
                                                labelText: "Jenis Kertas",
                                                validator: (p0) {
                                                  if (p0!.isEmpty) {
                                                    return "*Wajib";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: gramatur,
                                                labelText: "Gramatur",
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: warna,
                                                labelText: "Warna",
                                              ),
                                              const Gap(16),
                                              CustomDropdown(
                                                controller: urgensi,
                                                label: "Urgensi",
                                                hintText: "Ya/Tidak",
                                                onSelected: (p0) =>
                                                    isUrgensi = p0,
                                                items: [
                                                  {"id": true, "value": "Ya"},
                                                  {
                                                    "id": false,
                                                    "value": "Tidak",
                                                  },
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (_dialogKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              log(isUrgensi.toString());
                                              e.data = {
                                                "rangkap": rangkap.text,
                                                "jenis_kertas":
                                                    jenisKertas.text,
                                                "format": format.text,
                                                "gramatur": gramatur.text,
                                                "warna": warna.text,
                                                "jumlah": controller.text,
                                                "urgensi": isUrgensi ?? null,
                                              };
                                            });
                                            Get.back();
                                          }
                                        },
                                        child: Text("Simpan"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tileColor: Colors.grey.shade50,
                            titleTextStyle: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            subtitleTextStyle: GoogleFonts.urbanist(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rangkap: ${e.data?["rangkap"] ?? '-'}"),
                                Text("Format: ${e.data?["format"] ?? '-'}"),
                                Text(
                                  "Jumlah Diminta: ${e.data?["jumlah"] ?? '-'}",
                                ),
                                Text("Warna: ${e.data?["warna"] ?? '-'}"),
                                Text(
                                  "Jenis Kertas: ${e.data?["jenis_kertas"] ?? '-'}",
                                ),
                                Text("Gramatur: ${e.data?["gramatur"] ?? '-'}"),
                                Text(
                                  "Urgensi: ${e.data != null && e.data!['urgensi'] != null ? (e.data?['urgensi'] ? "Ya" : "Tidak") : '-'}",
                                ),
                              ],
                            ),
                            title: Text(e.namaStok ?? ''),
                            trailing: IconButton(
                              onPressed: () {
                                selectedBarang.remove(e);
                              },
                              icon: Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  final cNoOrder = TextEditingController();
  final cJudulBuku = TextEditingController();
  final cJumlahCetak = TextEditingController();

  Widget permintaanKertasIsiBukuOrderBesar() {
    return Form(
      key: _keyKertasOrderBesar,
      child: Column(
        children: [
          TextfieldForm(
            controller: cNoOrder,
            labelText: "Nomor Order",
            isRequired: true,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Nomor Order Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cJudulBuku,
            labelText: "Judul Buku",
            isRequired: true,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Judul Buku Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cJumlahCetak,
            labelText: "Jumlah Cetak",
            isRequired: true,
            keyboardType: TextInputType.number,
            validator: (p0) {
              if (p0!.isEmpty) {
                return "Jumlah Cetak Tidak Boleh Kosong";
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "List Barang Diminta",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              IconButton.outlined(
                onPressed: () async {
                  page.value = 1;
                  listBarang.clear();
                  await fetchBarangByPermintaan(
                    idPermintaan: idPermintaan,
                    namaBarang: '',
                  ).then(
                    (value) => Get.to(
                      () => const GudangStokView(),
                      arguments: {
                        "permintaan": this.tipePermintaan.text,
                        "barang": barang.text,
                      },
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Obx(() {
            if (selectedBarang.isEmpty) {
              return Center(
                child: Text(
                  "Belum ada barang diminta",
                  style: GoogleFonts.urbanist(fontSize: 16),
                ),
              );
            } else {
              return Column(
                children: [
                  ...selectedBarang.map(
                    (e) => StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () {
                              final _dialogKey = GlobalKey<FormState>();
                              // Inisialisasi TextEditingController di luar blok if/else untuk menghindari duplikasi
                              final controller = TextEditingController(
                                text: "${e.jumlahBarang}",
                              );
                              final jenisKertas = TextEditingController();
                              final gramatur = TextEditingController();
                              final warna = TextEditingController();
                              final urgensi = TextEditingController(
                                text: 'Tidak',
                              );
                              final format = TextEditingController();
                              bool? isUrgensi = false;

                              if (e.data != null) {
                                jenisKertas.text =
                                    e.data!["jenis_kertas"] ?? '';
                                gramatur.text = e.data!["gramatur"] ?? '';
                                warna.text = e.data!["warna"] ?? '';
                                urgensi.text = e.data!['urgensi']
                                    ? "Ya"
                                    : "Tidak";
                                format.text = e.data!["format"] ?? '';
                                isUrgensi = e.data!['urgensi'] ?? '';
                              }

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    titlePadding: const EdgeInsets.all(15),
                                    title: Text(
                                      e.namaStok ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                    titleTextStyle: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                    content: SizedBox(
                                      width: Get.width,
                                      child: Form(
                                        key: _dialogKey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextfieldForm(
                                                controller: controller,
                                                isRequired: true,
                                                labelText: "Jumlah Barang",
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (p0) {
                                                  if (int.parse(p0!) < 1) {
                                                    return "Jumlah tidak boleh kurang dari 1";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: jenisKertas,
                                                isRequired: true,
                                                labelText: "Jenis Kertas",
                                                validator: (p0) {
                                                  if (p0!.isEmpty) {
                                                    return "*Wajib";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: format,
                                                labelText: "Format",
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: gramatur,
                                                labelText: "Gramatur",
                                              ),
                                              const Gap(16),
                                              TextfieldForm(
                                                controller: warna,
                                                labelText: "Warna",
                                              ),
                                              const Gap(16),
                                              CustomDropdown(
                                                controller: urgensi,
                                                label: "Urgensi",
                                                hintText: "Ya/Tidak",
                                                onSelected: (p0) =>
                                                    isUrgensi = p0,
                                                items: [
                                                  {"id": true, "value": "Ya"},
                                                  {
                                                    "id": false,
                                                    "value": "Tidak",
                                                  },
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (_dialogKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              log(isUrgensi.toString());
                                              e.data = {
                                                "jenis_kertas":
                                                    jenisKertas.text,
                                                "format": format.text,
                                                "gramatur": gramatur.text,
                                                "warna": warna.text,
                                                "jumlah": controller.text,
                                                "urgensi": isUrgensi ?? null,
                                              };
                                            });
                                            Get.back();
                                          }
                                        },
                                        child: Text("Simpan"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tileColor: Colors.grey.shade50,
                            titleTextStyle: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            subtitleTextStyle: GoogleFonts.urbanist(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jumlah Diminta: ${e.data?["jumlah"] ?? '-'}",
                                ),
                                Text("Warna: ${e.data?["warna"] ?? '-'}"),
                                Text(
                                  "Jenis Kertas: ${e.data?["jenis_kertas"] ?? '-'}",
                                ),
                                Text("Gramatur: ${e.data?["gramatur"] ?? '-'}"),
                                Text(
                                  "Urgensi: ${e.data != null && e.data!['urgensi'] != null ? (e.data?['urgensi'] ? "Ya" : "Tidak") : '-'}",
                                ),
                              ],
                            ),
                            title: Text(e.namaStok ?? ''),
                            trailing: IconButton(
                              onPressed: () {
                                selectedBarang.remove(e);
                              },
                              icon: Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  List<String> settingsTextfield() {
    final tipe = slugPermintaan; // Bersihkan input
    if (tipe == "permintaan-kertas-order-kecil-luar" ||
        tipe == "permintaan-kertas-kesalahan-kekurangan") {
      return ['Nama Order', "Nomor Order", "Jumlah Order"];
    }
    return ["Nomor Order", "Judul Buku", "Jumlah Cetak"];
  }

  Widget permintaanKustom(BuildContext context) {
    return Form(
      key: _keyKustom,
      child: Column(
        children: [
          CustomDropdown(
            controller: kategoriPermintaan,
            onSelected: (p0) {
              kategoriPermintaanText = p0;
            },
            label: "Kategori",
            hintText: "Kategori",
            leadingIcons: Iconsax.category_copy,
            items: [
              {"id": "elektronik", "value": "Elektronik"},
              {"id": "furniture", "value": "Furniture"},
              {"id": "suku cadang", "value": "Suku cadang"},
            ],
          ),
          const Gap(16),
          TextfieldForm(
            controller: cDari,
            readOnly: true,
            labelText: "Dari",
            prefixIcon: Icon(Iconsax.personalcard_copy),
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cUntuk,
            readOnly: false,
            labelText: "Barang Untuk",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Iconsax.people_copy),
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cNamaBarang,
            readOnly: false,
            labelText: "Nama Barang",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Iconsax.box_1_copy),
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cJumlah,
            readOnly: false,
            labelText: "Jumlah Barang",
            keyboardType: TextInputType.number,
            prefixIcon: Icon(Iconsax.note_square_copy),
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cSpesifikasi,
            readOnly: false,
            labelText: "Spesifikasi Barang",
            keyboardType: TextInputType.text,
            maxLines: 4,
            prefixIcon: Icon(Iconsax.box_2_copy),
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          TextfieldForm(
            controller: cKebutuhanLain,
            readOnly: false,
            labelText: "Kebutuhan Lainnya (opsional)",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Iconsax.note_1_copy),
          ),
          const Gap(16),
          TextfieldForm(
            controller: cCatatan,
            readOnly: false,
            labelText: "Catatan (opsional)",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Iconsax.note_1_copy),
          ),
          const Gap(16),
          TextfieldForm(
            controller: cDiharapSelesai,
            readOnly: true,
            prefixIcon: Icon(Iconsax.calendar_copy),
            onTap: () async {
              final picker = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1),
              );

              if (picker != null) {
                cDiharapSelesai.text = DateFormat(
                  "yyyy-MM-dd",
                  "id_ID",
                ).format(picker);
              }
            },
            labelText: "Estimasi Permintaan",
            validator: (value) {
              if (value!.isEmpty) {
                return "*Wajib";
              }
              return null;
            },
          ),
          const Gap(16),
          CustomDropdown(
            controller: cUrgent,
            label: "Urgensi Barang",
            hintText: "Pilih Barang",
            onSelected: (p0) {
              isUrgent = p0;
            },
            leadingIcons: Iconsax.danger_copy,
            items: [
              {"value": "Ya", "id": 1},
              {"value": "Tidak", "id": 0},
            ],
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget permintaanMaterial() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "List Barang Diminta",
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            IconButton.outlined(
              onPressed: () async {
                page.value = 1;
                listBarang.clear();
                await fetchBarangByPermintaan(
                  idPermintaan: idPermintaan,
                  namaBarang: '',
                ).then(
                  (value) => Get.to(
                    () => const GudangStokView(),
                    arguments: {
                      "permintaan": this.tipePermintaan.text,
                      "barang": barang.text,
                    },
                  ),
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        const Gap(16),
        Obx(() {
          if (selectedBarang.isEmpty) {
            return Center(
              child: Text(
                "Belum ada barang diminta",
                style: GoogleFonts.urbanist(fontSize: 16),
              ),
            );
          } else {
            return Column(
              children: [
                ...selectedBarang.map(
                  (e) => StatefulBuilder(
                    builder: (context, setState) {
                      return ListTile(
                        onTap: () {
                          final controller = TextEditingController(
                            text: "${e.jumlahBarang}",
                          );
                          final warna = TextEditingController(
                            text: e.warna ?? '',
                          );
                          final ukuran = TextEditingController(
                            text: e.ukuran ?? '',
                          );
                          final diperlukan = TextEditingController(
                            text: e.diperlukanUntuk ?? '',
                          );
                          final urgensi = TextEditingController(
                            text: e.urgensi ? "Ya" : "Tidak",
                          );
                          bool isUrgensi = false;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                titlePadding: const EdgeInsets.all(15),
                                title: Text(e.namaStok ?? ''),
                                content: SizedBox(
                                  width: Get.width,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextfieldForm(
                                          controller: controller,
                                          labelText: "Jumlah Barang",
                                        ),
                                        const Gap(16),
                                        TextfieldForm(
                                          controller: warna,
                                          labelText: "Warna",
                                        ),
                                        const Gap(16),
                                        TextfieldForm(
                                          controller: ukuran,
                                          labelText: "Ukuran",
                                        ),
                                        const Gap(16),
                                        TextfieldForm(
                                          controller: diperlukan,
                                          labelText: "Diperlukan Untuk",
                                        ),
                                        const Gap(16),
                                        CustomDropdown(
                                          controller: urgensi,
                                          label: "Urgensi",
                                          hintText: "Ya/Tidak",
                                          onSelected: (p0) => isUrgensi = p0,
                                          items: [
                                            {"id": true, "value": "Ya"},
                                            {"id": false, "value": "Tidak"},
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        e.jumlahBarang = int.parse(
                                          controller.text,
                                        );
                                        log(warna.text);
                                        e.warna = warna.text;
                                        e.ukuran = ukuran.text;
                                        e.diperlukanUntuk = diperlukan.text;
                                        e.urgensi = isUrgensi;
                                        Get.back();
                                      });
                                    },
                                    child: Text("Simpan"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        tileColor: Colors.grey.shade50,
                        titleTextStyle: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jumlah Diminta: ${e.jumlahBarang}"),
                            Text("Warna: ${e.warna}"),
                            Text("Ukuran: ${e.ukuran}"),
                            Text("Keperluan: ${e.diperlukanUntuk}"),
                            Text("Urgensi: ${e.urgensi}"),
                          ],
                        ),
                        title: Text(e.namaStok ?? ''),
                        trailing: IconButton(
                          onPressed: () {
                            selectedBarang.remove(e);
                          },
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  Future uploadPermintaanKertasKesalahan({
    required List<dynamic> data,
    required String idPermintaan,
    namaOrder,
    nomorOrder,
    jumlahOrder,
  }) async {
    final encodeData = jsonEncode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "nama_order": namaOrder,
      "nomor_order": nomorOrder,
      "jumlah_order": jumlahOrder,
      "data": data,
    });

    log("logger: ${encodeData}");
  }

  Future uploadPermintaanKertasKecil({
    required List<dynamic> data,
    required String idPermintaan,
    namaOrder,
    nomorOrder,
    jumlahOrder,
  }) async {
    final encodeData = jsonEncode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "nama_order": namaOrder,
      "nomor_order": nomorOrder,
      "jumlah_order": jumlahOrder,
      "data": data,
    });

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/material'),
      );
      request.body = encodeData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
        Get.rawSnackbar(
          messageText: Text(
            "Berhasil mengirimkan data!",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
        // debugPrint(await response.stream.bytesToString());
      } else {
        // debugPrint('${response.reasonPhrase}');
        Get.rawSnackbar(
          messageText: Text(
            "Gagal mengirimkan data!",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      }
    } on SocketException catch (e) {
      Get.rawSnackbar(
        messageText: Text(
          "Terjadi kesalahan pada jaringan!",
          style: GoogleFonts.urbanist(color: Colors.white),
        ),
      );
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e);
    } finally {}
  }

  Future uploadPermintaanKertasCover({
    required List<dynamic> data,
    required String idPermintaan,
    noOrder,
    judulBuku,
    jumlahCetak,
  }) async {
    final encodeData = json.encode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "no_order": noOrder,
      "judul_buku": judulBuku,
      "jumlah_cetak": jumlahCetak,
      "data": data,
    });

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/material'),
      );

      request.body = encodeData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
        Get.rawSnackbar(
          duration: const Duration(seconds: 1),
          messageText: Text(
            "Permintaan Berhasil Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      } else {
        Get.rawSnackbar(
          messageText: Text(
            "Permintaan Gagal Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      }
    } on SocketException catch (e) {
      Get.rawSnackbar(
        messageText: Text("Jaringan Terganggu, Coba Lagi Nanti!"),
      );
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e);
    } finally {}
  }

  Future uploadPermintaanKertasOrderBesar({
    required List<dynamic> data,
    required String idPermintaan,
    noOrder,
    judulBuku,
    jumlahCetak,
  }) async {
    final encodeData = json.encode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "no_order": noOrder,
      "judul_buku": judulBuku,
      "jumlah_cetak": jumlahCetak,
      "data": data,
    });

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/material'),
      );
      request.body = encodeData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
        Get.rawSnackbar(
          duration: const Duration(seconds: 1),
          messageText: Text(
            "Permintaan Berhasil Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      } else {
        Get.rawSnackbar(
          messageText: Text(
            "Permintaan Gagal Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      }
    } on SocketException catch (e) {
      Get.rawSnackbar(
        messageText: Text(
          "Jaringan Terganggu, Coba Lagi Nanti!",
          style: GoogleFonts.urbanist(color: Colors.white),
        ),
      );
      throw SocketException(e.message);
    } catch (e) {
      throw Exception(e);
    }

    log(encodeData);
  }

  Future uploadPermintaanMaterial({
    required List<dynamic> data,
    required String idPermintaan,
  }) async {
    final encodeData = json.encode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "data": data,
    });

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/material'),
      );
      request.body = encodeData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // ... saya memberikan data
        Get.to(() => HistoryPermintaanView(), transition: Transition.cupertino);
        // ... memberikan snackbar
        Get.rawSnackbar(
          duration: const Duration(seconds: 1),
          messageText: Text(
            "Permintaan Berhasil Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      } else {
        Get.rawSnackbar(
          messageText: Text(
            "Permintaan Gagal Dikirimkan",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      }
    } on SocketException catch (e) {
      Get.rawSnackbar(
        messageText: Text("Jaringan Terganggu, Coba Lagi Nanti!"),
      );
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e);
    } finally {}
  }

  Future<void> uploadPermintaanKustom({
    required Map<String, dynamic> data,
  }) async {
    final datadiri = {"pk_dari": m.u.value.nama!, "pk_untuk": cUntuk.text};
    final encodeData = json.encode({
      "tipe_permintaan": idPermintaan,
      "tipe_barang": idTipeBarang,
      "detail": datadiri,
      "data": data,
    });

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/material'),
      );

      request.body = encodeData;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
        Get.rawSnackbar(
          messageText: Text(
            "Berhasil mengirimkan data!",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
        // debugPrint(await response.stream.bytesToString());
      } else {
        debugPrint('${response.reasonPhrase}');
        Get.rawSnackbar(
          messageText: Text(
            "Gagal mengirimkan data!",
            style: GoogleFonts.urbanist(color: Colors.white),
          ),
        );
      }
    } on SocketException catch (e) {
      Get.rawSnackbar(
        messageText: Text(
          "Terjadi kesalahan pada jaringan!",
          style: GoogleFonts.urbanist(color: Colors.white),
        ),
      );
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e);
    } finally {}
  }

  Future<void> onPreseedUpload() async {
    // if (kDebugMode) {
    //   debugPrint(tipePermintaan.text);
    // }
    if (tipePermintaan.text.isEmpty || tipeBarang.text.isEmpty) {
      Get.rawSnackbar(
        messageText: Text(
          "Belum ada permintaan atau tipe barang yang dipilih!",
          style: GoogleFonts.urbanist(color: Colors.white, fontSize: 12),
        ),
      );
      return;
    } else if (selectedBarang.isEmpty &&
        tipePermintaan.text != "Permintaan Kustom") {
      Get.rawSnackbar(
        messageText: Text(
          "Barang yang diminta belum di inputkan. Silahkan pilih barang terlebih dahulu.",
          style: GoogleFonts.urbanist(color: Colors.white, fontSize: 12),
        ),
      );
      return;
    }

    isClicked(true);

    switch (slugPermintaan) {
      case "permintaan-material":
        final data = selectedBarang.map((e) {
          return {
            "id_barang": e.id,
            "jumlah_barang": e.jumlahBarang,
            "warna": e.warna,
            "ukuran": e.ukuran,
            "keperluan": e.diperlukanUntuk,
            "urgensi": e.urgensi,
          };
        }).toList();

        await uploadPermintaanMaterial(data: data, idPermintaan: idPermintaan);
        break;
      case "permintaan-kustom":
        if (_keyKustom.currentState!.validate()) {
          // masukan input disini
          final data = {
            "pk_jumlah": cJumlah.text,
            "pk_catatan": cCatatan.text,
            "pk_kategori": kategoriPermintaanText,
            "pk_is_urgent": isUrgent.toString(),
            "pk_nama_barang": cNamaBarang.text,
            "pk_spesifikasi": cSpesifikasi.text,
            "pk_kebutuhan_lain": cKebutuhanLain.text,
            "pk_diharap_selesai": cDiharapSelesai.text,
          };

          uploadPermintaanKustom(data: data);
        }
        break;
      case "permintaan-kertas-order-kecil-luar":
        if (_keyKertasOrderKecil.currentState!.validate()) {
          bool isCompleted = true;
          selectedBarang.forEach((element) {
            if (element.data == null ||
                element.data!["jumlah"] == null ||
                element.data!["jenis_kertas"] == null) {
              isCompleted = false;
              Get.rawSnackbar(
                messageText: Text(
                  "Barang ${element.namaStok} belum lengkap",
                  style: GoogleFonts.urbanist(color: Colors.white),
                ),
              );
            }
          });

          if (isCompleted) {
            log('berhasil mengirimkan permintaan kertas order kecil');
            final data = selectedBarang.map((e) {
              return {
                "pkok_id": e.id,
                "pkok_qty": e.data!['jumlah'],
                "pkok_warna": e.data!['warna'],
                "pkok_format": e.data!['format'],
                "pkok_rangkap": e.data!['rangkap'],
                "pkok_gramatur": e.data!['gramatur'],
                "pkok_is_urgent": e.data!['urgensi'],
              };
            }).toList();

            await uploadPermintaanKertasKecil(
              data: data,
              idPermintaan: idPermintaan,
              namaOrder: cNamaOrder.text,
              nomorOrder: cNomorORder.text,
              jumlahOrder: cJumlahOrder.text,
            );
          }
        }
        break;
      case "permintaan-kertas-cover":
        if (_keyKertasOrderBesar.currentState!.validate()) {
          bool isCompleted = true;
          selectedBarang.forEach((element) {
            if (element.data == null ||
                element.data!["jumlah"] == null ||
                element.data!["jenis_kertas"] == null) {
              isCompleted = false;
              Get.rawSnackbar(
                messageText: Text(
                  "Barang ${element.namaStok} belum lengkap",
                  style: GoogleFonts.urbanist(color: Colors.white),
                ),
              );
            }
          });

          if (isCompleted) {
            log('berhasil mengirimkan permintaan kertas cover');
            final data = selectedBarang.map((e) {
              return {
                "pkc_id": e.id,
                "pkc_qty": e.data!['jumlah'],
                "pkc_warna": e.data!['warna'],
                "pkc_format": e.data!['format'],
                "pkc_gramatur": e.data!['gramatur'],
                "pkc_is_urgent": e.data!['urgensi'],
              };
            }).toList();

            await uploadPermintaanKertasCover(
              data: data,
              idPermintaan: idPermintaan,
              judulBuku: cJudulBuku.text,
              jumlahCetak: cJumlahCetak.text,
              noOrder: cNoOrder.text,
            );
          }
        }
        break;
      case "permintaan-kertas-isi-buku-order-besar":
        if (_keyKertasOrderBesar.currentState!.validate()) {
          bool isCompleted = true;
          for (var element in selectedBarang) {
            if (element.data == null ||
                element.data!["jumlah"] == null ||
                element.data!["jenis_kertas"] == null) {
              isCompleted = false;
              Get.rawSnackbar(
                messageText: Text(
                  "Barang ${element.namaStok} belum lengkap",
                  style: GoogleFonts.urbanist(color: Colors.white),
                ),
              );
            }
          }

          if (isCompleted) {
            final data = selectedBarang.map((e) {
              return {
                "pki_id": e.id,
                "pki_qty": e.data!['jumlah'],
                "pki_warna": e.data!['warna'],
                "pki_format": e.data!['format'],
                "pki_gramatur": e.data!['gramatur'],
                "pki_is_urgent": e.data!['urgensi'],
              };
            }).toList();

            log('pemintaan kertas isi buku order besar');
            await uploadPermintaanKertasOrderBesar(
              data: data,
              idPermintaan: idPermintaan,
              judulBuku: cJudulBuku.text,
              jumlahCetak: cJumlahCetak.text,
              noOrder: cNoOrder.text,
            );
          }
        }

        break;
      case 'permintaan-kertas-kesalahan-kekurangan':
        if (_keyKertasOrderKecil.currentState!.validate()) {
          bool isCompleted = true;
          for (var element in selectedBarang) {
            if (element.data == null ||
                element.data!["jumlah"] == null ||
                element.data!["jenis_kertas"] == null) {
              isCompleted = false;
              Get.rawSnackbar(
                messageText: Text(
                  "Barang ${element.namaStok} belum lengkap",
                  style: GoogleFonts.urbanist(color: Colors.white),
                ),
              );
            }
          }

          if (isCompleted) {
            log('berhasil mengirimkan permintaan kertas order kecil');
            final data = selectedBarang.map((e) {
              return {
                "pkk_id": e.id,
                "pkk_qty": e.data!['jumlah'],
                "pkk_warna": e.data!['warna'],
                "pkk_format": e.data!['format'],
                "pkk_rangkap": e.data!['rangkap'],
                "pkk_gramatur": e.data!['gramatur'],
                "pkk_is_urgent": e.data!['urgensi'],
              };
            }).toList();

            await uploadPermintaanKertasKesalahan(
              data: data,
              idPermintaan: idPermintaan,
              namaOrder: cNamaOrder.text,
              nomorOrder: cNomorORder.text,
              jumlahOrder: cJumlahOrder.text,
            );
          }
        }
        break;
      default:
    }

    isClicked(false);
  }

  // history permintaan
  int paginate = 1;
  RxBool isEmptyBarang = false.obs;
  RxList<PermintaanBarang> historyPermintaanBarang = <PermintaanBarang>[].obs;

  Future<void> logReachBottomPermintaan({
    required int month,
    required int year,
  }) async {
    paginate++;
    isLoading(true);

    try {
      await fetchHistoryPermintaan(month: month, year: year);
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void _sortingStatus() {
    const statusOrder = {
      "pending": 0,
      "antrian": 1,
      "proses": 2,
      "partially ready": 3,
      "ready": 4,
      "partially done": 5,
      "done": 6,
      "decline": 7,
      "cancel": 8,
      "waiting": 9,
      "default": 10,
    };

    historyPermintaanBarang.sort((a, b) {
      final statusComparison = (statusOrder[a.status] ?? 1).compareTo(
        statusOrder[b.status] ?? 0,
      );

      if (statusComparison == 0) {
        return b.tanggalPermintaan!.compareTo(a.tanggalPermintaan!);
      }

      return statusComparison;
    });
  }

  Future<void> fetchHistoryPermintaan({
    required int month,
    required int year,
  }) async {
    try {
      isLoading(true);

      var response = await http.post(
        Uri.parse('${Variables.baseUrl}/permintaan/tracking'),
        body: {"month": "$month", "year": "$year"},
        headers: {'Authorization': 'Bearer ${m.token.value}'},
      );

      if (response.statusCode == 200) {
        final str = response.body;
        final data = ResponseModelPermintaanBarang.fromRawJson(str);

        historyPermintaanBarang.clear();
        if (data.content != null && data.content!.isNotEmpty) {
          isEmptyBarang(false);
          historyPermintaanBarang.addAll(data.content!);
          _sortingStatus();
        } else if (data.content == null || data.content!.isEmpty) {
          if (historyPermintaanBarang.isEmpty) {
            isEmptyBarang(true);
          }
        }
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      isError(true);
      debugPrint('Fetch error: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> penerimaanPermintaan({
    required String permintaanId,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/permintaan/penerimaan'),
      );
      request.body = json.encode({
        "permintaan_id": permintaanId,
        "catatan": "dikirimkan dari mobile",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final str = await response.stream.bytesToString();
      Map<String, dynamic> decode = jsonDecode(str);

      if (response.statusCode == 200) {
        return decode;
      } else {
        return decode;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
