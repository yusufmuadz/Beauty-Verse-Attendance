import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/models/location.dart';
import 'package:lancar_cat/app/modules/camera_capture/controllers/camera_capture_controller.dart';
import 'package:lancar_cat/app/modules/camera_capture/views/camera_capture_view.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/images/images.dart';
import 'package:lancar_cat/app/shared/snackbar/snackbar_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../controllers/locations_tracker_controller.dart';

class LocationsTrackerView extends StatefulWidget {
  const LocationsTrackerView({super.key, this.note});
  final String? note;

  @override
  State<LocationsTrackerView> createState() => _LocationsTrackerViewState();
}

class _LocationsTrackerViewState extends State<LocationsTrackerView> {
  final controller = Get.put(LocationsTrackerController());
  final camera = Get.put(CameraCaptureController());
  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  Position? position;

  @override
  void initState() {
    super.initState();
    controller.isLoading(true);
    controller.isStreamEnable(true);
  }

  @override
  void dispose() {
    controller.locationStreamController.close();
    controller.isStreamEnable(false);
    position = null;
    super.dispose();
  }

  checkCurrentLocation() async {
    bool isEnabled = await controller.g.askingPermission();

    if (!isEnabled) {
      Snackbar().snackbar1(
        'Izinkan Akses Lokasi',
        'perizinan untuk lokasi',
        Iconsax.location,
        whiteColor,
        redColor,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Lokasi'),
        centerTitle: true,
        actions: [
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                Geolocator.getCurrentPosition(
                  locationSettings: LocationSettings(
                    accuracy: LocationAccuracy.bestForNavigation,
                  ),
                ).then((value) {
                  m.lat(value.latitude);
                  m.lng(value.longitude);
                });

                controller.turns.value -= 5 / 1;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AnimatedRotation(
                  turns: controller.turns.value,
                  duration: const Duration(seconds: 2),
                  child: Icon(Iconsax.refresh_copy),
                ),
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: controller.streamPositionV2(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingMaps();
              } else if (snapshot.hasData) {
                position = snapshot.data!;
                return _flutterMaps(position: position!);
              } else {
                return const Center(
                  child: Text('Terjadi Kesalahan Saat Memuat Peta!'),
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Material(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(100),
                    child: IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            elevation: 10,
                            title: Text(
                              "INFORMASI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: semiBold,
                                fontSize: 18,
                              ),
                            ),
                            content: Text(
                              'Tunggu hingga posisi anda berada di dalam jangkauan kantor, map akan otomatis ter-update',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            actions: [
                              Button1(
                                title: 'Laporkan Terjadi Masalah..!',
                                onTap: () {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Iconsax.info_circle_copy, color: redColor),
                    ),
                  ),
                ),
                Obx(() => Text(m.lat.value.toString())),
                Container(
                  padding: const EdgeInsets.all(15),
                  color: whiteColor,
                  width: Get.width,
                  child: Obx(
                    () => Button1(
                      title: controller.textB.value,
                      showOutline: false,
                      onTap: _onTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future checkMockLocation() async {
    return await DetectFakeLocation().detectFakeLocation();
  }

  _setButtonEnabled() {
    controller.textB("Cek lokasi");
    controller.isLoading(true);
  }

  _setButtonDisabled() {
    controller.textB('Tunggu sebentar..');
    controller.isLoading(false);
  }

  _onTap() async {
    // Fake GPS location checker
    if (await checkMockLocation()) {
      Get.snackbar('Gagal...', "Anda terdeteksi menggunkan fake gps");
      return;
    }

    if (position == null) return;
    if (!controller.isLoading.value) return; // NOTE: Loading state
    _setButtonDisabled();

    Locations? locations = await a.locations(); // locations active checker

    if (locations == null) {
      _setButtonEnabled();
      Get.defaultDialog(
        radius: 10,
        title: 'Gagal..!',
        content: Text('Hubungi personalia untuk memastikan lokasi anda aktif.'),
      );
      return;
    } else if (locations.setting == null) {
      _setButtonEnabled();
      Get.defaultDialog(
        radius: 10,
        title: 'Gagal..!',
        content: Text('Terjadi kesalahan, silahkan coba lagi.'),
      );
      return;
    }

    m.lat(position!.latitude);
    m.lng(position!.longitude);

    // buatkan jika flexible dan argument tidak sama dengan 1
    if (locations.setting!.flexible == '0' && Get.arguments != '1') {
      // NOTE: When locations is not flexible
      await controller.checkCurrentLocationV2(
        Get.arguments ?? "",
        widget.note ?? "",
        "${position!.latitude}",
        "${position!.longitude}",
      );
      return;
    }

    if (Get.arguments == '1') {
      // NOTE: This is when user want to submit permit out/in
      await LocationsTrackerController().onPressSubmitPermit(
        note: widget.note ?? "",
        position: position!,
      );
      _setButtonEnabled();
      return;
    } else {
      Get.to(() => CameraCaptureView(), arguments: Get.arguments ?? "");
      _setButtonEnabled();
    }
  }

  _flutterMaps({required Position position}) {
    return FlutterMap(
      options: MapOptions(
        maxZoom: 18,
        minZoom: 17,
        keepAlive: false,
        initialCenter: LatLng(position.latitude, position.longitude),
        initialZoom: 17,
        interactionOptions: InteractionOptions(flags: ~InteractiveFlag.all),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          maxZoom: 19,
          // Plenty of other options available!
        ),

        // TileLayer(
        //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        //   userAgentPackageName: 'com.ags.lancar_cat',
        //   maxZoom: 19,
        //   // urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
        //   subdomains: ['a', 'b', 'c', 'd'],
        //   tileProvider: NetworkTileProvider(
        //     headers: {
        //       'User-Agent': 'FlutterMapApp/1.0 (com.ags.lancar_cat)',
        //       'Accept': '*/*',
        //     },
        //   ),
        //   // Plenty of other options available!
        // ),

        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.always,
          alignDirectionOnUpdate: AlignOnUpdate.never,
          style: LocationMarkerStyle(
            showHeadingSector: false,
            marker: DefaultLocationMarker(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ImageNetwork(
                  boxFit: BoxFit.cover,
                  url: m.u.value.avatar!,
                ),
              ),
            ),
            markerSize: const Size(40, 40),
            markerDirection: MarkerDirection.top,
          ),
        ), // <
      ],
    );
  }
}

class LoadingMaps extends StatelessWidget {
  const LoadingMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset('assets/gif/loading.gif', width: 100, height: 100),
        ),
        Text(
          'Sedang Memuat Peta...\nDisarankan menggunakan data selular',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Figtree', fontSize: 13.5),
        ),
      ],
    );
  }
}
