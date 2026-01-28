import 'package:lancar_cat/app/models/time_off_request.dart';
import 'package:lancar_cat/app/shared/images/images.dart';
import 'package:lancar_cat/app/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class DetailInboxView extends StatefulWidget {
  const DetailInboxView({Key? key}) : super(key: key);

  @override
  State<DetailInboxView> createState() => _DetailInboxViewState();
}

class _DetailInboxViewState extends State<DetailInboxView> {
  TimeOffRequest? timeOffRequest;

  @override
  void initState() {
    super.initState();
    timeOffRequest = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Inbox'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GestureDetector(
          onTap: () {
            Get.bottomSheet(
              backgroundColor: whiteColor,
              Container(
                padding: const EdgeInsets.all(18.0),
                width: Get.width,
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ImageNetwork(url: ''),
                        const Gap(20),
                        Expanded(
                          child: Text(
                            '${timeOffRequest!.superadmin!.nama}',
                            style: TextStyle(
                              color: indigoColor,
                              fontSize: 14,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Iconsax.close_circle_copy),
                        ),
                      ],
                    ),
                    const Gap(10),
                    TileDetailInbox('ID Karyawan', '${timeOffRequest!.id}'),
                    TileDetailInbox('Organisasi', 'Personalia & Umum'),
                    TileDetailInbox('Posisi Pekerjaan', 'Staff Personalia'),
                    TileDetailInbox(
                      'Cabang',
                      'CV Andi Offset Yogyakarta Pusat',
                    ),
                  ],
                ),
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: ImageNetwork(
                      url: '${timeOffRequest!.superadmin!.avatar}',
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${timeOffRequest!.superadmin!.nama}',
                        style: TextStyle(
                          color: indigoColor,
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                      Text(
                        'Cuti sudah disetujui',
                        style: TextStyle(color: blackColor, fontSize: 12),
                      ),
                      Text(
                        '${DateFormat('dd MMM yyyy - HH:mm').format(DateTime.parse(timeOffRequest!.dateApprovalSuperadmin!))}',
                        // '${timeOffRequest!.dateApprovalSuperadmin}',
                        style: TextStyle(fontSize: 10, color: greyColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column TileDetailInbox(String title, String subTitle) {
    return Column(
      children: [
        Gap(10),
        Row(
          children: [
            Expanded(child: Text('${title}', style: TextStyle(fontSize: 14))),
            Text(":", style: TextStyle(fontSize: 14)),
            const Gap(10),
            Expanded(
              child: Text(
                textAlign: TextAlign.start,
                '${subTitle}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
