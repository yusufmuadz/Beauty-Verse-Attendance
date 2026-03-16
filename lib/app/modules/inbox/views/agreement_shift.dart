// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart'; // Import CupertinoActivityIndicator
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/api_controller.dart';
import '../../../controllers/model_controller.dart';
import '../../../core/components/custom_empty_submission.dart';
import '../../../core/constant/variables.dart';
import '../../../data/model/change_shift_response_model.dart';
import '../../home/views/menu_view.dart';
import '../../services/daftar_absen/views/absensi/detail_pengajuan_shift.dart';

class AgreementShiftView extends StatefulWidget {
  const AgreementShiftView({super.key});

  @override
  State<AgreementShiftView> createState() => _AgreementShiftViewState();
}

class _AgreementShiftViewState extends State<AgreementShiftView> {
  final m = Get.find<ModelController>();
  final a = Get.find<ApiController>();

  ChangeShiftResponseModel? shiftData;
  List<ChangeShift> filteredShifts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchShiftAgreements());
  }

  Future<void> fetchShiftAgreements() async {
    ChangeShiftResponseModel? data = await _fetchAgreementShiftLine();

    if (data != null && data.data != null) {
      shiftData = data;
      filteredShifts = shiftData!.data!;
      isLoading = false;
      _sortShifts(); // Initial sorting
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  void _sortShifts({String sortBy = 'status'}) {
    const statusOrder = {'Pending': 0, 'Rejected': 1, 'Approved': 2};

    filteredShifts.sort((a, b) {
      if (sortBy == 'name') {
        return a.user!.toLowerCase().compareTo(b.user!.toLowerCase());
      } else {
        // sortBy == 'status' (default)
        // Sort by status first
        final statusComparison = (statusOrder[a.statusLine] ?? 1).compareTo(
          statusOrder[b.statusLine] ?? 0,
        );

        // If statuses are the same, sort by createdAt (descending)
        if (statusComparison == 0) {
          return b.createdAt!.compareTo(a.createdAt!);
        }
        return statusComparison;
      }
    });
  }

  // Ubah tipe kembalian PopupMenuItem menjadi PopupMenuItem<dynamic>
  PopupMenuItem<dynamic> _popUpMenuBtn({
    required Function()? onTap,
    required String title,
  }) {
    return PopupMenuItem<dynamic>(
      // Eksplisitkan tipe generic di sini
      onTap: onTap,
      // Eksplisitkan tipe generic di sini
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Ganti Shift'),
        actions: [
          PopupMenuButton<dynamic>(
            // Eksplisitkan tipe generic di sini
            icon: const Icon(Icons.filter_alt_outlined),
            itemBuilder: (context) => [
              _popUpMenuBtn(
                onTap: () {
                  filteredShifts = shiftData!.data!;
                  setState(() {
                    _sortShifts(); // Sort by status (default)
                  });
                },
                title: 'Semua Pengajuan',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredShifts = shiftData!.data!
                        .where((s) => s.statusLine == 'Pending')
                        .toList();
                    _sortShifts();
                  });
                },
                title: 'Pending',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredShifts = shiftData!.data!
                        .where((s) => s.statusLine == 'Approved')
                        .toList();
                    _sortShifts();
                  });
                },
                title: 'Approved',
              ),
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    filteredShifts = shiftData!.data!
                        .where((s) => s.statusLine == 'Rejected')
                        .toList();
                    _sortShifts();
                  });
                },
                title: 'Rejected',
              ),
              const PopupMenuDivider(), // Divider for separation
              _popUpMenuBtn(
                onTap: () {
                  setState(() {
                    _sortShifts(sortBy: 'name'); // Sort by name
                  });
                },
                title: 'Urutkan berdasarkan Nama',
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
        child: !isLoading && filteredShifts.isEmpty
            ? const Center(
                child: CustomEmptySubmission(
                  title: 'Tidak ada pengajuan shift',
                  subtitle: 'Belum ada yang mengajukan pergantian shift, tunggu hingga ada yang mengajukan pergantian shift',
                ),
              )
            : isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                itemCount: filteredShifts.length,
                itemBuilder: (context, index) {
                  ChangeShift shift = filteredShifts[index];

                  return ListTile(
                    onTap: () async {
                      await Get.to(
                        () => DetailPengajuanShiftView(),
                        arguments: shift.id,
                      );
                      // Refresh data after returning from detail view
                      setState(() {
                        isLoading =
                            true; // Set loading to true to show indicator
                      });
                      fetchShiftAgreements(); // Re-fetch data
                    },
                    leading: SizedBox(
                      width: 44,
                      height: 44,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: shift.userAvatarUrl!,
                        ),
                      ),
                    ),
                    title: SizedBox(
                      width: Get.width * 0.65,
                      child: Text(
                        shift.user!,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    subtitle: SizedBox(
                      width: Get.width * 0.65,
                      child: Text(
                        DateFormat(
                          'dd MMMM yyyy',
                          'id_ID',
                        ).format(shift.dateRequestFor!),
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: findColorByStatus(
                          shift.statusLine ?? "Pending",
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        shift.statusLine ?? "Kosong",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: findColorByStatus(
                            shift.statusLine ?? "Pending",
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color findColorByStatus(String status) {
    switch (status) {
      case 'Approved':
        return Colors.amber;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Future<ChangeShiftResponseModel?> _fetchAgreementShiftLine() async {
    // Renamed for clarity
    var headers = {'Authorization': 'Bearer ${m.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse('${Variables.baseUrl}/v1/line/fetch/change/shift'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final data = ChangeShiftResponseModel.fromJson(str);
      return data;
    } else {
      debugPrint(response.reasonPhrase);
      return null; // Return null on error
    }
  }
}
