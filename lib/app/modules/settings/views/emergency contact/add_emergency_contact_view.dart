import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../data/model/emergency_contact_response_model.dart';
import '../../../../shared/button/button_1.dart';
import '../../../../shared/textfield/textfield_1.dart';
import '../../controllers/emergency_contact_controller.dart';

class AddEmergencyContactView extends StatefulWidget {
  const AddEmergencyContactView({super.key});

  @override
  State<AddEmergencyContactView> createState() =>
      _AddEmergencyContactViewState();
}

class _AddEmergencyContactViewState extends State<AddEmergencyContactView> {
  final nama = TextEditingController();
  final hubungan = TextEditingController();
  final notelp = TextEditingController();

  final controller = EmergencyContactController();

  int id = 0;

  Contact? status;

  @override
  void initState() {
    super.initState();
    status = Get.arguments;

    if (status != null) {
      id = status!.id!;
      nama.text = status!.nama!;
      hubungan.text = status!.hubungan!;
      notelp.text = status!.noTelp!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (status == null) ? 'Tambah Kontak Darurat' : 'Edit Kontak Darurat',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const Gap(10),
            TextField1(
              controller: nama,
              maxLines: 1,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              preffixIcon: Icon(Iconsax.user_copy),
              isTextShowing: true,
              hintText: 'Nama',
            ),
            const Gap(10),
            FutureBuilder(
              future: controller.fetchOptionsContactRelations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final options = snapshot.data;
                  debugPrint(options);
                  return TextField1(
                    controller: hubungan,
                    preffixIcon: Icon(Iconsax.personalcard_copy),
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    hintText: 'Hubungan',
                    isTextShowing: true,
                    readOnly: true,
                    onTap: () => _showOptionsHubungan(options),
                  );
                }
                return Text('test');
              },
            ),
            const Gap(10),
            TextField1(
              controller: notelp,
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              preffixIcon: Icon(Iconsax.call_copy),
              isTextShowing: true,
              hintText: 'Nomor Telepon',
            ),
            const Spacer(),
            Button1(
              title: (status == null) ? "Tambah" : "Edit",
              onTap: () async {
                if (status == null) {
                  await controller.storeEmergencyContact(
                    nama: nama.text,
                    hubungan: hubungan.text,
                    notelp: notelp.text,
                  );
                  Get.back();
                } else {
                  // edit data
                  await controller.updateEmergencyContact(
                    id: id,
                    nama: nama.text,
                    hubungan: hubungan.text,
                    notelp: notelp.text,
                  );
                  Get.back();
                }
              },
            ),
            const Gap(10),
            Button1(
              title: 'Batalkan',
              backgroundColor: Colors.transparent,
              showOutline: false,
              color: Colors.amber.shade900,
              onTap: () => Get.back(),
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  void _showOptionsHubungan(List<String> options) {
    showModalBottomSheet(
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: Get.height * 0.7,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Get.back();
                  hubungan.text = options[index];
                },
                title: Text(options[index]),
              );
            },
          ),
        );
      },
    );
  }
}
