import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../models/barang_permintaan.dart';
import '../../../shared/textfieldform.dart';
import '../controllers/permintaan_controller.dart';

class GudangStokView extends GetView<PermintaanController> {
  const GudangStokView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stok Barang'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  color: Colors.grey.shade200,
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: TextfieldForm(
              controller: controller.cariBarang,
              hintText: "Cari barang...",
              suffixIcon: IconButton(
                onPressed: () => controller.cariBarang.clear(),
                icon: Icon(Icons.clear),
              ),
              prefixIcon: Icon(Iconsax.search_normal_copy),
              onChanged: (p0) {
                // Batalkan Timer sebelumnya jika ada
                if (controller.debounce?.isActive ?? false) {
                  controller.debounce?.cancel();
                }

                // Set Timer baru untuk menjalankan fungsi setelah 1 detik
                controller.debounce = Timer(
                  const Duration(seconds: 1),
                  () async {
                    controller.listBarang.clear();
                    controller.page.value = 1;
                    await controller.fetchBarangByPermintaan(
                      idPermintaan: controller.idPermintaan,
                      namaBarang: p0,
                    );
                  },
                );
              },
            ),
          ),
          Obx(
            () => Expanded(
              child: NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    // Cek apakah pengguna telah mencapai batas bawah
                    final metrics = notification.metrics;
                    if (metrics.pixels >= metrics.maxScrollExtent) {
                      controller.isLoading(true);
                      controller.logReachedBottom();
                    }
                  }
                  return true; // Return true untuk menandakan notifikasi telah ditangani
                },
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: controller.listBarang.length + 1,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (controller.listBarang.length == index) {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return SizedBox();
                    }
                    Barang barang = controller.listBarang[index];
                    final outOfStok = barang.outOfStock == 1;

                    return InkWell(
                      onTap: () {
                        controller.selectedBarang.add(barang);
                        Get.back();
                      },
                      child: Card(
                        key: ValueKey(barang.id),
                        color: Colors.white,
                        shadowColor: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama Barang',
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      barang.namaStok ?? "-",
                                      maxLines: 2,
                                      softWrap: true,
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(10),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: .7,
                                    color: outOfStok
                                        ? Colors.red
                                        : Colors.amber,
                                  ),
                                  color: outOfStok
                                      ? Colors.red.shade50
                                      : Colors.amber.shade50,
                                ),
                                child: Text(
                                  outOfStok ? "Stok Habis" : "Stok Tersedia",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: outOfStok
                                        ? Colors.red.shade800
                                        : Colors.amber.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
