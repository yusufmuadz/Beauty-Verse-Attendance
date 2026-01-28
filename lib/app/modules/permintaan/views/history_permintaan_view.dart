import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import 'package:lancar_cat/app/core/components/my_button.dart';

import 'package:lancar_cat/app/models/permintaan_barang.dart';
import 'package:lancar_cat/app/modules/permintaan/views/detail_permintaan_view.dart';
import 'package:lancar_cat/app/shared/textfield/textfield_1.dart';

import '../controllers/permintaan_controller.dart';

class HistoryPermintaanView extends StatefulWidget {
  const HistoryPermintaanView({super.key});

  @override
  State<HistoryPermintaanView> createState() => _HistoryPermintaanViewState();
}

class _HistoryPermintaanViewState extends State<HistoryPermintaanView> {
  final controller = Get.put(PermintaanController());
  final search = TextEditingController();
  late int month;
  late int year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.paginate = 1;
      controller.historyPermintaanBarang.clear();
      initialized();
      await controller.fetchHistoryPermintaan(month: month, year: year);
    });
  }

  void initialized() {
    search.text = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());
    month = DateTime.now().month;
    year = DateTime.now().year;
  }

  Future<void> _onPickMonth() async {
    showMonthPicker(
      initialSelectedMonth: month,
      initialSelectedYear: year,
      context,
      onSelected: (p0, p1) async {
        search.text = DateFormat("MMMM yyyy", "id_ID").format(DateTime(p1, p0));
        month = p0;
        year = p1;
        await controller.fetchHistoryPermintaan(month: p0, year: p1);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.paginate = 1;
      controller.historyPermintaanBarang.clear();
      await controller.fetchHistoryPermintaan(month: month, year: year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Background lebih cerah
      appBar: AppBar(
        title: Text(
          "Riwayat Permintaan",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.amber.shade900,
        elevation: 1,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: TextField1(
              controller: search,
              hintText: '20 Agustus 2020',
              preffixIcon: Icon(Iconsax.calendar_copy),
              suffixIcon: Icon(Iconsax.arrow_down_1_copy),
              fillColor: Colors.white,
              onTap: _onPickMonth,
              readOnly: true,
            ),
          ),
          Expanded(
            child: Obx(
              () => (controller.isEmptyBarang.value)
                  ? controller.isError.value
                        ? _buildErrorState()
                        : _buildEmptyState()
                  : NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          final metrics = notification.metrics;
                          if (metrics.pixels >= metrics.maxScrollExtent) {
                            controller.logReachBottomPermintaan(
                              month: month,
                              year: year,
                            );
                          }
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          controller.paginate = 1;
                          controller.historyPermintaanBarang.clear();
                          await controller.fetchHistoryPermintaan(
                            month: month,
                            year: year,
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          itemCount:
                              controller.historyPermintaanBarang.length +
                              (controller.isLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index ==
                                controller.historyPermintaanBarang.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              );
                            }
                            PermintaanBarang barang =
                                controller.historyPermintaanBarang[index];

                            return _CardRequest(
                              barang: barang,
                              controller: controller,
                              month: month,
                              year: year,
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ic_empty_box.png',
              width: 250,
              height: 250,
            ),
            const Gap(20),
            Text(
              'Belum ada permintaan',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade800,
              ),
            ),
            const Gap(8),
            Text(
              'Belum ada pengajuan barang yang Anda minta.\nSilakan ajukan permintaan barang Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const Gap(40),
            MyButton(
              txtBtn: 'Ajukan Permintaan', // Tombol yang lebih relevan
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const Gap(16),
          Text(
            "Terjadi Kesalahan",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          const Gap(8),
          Text(
            "Gagal memuat data. Mohon coba lagi nanti.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// Widget _CardRequest tetap sebagai StatefulWidget untuk animasi interaktif
class _CardRequest extends StatefulWidget {
  final PermintaanBarang barang;
  final PermintaanController controller;
  final int month;
  final int year;

  const _CardRequest({
    required this.barang,
    required this.controller,
    required this.month,
    required this.year,
  });

  @override
  _CardRequestState createState() => _CardRequestState();
}

class _CardRequestState extends State<_CardRequest>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> fetchColor(String tipe) {
    final data = tipe.toLowerCase();
    String translateToIndonesian(String status) {
      switch (status) {
        case 'pending':
          return 'Menunggu';
        case 'antrian':
          return 'Dalam Antrian';
        case 'proses':
          return 'Sedang Diproses';
        case 'decline':
          return 'Ditolak';
        case 'ready':
          return 'Siap';
        case 'done':
          return 'Selesai';
        case 'cancel':
          return 'Dibatalkan';
        case 'partially ready':
          return 'Sebagian Siap';
        case 'partially done':
          return 'Sebagian Selesai';
        case 'waiting':
          return 'Menunggu';
        case 'disiapkan it':
          return 'Disiapkan IT';
        case 'diproses it':
          return 'Diproses IT';
        case 'diproses it sebagian':
          return 'Diproses IT Sebagian';
        case 'disiapkan it sebagian':
          return 'Disiapkan IT sebagian';
        default:
          return status;
      }
    }

    Color? color;
    switch (data) {
      case 'pending':
      case 'proses':
      case 'waiting':
        color = Colors.amber.shade700;
        break;
      case 'antrian':
      case 'ready':
      case 'partially ready':
        color = Colors.amber.shade700;
        break;
      case 'decline':
      case 'cancel':
        color = Colors.red.shade600;
        break;
      case 'done':
      case 'partially done':
        color = Colors.amber.shade600;
        break;
      default:
        color = Colors.grey.shade600;
    }

    return {"warna": color, "title": translateToIndonesian(data)};
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: () {
              Get.to(
                () => DetailPermintaanView(),
                arguments: widget.barang,
              )!.then((value) {
                widget.controller.paginate = 1;
                widget.controller.historyPermintaanBarang.clear();
                widget.controller.fetchHistoryPermintaan(
                  month: widget.month,
                  year: widget.year,
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.barang.noPermintaan.toString(),
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: fetchColor(
                            widget.barang.statusPermintaan.toString(),
                          )["warna"],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          fetchColor(
                                widget.barang.statusPermintaan.toString(),
                              )["title"] ??
                              "Status",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5, color: Colors.grey),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoTile(
                              icon: Icons.category_outlined,
                              title: "Tipe Permintaan",
                              value: widget.barang.tipePermintaan ?? "",
                            ),
                            _buildInfoTile(
                              icon: Icons.inventory_2_outlined,
                              title: "Jumlah Barang",
                              value:
                                  "${widget.barang.jumlahPermintaan ?? widget.barang.listBarang?.length ?? 0} barang",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoTile(
                              icon: Icons.notes_outlined,
                              title: "Catatan",
                              value: widget.barang.catatan ?? "-",
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.amber.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
