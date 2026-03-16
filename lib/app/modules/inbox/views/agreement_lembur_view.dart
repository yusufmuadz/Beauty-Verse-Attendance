// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';

import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/api_controller.dart';
import '../../../core/components/custom_empty_submission.dart';
import '../../../models/resp_approval_overtime.dart';
import '../../../shared/textfieldform.dart';
import '../../home/views/menu_view.dart';
import '../../services/lembur/views/detail_pengajuan_lembur_view.dart'; // Added for GoogleFonts

class AgreementLemburView extends StatefulWidget {
  const AgreementLemburView({super.key});

  @override
  State<AgreementLemburView> createState() => _AgreementLemburViewState();
}

class _AgreementLemburViewState extends State<AgreementLemburView> {
  final a = Get.put(
    ApiController(),
  ); // Changed to Get.put to match the other example

  RespApprovalOvertime? overtimeData;
  List<ApprovalOvertime> filteredOvertime = [];
  RxBool isLoading = true.obs;
  RxBool isEmpty = false.obs;
  final searchController = TextEditingController();

  RxInt month = DateTime.now().month.obs;
  RxInt year = DateTime.now().year.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = DateFormat(
        'MMMM yyyy',
        "id_ID",
      ).format(DateTime.now());
      fetchOvertime();
    });
  }

  Future<void> fetchOvertime() async {
    isLoading(true);

    RespApprovalOvertime? data = await a.approvalOvertime(
      month: month.value,
      year: year.value,
    );

    if (data != null && data.data!.isNotEmpty) {
      isEmpty(false);
      overtimeData = data;
      filteredOvertime = overtimeData!.data!;
      isLoading.value = false;
      _sortOvertimeSubmissions();
    } else {
      isEmpty(true);
      isLoading.value = false;
    }

    isLoading(false);
  }

  void _sortOvertimeSubmissions() {
    const statusOrder = {'Pending': 0, 'Rejected': 1, 'Approved': 2};

    filteredOvertime.sort((a, b) {
      // Sort by status first
      final statusComparison = (statusOrder[a.statusLine] ?? 1).compareTo(
        statusOrder[b.statusLine] ?? 0,
      );

      // If statuses are the same, sort by dateRequest (descending)
      if (statusComparison == 0) {
        return b.dateRequestFor!.compareTo(a.dateRequestFor!);
      }
      return statusComparison;
    });
  }

  PopupMenuItem _popUpMenuBtn({
    required Function()? onTap,
    required String title,
  }) {
    return PopupMenuItem(onTap: onTap, child: Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Lembur'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_alt_outlined),
            itemBuilder: (context) => [
              _popUpMenuBtn(
                onTap: () {
                  filteredOvertime = overtimeData!.data!;
                  setState(() {
                    _sortOvertimeSubmissions();
                  });
                },
                title: 'Semua Pengajuan',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredOvertime = overtimeData!.data!
                        .where((s) => s.statusLine == 'Pending')
                        .toList();
                    _sortOvertimeSubmissions();
                  });
                },
                title: 'Pending',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredOvertime = overtimeData!.data!
                        .where((s) => s.statusLine == 'Approved')
                        .toList();
                    _sortOvertimeSubmissions();
                  });
                },
                title: 'Approved',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredOvertime = overtimeData!.data!
                        .where((s) => s.statusLine == 'Rejected')
                        .toList();
                    _sortOvertimeSubmissions();
                  });
                },
                title: 'Rejected',
              ),
            ],
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Get.off(() => MenuView(), arguments: '1');
          return true;
        },
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: TextfieldForm(
                controller: searchController,
                readOnly: true,
                prefixIcon: Icon(Iconsax.calendar_copy),
                onTap: () {
                  showMonthPicker(
                    context,
                    initialSelectedYear: year.value,
                    initialSelectedMonth: month.value,
                    onSelected: (p0, p1) async {
                      isLoading.value = true;
                      month.value = p0;
                      year.value = p1;
                      searchController.text = DateFormat(
                        "MMMM yyyy",
                        "id_ID",
                      ).format(DateTime(p1, p0));
                      await fetchOvertime();
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return Center(child: CupertinoActivityIndicator());
                } else if (!isLoading.value && isEmpty.value) {
                  return CustomEmptySubmission(
                    title: "Tidak Ada Pengajuan Lembur",
                    subtitle:
                        "Belum ada yang mengajukan lembur, tunggu hingga ada yang mengajukan lembur",
                  );
                } else if (!isLoading.value && filteredOvertime.isNotEmpty) {
                  return ListView.builder(
                    itemCount: filteredOvertime.length,
                    itemBuilder: (context, index) {
                      ApprovalOvertime sub = filteredOvertime[index];
                      return ListTile(
                        key: ValueKey(sub.id ?? "-"),
                        onTap: () async {
                          await Get.to(
                            () => DetailPengajuanLemburView(),
                            arguments: sub.id,
                          );
                          // Refresh data after returning from detail view
                          setState(() {
                            isLoading.value =
                                true; // Set loading to true to show indicator
                          });
                          fetchOvertime(); // Re-fetch data
                        },
                        leading: SizedBox(
                          width: 44,
                          height: 44,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: sub.avatar ?? "-",
                              memCacheHeight: 100,
                              memCacheWidth: 100,
                              maxWidthDiskCache: 100,
                              maxHeightDiskCache: 100,
                            ),
                          ),
                        ),
                        title: Text(
                          sub.nama ?? "-",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(fontSize: 12),
                        ),
                        subtitle: Text(
                          DateFormat(
                            'dd MMMM yyyy',
                            'id_ID',
                          ).format(sub.dateRequestFor!),
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sub.statusLine ?? 'Pending',
                              style: TextStyle(
                                color: _formatColor(
                                  sub.statusLine ?? 'Pending',
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              sub.type ?? "-",
                              style: GoogleFonts.lexend(
                                // Consistent with other code
                                color:
                                    Colors.grey, // Consistent with other code
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        shape: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return CustomEmptySubmission(
                    title: "Tidak Ditemukan",
                    subtitle: "Tidak ada yang mengajukan lembur sesuai filter",
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
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
}
