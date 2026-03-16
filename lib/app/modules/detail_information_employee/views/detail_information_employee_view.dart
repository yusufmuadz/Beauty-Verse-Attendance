import 'package:flutter/material.dart';

import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/components/custom_tile_status.dart';
import '../../../models/leave.dart';
import '../../../models/profile_response_model.dart';
import '../../../shared/textfieldform.dart';
import '../controllers/detail_information_employee_controller.dart';

class DetailInformationEmployeeView
    extends GetView<DetailInformationEmployeeController> {
  const DetailInformationEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Karyawan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Obx(
              () => (controller.isLoading.value)
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            controller.imgUrl.value,
                          ),
                          onBackgroundImageError: (exception, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: Get.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.profileResponseModel.data!.person!.informasiPribadi!.nama!} ● ${controller.profileResponseModel.data!.person!.informasiPekerjaan!.idKaryawan}",
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${controller.profileResponseModel.data!.person!.informasiPekerjaan!.posisiPekerjaan} ● ${controller.profileResponseModel.data!.person!.informasiPekerjaan!.cabang}',
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.varelaRound(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Obx(
        () => (controller.isLoading.value)
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(0),
                    child: TabBar(
                      labelStyle: GoogleFonts.varelaRound(
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.amber,
                      controller: controller.tabController,
                      tabs: const [
                        'Dashboard',
                        'Person',
                      ].map((e) => Tab(text: e)).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [DashboardTabView(), PersonTabView()],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DashboardTabView extends GetView<DetailInformationEmployeeController> {
  const DashboardTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final leave = controller.profileResponseModel.data!.dashboard!.sisaCuti!;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade700,
                        Colors.amber.shade400,
                        Colors.amber.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                  ),
                  child: Text(
                    'Sisa Cuti Tahunan',
                    style: GoogleFonts.varelaRound(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Gap(15),
                Text(
                  leave < 0 ? '${leave}' : '${leave}' + " Hari",
                  style: GoogleFonts.varelaRound(
                    fontWeight: FontWeight.w500,
                    color: leave < 0 ? Colors.red : Colors.amber,
                    fontSize: 26,
                  ),
                ),
                const Gap(15),
                RichText(
                  text: TextSpan(
                    text: 'Lihat Data:',
                    style: GoogleFonts.varelaRound(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: ' Cuti Diambil',
                        style: GoogleFonts.varelaRound(color: Colors.amber),
                      ),
                    ],
                  ),
                ),
                const Gap(15),
              ],
            ),
          ),
          const Gap(10),
          TextfieldForm(
            controller: controller.search,
            hintText: 'Input Tanggal',
            readOnly: true,
            prefixIcon: Icon(Iconsax.calendar_copy),
            onTap: () async {
              controller.isLoading(true);
              showMonthPicker(
                context,
                initialSelectedMonth: controller.monthPicker,
                initialSelectedYear: controller.yearPicker,
                firstYear: controller.yearPicker - 2,
                onSelected: (p0, p1) {
                  controller.monthPicker = p0;
                  controller.yearPicker = p1;

                  controller
                      .search
                      .text = DateFormat('MMMM yyyy', 'id_ID').format(
                    DateTime.parse(
                      '${controller.yearPicker}-${controller.monthFormatted(controller.monthPicker)}-${DateTime.now().day}',
                    ),
                  );
                  controller.temp(
                    DateFormat('yyyy-MM').format(
                      DateTime.parse(
                        '${controller.yearPicker}-${controller.monthFormatted(controller.monthPicker)}-${DateTime.now().day}',
                      ),
                    ),
                  );
                },
              );
              controller.isLoading(false);
            },
          ),
          const Gap(10),
          Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: controller.fetchLeaveEmployeeById(
                      targetId: controller.idEmployee,
                      monthSelected: controller.temp.value,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasData) {
                        final result = snapshot.data as ResponseModelLeave;

                        if (result.data!.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Text('tidak ada cuti yang diajukan'),
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: result.data!.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              Leave leave = result.data![index];
                              return CustomTileStatus(
                                status: 'Approved',
                                mainTitle: 'Tanggal S/d',
                                mainSubtitle:
                                    '${DateFormat('dd MMM yyyy', 'id_ID').format(leave.startTimeOff!)} S/d ${DateFormat('dd MMM yyyy', 'id_ID').format(leave.endTimeOff!)}',
                                secTitle: 'Alasan Cuti',
                                secSubtitle: leave.reason ?? 'tidak ada alasan',
                                thirdTitle: 'Jenis Cuti',
                                thirdSubtitle: 'Cuti Tahunan',
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: Text('no data found'));
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PersonTabView extends StatelessWidget {
  PersonTabView({super.key});
  final DetailInformationEmployeeController controller =
      Get.find<DetailInformationEmployeeController>();

  @override
  Widget build(BuildContext context) {
    ProfileResponseModel profileResponseModel = controller.profileResponseModel;

    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        _buildSection(
          title: 'Informasi Pribadi',
          subtitle: 'Nama Lengkap, Tempat Tanggal Lahir, dll.',
          children: [
            _buildInfoTile(
              'Id Karyawan',
              profileResponseModel.data?.person?.informasiPekerjaan!.idKaryawan,
            ),
            _buildInfoTile(
              'Nama',
              profileResponseModel.data?.person?.informasiPribadi?.nama,
            ),
            _buildInfoTile(
              'Tempat Lahir',
              profileResponseModel.data?.person?.informasiPribadi?.tempatLahir,
            ),
            _buildInfoTile(
              'Tanggal Lahir',
              profileResponseModel.data?.person?.informasiPribadi?.tanggalLahir
                  ?.toLocal()
                  .toString()
                  .split(' ')[0],
            ),
            _buildInfoTile(
              'Agama',
              profileResponseModel.data?.person?.informasiPribadi?.agama,
            ),
            _buildInfoTile(
              'Jenis Kelamin',
              profileResponseModel.data?.person?.informasiPribadi?.jenisKelamin,
            ),
            _buildInfoTile(
              'Golongan Darah',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPribadi
                  ?.golonganDarah,
            ),
            _buildInfoTile(
              'Status Pernikahan',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPribadi
                  ?.statusPernikahan,
            ),
          ],
        ),
        _buildSection(
          title: 'Informasi Kontak',
          subtitle: 'Email, No Telepon, dll.',
          children: [
            _buildInfoTile(
              'Email',
              profileResponseModel.data?.person?.informasiKontak?.email,
            ),
            _buildInfoTile(
              'No Telepon',
              profileResponseModel.data?.person?.informasiKontak?.noTelepon,
            ),
          ],
        ),
        _buildSection(
          title: 'Informasi Alamat',
          subtitle: 'Informasi Alamat, dll.',
          children: [
            _buildInfoTile(
              'Alamat',
              profileResponseModel.data?.person?.informasiAlamat?.alamat,
            ),
          ],
        ),
        _buildSection(
          title: 'Informasi Pekerjaan',
          subtitle: 'Tanggal Masuk, dll.',
          children: [
            _buildInfoTile(
              'Nama Perusahaan',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.namaPerusahaan,
            ),
            _buildInfoTile(
              'Penempatan Pertama',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.penempatanPertama ?? '-',
            ),
            _buildInfoTile(
              'Posisi Pekerjaan',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.posisiPekerjaan,
            ),
            _buildInfoTile(
              'Level Pekerjaan',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.levelPekerjaan,
            ),
            _buildInfoTile(
              'Status Pekerjaan',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.statusPekerjaan,
            ),
            _buildInfoTile(
              'Status PTKP',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.statusPTKP,
            ),
            _buildInfoTile(
              'Tanggal Bergabung',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.tanggalBergabung
                  ?.toLocal()
                  .toString()
                  .split(' ')[0],
            ),
            _buildInfoTile(
              'Tanggal Berakhir Kontrak',
              profileResponseModel
                  .data
                  ?.person
                  ?.informasiPekerjaan
                  ?.tanggalBerakhirKontrak
                  ?.toLocal()
                  .toString()
                  .split(' ')[0],
            ),
            _buildInfoTile(
              'Masa Kerja',
              profileResponseModel.data?.person?.informasiPekerjaan?.masaKerja,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      backgroundColor: Colors.amber.withOpacity(0.1),
      title: Text(
        title,
        style: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.varelaRound(color: Colors.grey, fontSize: 12),
      ),
      children: children,
    );
  }

  Widget _buildInfoTile(String title, String? value) {
    return ListTile(
      leading: Icon(Iconsax.home),
      title: Text(
        title,
        style: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        value ?? 'Tidak ada data',
        style: GoogleFonts.varelaRound(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
