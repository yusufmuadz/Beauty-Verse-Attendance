import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../../../shared/dropdown/custom_dropdown.dart';
import '../controllers/permintaan_controller.dart';
import 'history_permintaan_view.dart';

class PermintaanView extends GetView<PermintaanController> {
  const PermintaanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Permintaan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.historyPermintaanBarang.clear();
              Get.to(() => HistoryPermintaanView());
            },
            icon: Icon(Iconsax.document),
          ),
          Obx(
            () => IconButton(
              onPressed: controller.isClicked.value
                  ? null
                  : controller.onPreseedUpload,
              icon: Icon(Iconsax.arrow_up),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Obx(
              () => (controller.responseModelTipePermintaan.value == null)
                  ? const LinearProgressIndicator()
                  : CustomDropdown(
                      controller: controller.tipePermintaan,
                      label: "Tipe Permintaan",
                      hintText: "Contoh: Permintaan Material",
                      onSelected: (p0) {
                        controller.isEmpty(true);
                        controller.idPermintaan = p0;
                        controller.selectedBarang.clear();
                        controller.slugPermintaan = controller
                            .responseModelTipePermintaan
                            .value!
                            .content!
                            .where((element) => element.id == p0)
                            .first
                            .slug
                            .toString();
                        controller.isEmpty(false);
                      },
                      items:
                          controller.responseModelTipePermintaan.value == null
                          ? []
                          : controller
                                .responseModelTipePermintaan
                                .value!
                                .content!
                                .map((e) => {"value": e.name, "id": e.id})
                                .toList(),
                    ),
            ),
            const Gap(16),
            CustomDropdown(
              controller: controller.tipeBarang,
              onSelected: (p0) => controller.idTipeBarang = p0,
              label: "Tipe Barang",
              hintText: "Barang Baru / Barang Pengganti",
              items: controller.sTiperBarang,
            ),
            const Gap(16),
            Obx(
              () => controller.isEmpty.value
                  ? const SizedBox()
                  : controller.menuPermintaan(
                      tipePermintaan: controller.slugPermintaan,
                      context: context,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
