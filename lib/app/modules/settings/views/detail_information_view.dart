import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/modules/update/views/update_data_view.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../shared/tile/tile2.dart';

class DetailInformationView extends StatefulWidget {
  const DetailInformationView({super.key});

  @override
  State<DetailInformationView> createState() => _DetailInformationViewState();
}

class _DetailInformationViewState extends State<DetailInformationView> {
  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Personal'),
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(
                () => UpdateDataView(),
                transition: Transition.cupertino,
              );
              setState(() {});
            },
            icon: Icon(Iconsax.message_edit_copy, color: whiteColor),
          ),
          const Gap(5),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await a.fetchCurrentUser();
          setState(() {});
        },
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            children: [
              const Gap(10),
              ListTile2(
                title: 'Nama Depan',
                subTitle: m.u.value.nama!,
                icons: Icons.person,
                iconColor: Colors.amber, // 👤 biru
              ),
              ListTile2(
                title: 'Email',
                subTitle: m.u.value.email!,
                icons: Icons.email,
                iconColor: Colors.deepPurple, // 📧 ungu
              ),
              ListTile2(
                title: 'Jenis Kelamin',
                subTitle: checkIsEmpty(m.u.value.jenisKelamin),
                icons: Icons.wc,
                iconColor: Colors.pink, // 🚻 pink/ungu muda
              ),
              ListTile2(
                title: 'Tempat Lahir',
                subTitle: checkIsEmpty(m.u.value.tempatLahir),
                icons: Icons.location_city,
                iconColor: Colors.orange, // 🏙️ oranye
              ),
              ListTile2(
                title: 'Tanggal Lahir',
                subTitle: m.u.value.tanggalLahir == null
                    ? '-'
                    : DateFormat(
                        'dd MMMM yyyy',
                        'id_ID',
                      ).format(m.u.value.tanggalLahir!),
                icons: Icons.cake,
                iconColor: Colors.redAccent, // 🎂 merah
              ),
              ListTile2(
                title: 'Handphone',
                subTitle: checkIsEmpty(m.u.value.telepon),
                icons: Icons.phone_android,
                iconColor: Colors.amber, // 📱 hijau
              ),
              ListTile2(
                title: 'Status Pernikahan',
                subTitle: checkIsEmpty(m.u.value.statusPernikahan),
                icons: Icons.favorite,
                iconColor: Colors.pinkAccent, // ❤️ pink
              ),
              ListTile2(
                title: 'Agama',
                subTitle: checkIsEmpty(m.u.value.agama),
                icons: Icons.self_improvement,
                iconColor: Colors.teal, // ☯️ teal
              ),
              ListTile2(
                title: 'Alamat',
                subTitle: m.u.value.alamat ?? '-',
                icons: Icons.home,
                iconColor: Colors.indigo, // 🏠 biru tua
              ),
              ListTile2(
                title: 'Golongan Darah',
                subTitle: m.u.value.golDarah ?? '-',
                icons: Icons.bloodtype,
                iconColor: Colors.red, // 🩸 merah
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkIsEmpty(String? value) {
    return value ?? "-";
  }
}
