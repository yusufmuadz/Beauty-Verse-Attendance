import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/data/model/time_off_response_model.dart';
import 'package:lancar_cat/app/modules/services/cuti/pengajuan/views/detail_pengajuan_cuti_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CutiPengajuan extends StatefulWidget {
  CutiPengajuan({super.key, required this.time});
  final DateTime time;

  @override
  State<CutiPengajuan> createState() => _CutiPengajuanState();
}

class _CutiPengajuanState extends State<CutiPengajuan> {
  final a = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: a.getAllApproval(date: widget.time),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Item number $index as title'),
                    subtitle: const Text('testing'),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return CustomEmptySubmission(title: 'Belum ada pengajuan');
          }

          List<Approval> approv = snapshot.data;
          approv.sort((b, a) => a.dateRequest!.compareTo(b.dateRequest!));
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: approv.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              Approval app = approv[index];

              return CustomTileStatus(
                onTap: () async {
                  await Get.to(
                    () => DetailPengajuanCutiView(),
                    transition: Transition.cupertino,
                    arguments: app,
                  );
                  setState(() {});
                },
                status: app.status ?? "Pending",
                mainTitle: "Tanggal pengajuan",
                mainSubtitle:
                    "${DateFormat('dd MMMM yyyy', 'id_ID').format(app.dateRequest!)}",
                secTitle: "Pengajuan untuk",
                secSubtitle: app.masterCuti ?? "Tidak Diketahui",
                thirdTitle: "Untuk Tanggal",
                thirdSubtitle: checkIsSameDay(
                  app.startTimeOff!,
                  app.endTimeOff!,
                ),
              );
            },
          );
        }
        return CustomEmptySubmission(title: 'Belum ada pengajuan');
      },
    );
  }

  checkIsSameDay(DateTime start, DateTime end) {
    return (start.day == end.day &&
            start.month == end.month &&
            start.year == end.year)
        ? "${DateFormat('dd MMM yyyy', 'id_ID').format(start)}"
        : "${DateFormat('dd MMM', 'id_ID').format(start)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(end)}";
  }
}
