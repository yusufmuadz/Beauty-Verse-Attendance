// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart';

import 'package:lancar_cat/app/models/location.dart';

class DetailLocationsAbsenView extends StatefulWidget {
  const DetailLocationsAbsenView({super.key});

  @override
  State<DetailLocationsAbsenView> createState() =>
      _DetailLocationsAbsenViewState();
}

class _DetailLocationsAbsenViewState extends State<DetailLocationsAbsenView> {
  late Location location;

  @override
  void initState() {
    super.initState();
    location = Get.arguments as Location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Lokasi Absensi'),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          maxZoom: 18,
          minZoom: 17,
          keepAlive: false,
          initialCenter: LatLng(
            double.parse(location.lat!),
            double.parse(location.lng!),
          ),
          initialZoom: 17,
          interactionOptions: InteractionOptions(flags: ~InteractiveFlag.all),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            maxZoom: 19,
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  double.parse(location.lat!),
                  double.parse(location.lng!),
                ),
                width: 80,
                height: 80,
                child: Icon(Iconsax.gps_copy, color: Colors.amber.shade900),
              ),
            ],
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(
                  double.parse(location.lat!),
                  double.parse(location.lng!),
                ),
                color: Colors.amber.withValues(alpha: 0.1),
                borderColor: Colors.grey,
                borderStrokeWidth: 1,
                radius: location.radius!.toDouble(),
                useRadiusInMeter: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
