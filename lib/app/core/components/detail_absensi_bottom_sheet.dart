import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/model_controller.dart';
import '../../models/attendance.dart';
import '../../models/pattern.dart';
import '../../models/shift.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../shared/maps/tile_layer_maps.dart';
import '../../shared/tile/tile3.dart';

final m = Get.find<ModelController>();
final h = Get.put(HomeController());
void detailInformationAbsen({
  required Attendance attendance,
  required BuildContext context,
  CPattern? pattern,
  Shift? shift,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 16),

            // MAP & FOTO
            if ((attendance.lat?.isNotEmpty ?? false) ||
                (attendance.urlImage?.isNotEmpty ?? false))
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    if (attendance.lat?.isNotEmpty ?? false)
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                double.parse(attendance.lat!),
                                double.parse(attendance.lang!),
                              ),
                              initialZoom: 17,
                            ),
                            children: [
                              TileLayerMaps().sharedTile(),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 40,
                                    height: 40,
                                    point: LatLng(
                                      double.parse(attendance.lat!),
                                      double.parse(attendance.lang!),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        m.u.value.avatar ?? "",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (attendance.urlImage?.isNotEmpty ?? false)
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            attendance.urlImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // DETAIL INFORMASI
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  TileInformation(
                    title: 'Waktu Presensi',
                    subTitle:
                        "${attendance.type == 'clockin' ? 'Clock-In' : 'Clock-Out'} • ${DateFormat('HH:mm (dd MMM yyyy)', 'id_ID').format(attendance.createdAt!)}",
                  ),
                  TileInformation(
                    title: 'Shift',
                    subTitle: shift?.shiftName ?? '-',
                  ),
                  TileInformation(
                    title: 'Jadwal Shift',
                    subTitle: DateFormat(
                      'EEE, dd MMM yyyy',
                      'id_ID',
                    ).format(DateTime.now()),
                  ),
                  TileInformation(
                    title: 'Alamat',
                    subTitle: attendance.address?.isEmpty ?? true
                        ? "-"
                        : attendance.address!,
                  ),
                  TileInformation(
                    title: 'Koordinat',
                    subTitle: "${attendance.lat} , ${attendance.lang}",
                  ),
                  TileInformation(
                    title: 'Catatan',
                    subTitle: attendance.catatan?.isEmpty ?? true
                        ? "-"
                        : attendance.catatan!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String findShiftName(Shift shift) {
  if (shift.dayoff == "1") {
    return shift.shiftName ?? "(Day Off)";
  }
  return '${shift.shiftName} (${h.timeOfDayFormat(shift.scheduleIn!)} - ${h.timeOfDayFormat(shift.scheduleOut!)})';
}
