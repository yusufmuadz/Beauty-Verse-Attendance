import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/model_controller.dart';
import '../../../../core/components/custom_empty_submission.dart';
import '../../../../core/constant/variables.dart';
import '../../../../shared/textfieldform.dart';
import '../../../services/cuti/pengajuan/views/detail_pengajuan_absensi_view.dart';
import '../../models/resp_submission_model.dart';

class SubmissionAbsensiView extends StatefulWidget {
  const SubmissionAbsensiView({super.key});

  @override
  State<SubmissionAbsensiView> createState() => _SubmissionAbsensiViewState();
}

class _SubmissionAbsensiViewState extends State<SubmissionAbsensiView> {
  final m = Get.find<ModelController>();
  RespSubmissionAttendance? _submission;
  final searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxInt year = DateTime.now().year.obs;
  RxInt month = DateTime.now().month.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = DateFormat(
        "MMMM yyyy",
        "id_ID",
      ).format(DateTime(year.value, month.value));
      fetchSubmission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengajuan Presensi")),
      body: Column(
        children: [
          Material(
            elevation: .7,
            surfaceTintColor: Colors.white,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextfieldForm(
                controller: searchController,
                prefixIcon: Icon(Iconsax.calendar_copy),
                readOnly: true,
                onTap: () {
                  showMonthPicker(
                    context,
                    initialSelectedMonth: month.value,
                    initialSelectedYear: year.value,
                    onSelected: (p0, p1) {
                      isLoading.value = true;
                      month.value = p0;
                      year.value = p1;
                      searchController.text = DateFormat(
                        "MMMM yyyy",
                        "id_ID",
                      ).format(DateTime(p1, p0));
                      fetchSubmission();
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (isLoading.value) {
                return Center(child: CupertinoActivityIndicator());
              } else if (!isLoading.value && _submission!.data!.isEmpty) {
                return CustomEmptySubmission(
                  title: "Tidak Ada Pengajuan",
                  subtitle:
                      "Belum ada pengajuan dari subordinate Anda, tunggu sampai mereka mengajukan permohonan.",
                );
              } else {
                return ListView.builder(
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: false,
                  itemCount: _submission!.data!.length,
                  itemBuilder: (context, index) {
                    SubAttendance data = _submission!.data![index];

                    return ListTile(
                      onTap: () {
                        Get.to(
                          () => DetailPengajuanAbsensiView(),
                          arguments: data.id,
                        );
                      },
                      title: Text(data.nama ?? "-", maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        DateFormat("dd MMM yyyy").format(data.dateRequestFor!),
                      ),
                      titleTextStyle: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      subtitleTextStyle: GoogleFonts.outfit(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    Center(child: CupertinoActivityIndicator()),
                            imageUrl: data.avatar ?? "-",
                            memCacheHeight: 100,
                            memCacheWidth: 100,
                            maxWidthDiskCache: 100,
                            maxHeightDiskCache: 100,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.account_circle_rounded),
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: _formatColor(
                            data.statusLine ?? "Pending",
                          ).withValues(alpha: .3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data.statusLine ?? "-",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: _formatColor(data.statusLine ?? "Pending"),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Future fetchSubmission() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v2/submission/presence/$month/$year'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // if (kDebugMode) {
      //   debugPrint(response.statusCode.toString());
      // }

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        _submission = RespSubmissionAttendance.fromJson(str);
        _submission!.data!.sort(
          (a, b) => b.statusLine!.compareTo(a.statusLine!),
        );
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}

Color _formatColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.orange;
    case 'Approved':
      return Colors.amber;
    case 'Rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
