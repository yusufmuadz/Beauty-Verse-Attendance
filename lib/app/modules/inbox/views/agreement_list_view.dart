import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:lancar_cat/app/models/resp_approval_leave.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/textfieldform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/modules/home/views/menu_view.dart';
import 'package:lancar_cat/app/modules/inbox/views/agreement_detail_view.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class AgreementListView extends StatefulWidget {
  const AgreementListView({super.key});

  @override
  State<AgreementListView> createState() => _AgreementListViewState();
}

class _AgreementListViewState extends State<AgreementListView> {
  final a = Get.put(ApiController());
  final userC = TextEditingController();

  RxInt year = DateTime.now().year.obs;
  RxInt month = DateTime.now().month.obs;

  final dateController = TextEditingController();

  late RespAppLeave agreement;
  List<AppLeave> filteredAgreements = [];
  RxBool isLoading = true.obs;

  Future fetchAgreementLine() async {
    RespAppLeave? app = await a.fetchApprovalAgreement(month, year);

    if (app != null) {
      filteredAgreements.clear();
      agreement = app;

      filteredAgreements.addAll(agreement.data!);
      filteredAgreements.sort((a, b) {
        const statusOrder = {'Pending': 0, 'Rejected': 1, 'Approved': 2};

        // Filter Pending first, then sort it by createdAt if both are Pending
        if (a.statusLine == 'Pending' && b.statusLine == 'Pending') {
          return b.dateRequest!.compareTo(a.dateRequest!);
        }
        if (a.statusLine == 'Approved' && b.statusLine == 'Approved') {
          return b.dateRequest!.compareTo(a.dateRequest!);
        }
        if (a.statusLine == 'Rejected' && b.statusLine == 'Rejected') {
          return b.dateRequest!.compareTo(a.dateRequest!);
        }

        // Sorting by status order
        return (statusOrder[a.statusLine] ?? 1).compareTo(
          statusOrder[b.statusLine] ?? 0,
        );
      });

      isLoading.value = false;
      setState(() {});
    } else {
      isLoading.value = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // ... flutter widget timming
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAgreementLine());
    dateController.text = DateFormat(
      "MMMM yyyy",
      "id_ID",
    ).format(DateTime(year.value, month.value));
  }

  checkApprovalStatus(String status) {
    switch (status) {
      case 'pending':
        return orangeColor;
      case 'approved':
        return greenColor;
      case 'rejected':
        return redColor;
      default:
        return Colors.grey;
    }
  }

  PopupMenuItem _popUpMenuBtn({
    required Function()? onTap,
    required String title,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(title, style: GoogleFonts.outfit()),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_alt_outlined),
            iconColor: Colors.white,
            itemBuilder: (context) => [
              _popUpMenuBtn(
                onTap: () {
                  filteredAgreements = agreement.data!;
                  setState(() {
                    filteredAgreements.sort((a, b) {
                      const statusOrder = {
                        'Pending': 0,
                        'Rejected': 1,
                        'Approved': 2,
                      };

                      // Filter Pending first, then sort it by createdAt if both are Pending
                      if (a.statusLine == 'Pending' &&
                          b.statusLine == 'Pending') {
                        return b.dateRequest!.compareTo(a.dateRequest!);
                      }
                      if (a.statusLine == 'Approved' &&
                          b.statusLine == 'Approved') {
                        return b.dateRequest!.compareTo(a.dateRequest!);
                      }
                      if (a.statusLine == 'Rejected' &&
                          b.statusLine == 'Rejected') {
                        return b.dateRequest!.compareTo(a.dateRequest!);
                      }

                      // Sorting by status order
                      return (statusOrder[a.statusLine] ?? 1).compareTo(
                        statusOrder[b.statusLine] ?? 0,
                      );
                    });
                  });
                },
                title: 'Semua Pengajuan',
              ),
              _popUpMenuBtn(
                onTap: () {
                  filteredAgreements = agreement.data!;
                  setState(() {
                    filteredAgreements = filteredAgreements
                        .where((value) => value.statusLine == 'Pending')
                        .toList();
                  });
                },
                title: 'Pending',
              ),
              _popUpMenuBtn(
                onTap: () {
                  filteredAgreements = agreement.data!;

                  setState(() {
                    filteredAgreements = filteredAgreements
                        .where((value) => value.statusLine == 'Approved')
                        .toList();
                  });
                },
                title: 'Approved',
              ),
              _popUpMenuBtn(
                onTap: () {
                  filteredAgreements = agreement.data!;

                  setState(() {
                    filteredAgreements = filteredAgreements
                        .where((value) => value.statusLine == 'Rejected')
                        .toList();
                  });
                },
                title: 'Rejected',
              ),
              _popUpMenuBtn(
                onTap: () {
                  filteredAgreements = agreement.data!;
                  Get.dialog(
                    AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextfieldForm(
                            hintText: 'Cari Karyawan...',
                            controller: userC,
                          ),
                          const Gap(10),
                          Button1(
                            title: 'Cari',
                            onTap: () {
                              filteredAgreements = agreement.data!;
                              setState(() {
                                filteredAgreements = filteredAgreements
                                    .where(
                                      (value) => value.nama!
                                          .toLowerCase()
                                          .contains(userC.text.toLowerCase()),
                                    )
                                    .toList();
                              });
                              userC.clear();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                title: 'Cari Karyawan',
              ),
            ],
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          Get.off(() => MenuView(), arguments: '1');
          return true;
        },
        // ... loading cupertino
        child: Column(
          children: [
            Material(
              elevation: .6,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: TextfieldForm(
                  controller: dateController,
                  readOnly: true,
                  labelText: 'Pilih Bulan',
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
                        dateController.text = DateFormat(
                          "MMMM yyyy",
                          "id_ID",
                        ).format(DateTime(p1, p0));
                        await fetchAgreementLine();
                      },
                    );
                  },
                ),
              ),
            ),
            Obx(() {
              if (isLoading.value) {
                return Expanded(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              } else if (!isLoading.value && filteredAgreements.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    addRepaintBoundaries: true,
                    addAutomaticKeepAlives: true,
                    itemCount: filteredAgreements.length,
                    itemBuilder: (context, index) {
                      AppLeave leave = filteredAgreements[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => AgreementDetailView(),
                            arguments: leave.id,
                          );
                        },
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Date Request: ${DateFormat("dd MMM yyyy", "id_ID").format(leave.dateRequest!)}",
                                      style: GoogleFonts.outfit(fontSize: 12),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: checkApprovalStatusColors(
                                          leave.statusLine ?? "Pending",
                                        ).withValues(alpha: .15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        leave.statusLine ?? "-",
                                        style: GoogleFonts.figtree(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: checkApprovalStatusColors(
                                            leave.statusLine ?? "Pending",
                                          ).shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                Divider(),
                                const Gap(5),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.grey.shade300,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: leave.avatar ?? "-",
                                        ),
                                      ),
                                    ),
                                    const Gap(20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          leave.leaveType ?? "-",
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Iconsax.user,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const Gap(10),
                                            Text(
                                              "${leave.nama}",
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(3),
                                        Row(
                                          children: [
                                            Icon(
                                              Iconsax.calendar,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const Gap(10),
                                            Text(
                                              DateFormat(
                                                "dd MMM yyyy",
                                                "id_ID",
                                              ).format(leave.dateRequest!),
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
                // return Expanded(
                //   child: ListView.separated(
                //     separatorBuilder: (context, index) =>
                //         Divider(thickness: 1, color: Colors.grey[200]),
                //     physics: const BouncingScrollPhysics(),
                //     itemCount: filteredAgreements.length,
                //     itemBuilder: (context, index) {
                //       AppLeave leave = filteredAgreements[index];
                //       return InkWell(
                //         onTap: () {
                //           Get.off(
                //             () => AgreementDetailView(),
                //             arguments: leave.id,
                //             transition: Transition.cupertino,
                //           );
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(15),
                //           child: Row(
                //             children: [
                //               CircleAvatar(
                //                 radius: 20,
                //                 child: ClipRRect(
                //                   borderRadius: BorderRadius.circular(100),
                //                   child: CachedNetworkImage(
                //                     imageUrl: leave.avatar!,
                //                     filterQuality: FilterQuality.high,
                //                     fit: BoxFit.cover,
                //                   ),
                //                 ),
                //               ),
                //               const Gap(15),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   SizedBox(
                //                     width: Get.width * 0.5,
                //                     child: Text(
                //                       leave.nama ?? "",
                //                       maxLines: 1,
                //                       style: GoogleFonts.outfit(
                //                         fontWeight: FontWeight.normal,
                //                         fontSize: 13,
                //                       ),
                //                     ),
                //                   ),
                //                   Text(
                //                     leave.leaveType ?? "-",
                //                     style: GoogleFonts.outfit(
                //                       fontWeight: FontWeight.normal,
                //                       fontSize: 11,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               const Spacer(),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.end,
                //                 children: [
                //                   Text(
                //                     leave.statusLine!,
                //                     style: GoogleFonts.outfit(
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.w500,
                //                       color: checkApprovalStatus(
                //                         leave.statusLine!.toLowerCase(),
                //                       ),
                //                     ),
                //                   ),
                //                   const Gap(5),
                //                   Text(
                //                     DateFormat(
                //                       'dd MMM yyyy',
                //                       'id_ID',
                //                     ).format(leave.dateRequest!),
                //                     style: GoogleFonts.outfit(
                //                       fontSize: 12,
                //                       fontWeight: FontWeight.normal,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // );
              } else {
                return const CustomEmptySubmission(
                  title: 'Belum Ada Pengajuan',
                );
              }
            }),

            // !isLoading.value && filteredAgreements.isEmpty
            //     ? Center(
            //         child: CustomEmptySubmission(title: 'Belum Ada Pengajuan'),
            //       )
            //     : filteredAgreements.isEmpty
            //     ? Center(child: CupertinoActivityIndicator())
            //     :
          ],
        ),
      ),
    );
  }

  checkApprovalStatusColors(String status) {
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
