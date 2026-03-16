import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/components/custom_empty_submission.dart';
import '../../../../core/components/tile/custom_tile_emergency_contact.dart';
import '../../../../data/model/emergency_contact_response_model.dart';
import '../../../../shared/button/button_1.dart';
import '../../../../shared/loading/loading1.dart';
import '../../controllers/emergency_contact_controller.dart';
import 'add_emergency_contact_view.dart';

class EmergencyContactView extends StatefulWidget {
  const EmergencyContactView({super.key});

  @override
  State<EmergencyContactView> createState() => _EmergencyContactViewState();
}

class _EmergencyContactViewState extends State<EmergencyContactView> {
  final controller = EmergencyContactController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Kontak Darurat'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(AddEmergencyContactView());
              setState(() {});
            },
            icon: Icon(Iconsax.edit_copy),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.fetchEmergencyContact(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.data!.data!.isEmpty) {
            return CustomEmptySubmission(
              title: 'Tidak Ada Info Kontak Darurat',
              subtitle: 'Belum ada kontak darurat, silakan tambahkan kontak darurat anda',
            );
          }
          else if (snapshot.hasData) {
            EmergencyContactResponseModel listContact = snapshot.data;

            return ListView.builder(
              itemCount: listContact.data!.length,
              itemBuilder: (context, index) {
                Contact data = listContact.data![index];
                return CustomTileEmergencyContact(
                  onTapPhone: () async {
                    String number = data.noTelp!;
                    String formattedNumber = "+62" + number.substring(1);
                    Uri url = Uri.parse('https://wa.me/$formattedNumber');
                    if (!await launchUrl(url)) {
                      throw 'Could not launch $url';
                    }
                  },
                  onTapOption: () {
                    _showOptionsBottomSheet(id: data.id!, contact: data);
                  },
                  nama: data.nama ?? "",
                  hubungan: data.hubungan ?? "",
                  notelp: data.noTelp ?? "",
                );
              },
            );
          }
          return Text('Tidak Ada Info Kontak Darurat');
        },
      ),
    );
  }

  void _showOptionsBottomSheet({required int id, required Contact contact}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button1(
              title: 'Edit',
              onTap: () async {
                Get.back();
                await Get.to(
                  () => AddEmergencyContactView(),
                  arguments: contact,
                );
                setState(() {});
              },
            ),
            const Gap(10),
            Button1(
              title: 'Hapus',
              onTap: () async {
                await controller.deleteEmergencyContact(id: id);
                setState(() {});
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
