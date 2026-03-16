import 'package:flutter/material.dart';

import 'package:another_stepper/another_stepper.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../controllers/model_controller.dart';
import '../../../shared/images/images.dart';
import '../../../shared/utils.dart';

class DetailUpdateDataView extends GetView {
  DetailUpdateDataView({super.key});

  final m = Get.find<ModelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: greenColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text('Disetujui', style: TextStyle(color: whiteColor)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: Get.width,
                    color: greyColor.withAlpha(50),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ImageNetwork(
                              boxFit: BoxFit.cover,
                              url: m.u.value.avatar!,
                              borderRadius: 100,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            '${m.u.value.nama}',
                            style: TextStyle(
                              fontWeight: semiBold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${m.u.value.jabatan}',
                            style: TextStyle(
                              fontWeight: regular,
                              fontSize: 12,
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Info Pengajuan',
                      style: TextStyle(fontWeight: semiBold, fontSize: 16),
                    ),
                  ),
                  const Gap(20),
                  Divider(height: 0, thickness: 1, color: greyColor),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Gambar Profile',
                            style: TextStyle(fontSize: 16),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              color: Colors.amber.withAlpha(30),
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ImageNetwork(
                                      url: m.u.value.avatar!,
                                      borderRadius: 100,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                  Icon(Icons.arrow_right_alt_outlined),
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ImageNetwork(
                                      url: m.u.value.avatar!,
                                      borderRadius: 100,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 0, thickness: 1, color: greyColor),
                        ExpansionTile(
                          title: Text(
                            'Tanggal Persetujuan',
                            style: TextStyle(fontSize: 16),
                          ),
                          children: [
                            Container(
                              color: Colors.amber.withAlpha(25),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: AnotherStepper(
                                stepperList: [
                                  StepperData(
                                    title: StepperText(
                                      "Menunggu disetujui oleh Maria Setiawati Purbaningtyas",
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: StepperText(
                                      "02 Apr 2024 10:19",
                                      textStyle: TextStyle(),
                                    ),
                                  ),
                                  StepperData(
                                    title: StepperText(
                                      "Diajukan",
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: StepperText(
                                      "02 Apr 2024 10:19",
                                      textStyle: TextStyle(),
                                    ),
                                  ),
                                ].reversed.toList(),
                                inverted: false,
                                activeIndex: 0,
                                stepperDirection: Axis.vertical,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 0, thickness: 1, color: greyColor),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Deskripsi',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Foto',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 0, thickness: 1, color: greyColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // back button
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                leading: new IconButton(
                  icon: new Icon(
                    Iconsax.arrow_left_2_copy,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: transparentColor,
                elevation: 0.0, //No shadow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
