import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/core/components/custom_tile_status.dart';
import 'package:lancar_cat/app/shared/tile/tile3.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/superadmin_response_model.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class NotificationView extends GetView {
  NotificationView({Key? key}) : super(key: key);

  final m = Get.find<ModelController>();
  final a = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRecapByUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonizerNotification();
        } else if (snapshot.hasData) {
          SuperadminResponseModel model = snapshot.data;

          model.data!.sort(
            (a, b) =>
                b.dateApprovalSuperadmin!.compareTo(a.dateApprovalSuperadmin!),
          );

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: model.data!.length,
            itemBuilder: (context, index) {
              DetailApprove data = model.data![index];
              return CustomTileStatus(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TileInformation(
                            title: 'Status Pengajuan',
                            subTitle: '${data.statusSuperadmin}',
                          ),
                          TileInformation(
                            title: 'Pengajuan untuk',
                            subTitle: '${data.status}',
                          ),
                          TileInformation(
                            title: 'Tanggal keputusan',
                            subTitle:
                                '${DateFormat('dd MMMM yyyy', 'id_ID').format(data.dateApprovalSuperadmin ?? DateTime.now())}',
                          ),
                          TileInformation(
                            title: 'Alasan Line',
                            subTitle: '${data.reason ?? '-'}',
                          ),
                          TileInformation(
                            title: 'Alasan Super Admin',
                            subTitle: '${data.reasonSuperadmin ?? '-'}',
                          ),
                        ],
                      );
                    },
                  );
                },
                status: data.statusSuperadmin ?? 'Pending',
                mainTitle: "Tanggal keputusan",
                mainSubtitle:
                    '${DateFormat('dd MMMM yyyy', 'id_ID').format(data.dateApprovalSuperadmin!)}',
                secTitle: "Keputusan oleh",
                secSubtitle: data.superadmin!.nama!,
                thirdTitle: "Pengajuan untuk",
                thirdSubtitle: data.status!,
              );
            },
          );
        }
        return const CustomEmptySubmission();
      },
    );
  }

  // fetch all recap where approve by superadmin
  Future fetchRecapByUserId() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/user/recap'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final result = SuperadminResponseModel.fromJson(data);
      return result.data!.isEmpty ? null : result;
    } else {
      print(response.reasonPhrase);
    }
  }
}

class SkeletonizerNotification extends StatelessWidget {
  const SkeletonizerNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.amber.shade50.withValues(alpha: 0.5),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Keputusan',
                          style: TextStyle(fontSize: 12, fontWeight: regular),
                        ),
                        const Gap(5),
                        Text(
                          '${DateFormat('MMMM dd, yyyy', 'id_ID').format(DateTime.now())}',
                          style: TextStyle(fontSize: 14, fontWeight: medium),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "disapproved",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 0.5, color: Colors.grey.shade300),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keputusan Oleh',
                          style: TextStyle(fontSize: 12, fontWeight: regular),
                        ),
                        const Gap(5),
                        Text(
                          " data.superadmin!.nama!",
                          style: TextStyle(fontSize: 14, fontWeight: medium),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Perubahan',
                          style: TextStyle(fontSize: 12, fontWeight: regular),
                        ),
                        const Gap(5),
                        Text(
                          "data.status!",
                          style: TextStyle(fontSize: 14, fontWeight: medium),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
