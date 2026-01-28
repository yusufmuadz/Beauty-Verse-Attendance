import 'package:cached_network_image/cached_network_image.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lancar_cat/app/modules/services/team_members/views/team_subordinate_view.dart';

import '../../../../data/model/login_response_model.dart';
import '../../../../models/attendance.dart';
import '../../../../shared/images/images.dart';
import '../../../../shared/tile/tile3.dart';
import '../controllers/team_members_controller.dart';

final controller = Get.put(TeamMembersController());

ExpansionTile expansionTileTeam(
  User e,
  String leave,
  int subordinate,
  BuildContext context,
  String imgUrl,
  String idKaryawan,
) {
  return ExpansionTile(
    tilePadding: const EdgeInsets.symmetric(horizontal: 15),
    childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
    shape: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.amber.shade100.withValues(alpha: 0.5),
      ),
    ),
    backgroundColor: Colors.amber.shade100.withValues(alpha: 0.5),
    title: Text(
      e.nama ?? '',
      style: TextStyle(
        fontSize: 14,
        color: leave.isNotEmpty || e.attendance == null
            ? Colors.red
            : Colors.black,
      ),
    ),
    subtitle: Text(
      leave.isNotEmpty
          ? leave
          : e.attendance == null
          ? "Tanpa Keterangan"
          : e.jabatan ?? "",
      style: TextStyle(
        color: leave.isNotEmpty || e.attendance == null
            ? Colors.red
            : Colors.grey,
        fontSize: 12,
      ),
    ),
    leading: SizedBox(
      height: 44,
      width: 44,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl:
              (e.avatar != null && e.avatar!.split("/").last == 'default.jpg')
              ? ""
              : e.avatar ?? "",
          errorWidget: (context, url, error) {
            return Image.asset('assets/logo/logo.png', fit: BoxFit.cover);
          },
        ),
      ),
    ),
    enabled: e.attendance != null || subordinate > 0,
    trailing: e.attendance != null || subordinate > 0 ? null : const SizedBox(),
    children:
        (e.attendance == null)
              ? []
              : (e.attendance!.details ?? []).map((e) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                      onTap: () {
                        _onTap(context, e, imgUrl);
                      },
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                      title: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              DateFormat('HH:mm').format(e.createdAt!),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              e.type == 'clockin' ? 'Clock-In' : 'Clock-Out',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()
          ..add(
            (subordinate > 0)
                ? Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                      onTap: () {
                        Get.to(
                          () => TeamSubordinateView(),
                          arguments: {
                            'id_karyawan': idKaryawan,
                            'selected_date': DateFormat(
                              'yyyy-MM-dd',
                              'id_ID',
                            ).format(controller.selectedDate.value),
                          },
                        );
                      },
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.people_copy,
                            color: Colors.amber.shade800,
                          ),
                          const Spacer(),
                          Text(
                            'Show $subordinate subordinates data',
                            style: TextStyle(fontSize: 12.5),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
  );
}

Future<dynamic> _onTap(BuildContext context, Attendance e, String imgUrl) {
  return showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width,
            height: (e.lat!.isNotEmpty && e.lang!.isNotEmpty) ? 200 : 0,
            child: Row(
              children: [
                if (e.lat!.isNotEmpty && e.lang!.isNotEmpty)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.amber),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            double.parse(e.lat!),
                            double.parse(e.lang!),
                          ),
                          initialZoom: 17,
                          maxZoom: 18,
                          minZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            maxZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 45.0,
                                height: 45.0,
                                point: LatLng(
                                  double.parse(e.lat!),
                                  double.parse(e.lang!),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: ImageNetwork(
                                      boxFit: BoxFit.cover,
                                      borderRadius: 0,
                                      url: imgUrl,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (e.image != null)
                  Expanded(
                    child: ImageNetwork(
                      boxFit: BoxFit.cover,
                      borderRadius: 0,
                      url: e.urlImage!,
                    ),
                  ),
              ],
            ),
          ),
          if (e.lat!.isEmpty && e.lang!.isEmpty)
            TileInformation(title: 'Status Presensi', subTitle: 'PENGAJUAN'),
          TileInformation(
            title: 'Type',
            subTitle: e.type == 'clockin' ? 'Clock-In' : 'Clock-Out',
          ),
          TileInformation(
            title: 'Jam Presensi',
            subTitle: DateFormat('HH:mm').format(e.createdAt ?? DateTime.now()),
          ),
          TileInformation(
            title: 'Kordinat Lokasi Presensi',
            subTitle: e.coordinate!.isEmpty ? '-' : e.coordinate!,
          ),
          TileInformation(
            title: 'Alasan Lokasi Presensi',
            subTitle: e.address!.isEmpty ? '-' : e.address!,
          ),
        ],
      );
    },
  );
}
