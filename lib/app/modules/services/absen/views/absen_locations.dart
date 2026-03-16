import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../controllers/model_controller.dart';
import '../../../../models/location.dart';
import '../../../../shared/utils.dart';
import 'detail_locations_absen_view.dart';

class AbsenLocationsView extends StatefulWidget {
  const AbsenLocationsView({super.key});

  @override
  State<AbsenLocationsView> createState() => _AbsenLocationsViewState();
}

class _AbsenLocationsViewState extends State<AbsenLocationsView> {
  final m = Get.find<ModelController>();

  int banyakLokasi = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        title: const Text('Lokasi Absensi'),
      ),
      body: ListView.builder(
        itemCount: m.locations.value.locations!.length,
        itemBuilder: (context, index) {
          Location loc = m.locations.value.locations![index];

          return ListTile(
            onTap: () =>
                Get.to(() => DetailLocationsAbsenView(), arguments: loc),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            shape: UnderlineInputBorder(
              borderSide: BorderSide(color: greyColor, width: 0.5),
            ),
            titleTextStyle: GoogleFonts.varelaRound(
              color: blackColor,
              fontSize: 15,
              fontWeight: medium,
            ),
            subtitleTextStyle: GoogleFonts.varelaRound(
              color: greyColor,
              fontSize: 12,
            ),
            trailing: Icon(Iconsax.arrow_right_3_copy),
            title: Text(loc.locName!),
            subtitle: Text(loc.address!),
          );
        },
      ),
    );
  }
}
