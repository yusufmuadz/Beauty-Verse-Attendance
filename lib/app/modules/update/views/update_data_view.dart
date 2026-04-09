import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../core/components/custom_empty_submission.dart';
import '../../../core/components/custom_tile_status.dart';
import '../../../core/components/detail_absensi_bottom_sheet.dart';
import '../../../core/constant/variables.dart';
import '../../../data/model/biodata_response_model.dart';
import '../../../shared/button/button_1.dart';
import 'update_submission_view.dart';

class UpdateDataView extends GetView {
  const UpdateDataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perubahan Data'),
        titleSpacing: 0,
        elevation: 1.7,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  BiodataResponseModel model = snapshot.data;

                  model.data!.sort(
                    (a, b) => b.dateRequest!.compareTo(a.dateRequest!),
                  );

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 10,
                      right: 10,
                    ),
                    itemCount: model.data!.length,
                    itemBuilder: (context, index) {
                      DetailBiodata bio = model.data![index];

                      return CustomTileStatus(
                        status: bio.status ?? "Pending",
                        mainTitle: "Tanggal pengajuan",
                        mainSubtitle: DateFormat(
                          'MMMM dd, yyyy',
                          'id_ID',
                        ).format(bio.dateRequest!),
                        secTitle: "Keputusan oleh",
                        secSubtitle: (bio.superadmin != null)
                            ? bio.superadmin!.nama!
                            : "Tidak diketahui",
                        thirdTitle: "Perubahan",
                        thirdSubtitle: bio.typeApproval!.replaceAll("_", " "),
                      );
                    },
                  );
                }
                return CustomEmptySubmission();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Button1(
              title: 'Pengajuan perubahan data',
              onTap: () => Get.off(
                () => UpdateSubmissionView(),
                transition: Transition.cupertino,
              ),
            ),
          ),
        ],
      ),
    );
  }

  colorStatusPengajuan(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade100.withOpacity(0.3);
      case 'Approved':
        return Colors.amber.shade100.withOpacity(0.3);
      case 'Rejected':
        return Colors.red.shade100.withOpacity(0.3);
      default:
    }
  }

  colorTextPengajuan(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.amber;
      case 'Rejected':
        return Colors.red;
      default:
    }
  }

  Future fetchData() async {
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/fetch/biodata'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final result = BiodataResponseModel.fromJson(str);

      return (result.status!) ? result : null;
    } else {
      debugPrint('${response.reasonPhrase}');
    }
  }
}
