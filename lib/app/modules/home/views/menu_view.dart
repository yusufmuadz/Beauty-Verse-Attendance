import 'package:cached_network_image/cached_network_image.dart';
import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/modules/home/controllers/home_controller.dart';
import 'package:lancar_cat/app/modules/home/views/employee_view.dart';
import 'package:lancar_cat/app/modules/home/views/home_view.dart';
import 'package:lancar_cat/app/modules/home/views/inbox_view.dart';
import 'package:lancar_cat/app/modules/home/views/setting_view.dart';
import 'package:lancar_cat/app/modules/services/cuti/views/cuti_view.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/absensi/pengajuan_absensi_view.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/daftar_absen_view.dart';
import 'package:lancar_cat/app/modules/services/lembur/views/history_lembur_view.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../core/components/my_drawer_content.dart';
import '../../../core/constant/variables.dart';
import '../../../data/model/login_response_model.dart';
import '../../../models/drawer_content.dart';
import '../../services/absen/views/absen_view.dart';
import '../../services/istirahat_telat/views/istirahat_telat_view.dart';
import '../../services/izin kembali/izin_kembali_view.dart';

// ignore: must_be_immutable
class MenuView extends GetView<HomeController> {
  MenuView({super.key});

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final model = Get.find<ModelController>();

  DateTime? lastPressed;
  RxBool pop = false.obs;

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    final List<Widget> widget = [
      HomeView(),
      // if (controller.m.u.value.manager == '1')
      EmployeeView(),
      InboxView(),
      SettingView(),
    ].obs;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => _onWillPop(context),
      child: Obx(
        () => Scaffold(
          key: scaffoldKey,
          extendBody: true,
          drawer: _buildDrawer(model.u.value),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              appBarTitle(controller.curIndex.value),
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Obx(() => widget[controller.curIndex.value]),
          floatingActionButton: Material(
            color: Colors.amber.shade900,
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onDoubleTap: () => controller.curIndex(0),
              onTap: () => scaffoldKey.currentState?.openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  controller.curIndex.value != 0
                      ? Icons.home_outlined
                      : Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String appBarTitle(int index) {
    switch (index) {
      case 0:
        return "HOME";
      case 1:
        return "KARYAWAN";
      case 2:
        return "INBOX";
      case 3:
        return "PENGATURAN";
      default:
        return "Home";
    }
  }

  Drawer _buildDrawer(User user) {
    final model = Get.find<ModelController>();

    int totalApplications =
        model.leaveSize.value +
        model.attendanceSize.value +
        model.overtimeSize.value +
        model.changeShift.value;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset('assets/logo/transparent_background.png', width: 90),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: Get.width,
              color: Colors.amber.shade900,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: user.avatar ?? "-",
                            errorWidget: (context, url, error) => Padding(
                              padding: EdgeInsetsGeometry.all(5),
                              child: Icon(Iconsax.user_copy),
                            ),
                            progressIndicatorBuilder:
                                (context, url, progress) => Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CupertinoActivityIndicator(),
                                ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Text(
                      user.nama ?? "-",
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'ID Karyawan: ${user.job!.idKaryawan ?? "-"}',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // detail user
            const Gap(10),
            MyDrawerContent(
              drawer: [
                DrawerContent(
                  icons: Iconsax.home_copy,
                  title: 'Home',
                  onTap: () {
                    controller.curIndex(0);
                    Get.back();
                  },
                ),
                DrawerContent(
                  icons: Iconsax.people_copy,
                  title: 'Karyawan',
                  onTap: () {
                    controller.curIndex(1);
                    Get.back();
                  },
                ),
                DrawerContent(
                  icons: Iconsax.sms_star_copy,
                  title: 'Persetujuan',
                  onTap: () {
                    controller.curIndex(2);
                    Get.back();
                  },
                  value: totalApplications,
                ),
                DrawerContent(
                  icons: Iconsax.setting_copy,
                  title: 'Pengaturan',
                  onTap: () {
                    controller.curIndex(3);
                    Get.back();
                  },
                ),
              ],
              title: 'MENU UTAMA',
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Divider(),
            ),
            FutureBuilder(
              future: HomeController().isReqGranted(),
              builder: (context, snapshot) {
                return MyDrawerContent(
                  drawer: [
                    DrawerContent(
                      icons: Iconsax.note_copy,
                      title: 'Riwayat Presensi',
                      onTap: () async =>
                          Get.to(() => DaftarAbsenView(), arguments: true),
                    ),
                    DrawerContent(
                      icons: Iconsax.calendar_copy,
                      title: 'Presensi Hari Ini',
                      onTap: () => Get.to(() => AbsenView()),
                    ),
                    DrawerContent(
                      icons: Iconsax.backward_10_seconds_copy,
                      title: 'Istirahat Terlambat',
                      onTap: () => Get.to(() => IstirahatTelatView()),
                    ),
                    DrawerContent(
                      icons: Iconsax.sun_fog_copy,
                      title: 'Cuti',
                      onTap: () {
                        Get.to(
                          () => CutiView(),
                          transition: Transition.cupertino,
                        );
                      },
                    ),
                    DrawerContent(
                      icons: Iconsax.programming_arrow_copy,
                      title: 'Izin Kembali',
                      onTap: () {
                        Get.to(IzinKembaliView());
                      },
                    ),
                    DrawerContent(
                      icons: Iconsax.note_favorite_copy,
                      title: 'Lembur',
                      onTap: () {
                        Get.to(() => LemburView());
                      },
                    ),
                    DrawerContent(
                      icons: Iconsax.calendar_2_copy,
                      title: 'Pengajuan Shift',
                      onTap: () =>
                          Get.to(() => DaftarAbsenView(), arguments: 'shift'),
                    ),
                    DrawerContent(
                      icons: Iconsax.clock_1_copy,
                      title: 'Pengajuan Presensi',
                      onTap: () => Get.to(
                        () => DaftarAbsenView(),
                        arguments: 'presensi',
                      ),
                    ),
                  ],
                  title: 'PENGAJUAN & RIWAYAT',
                );
              },
            ),
            // logout
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Divider(),
            ),
            MyDrawerContent(
              drawer: [
                DrawerContent(
                  icons: Iconsax.logout_copy,
                  title: 'Keluar',
                  onTap: _dialogExit,
                ),
              ],
              title: 'LAINNYA',
            ),
            const Gap(10),
            FutureBuilder(
              future: checkCurrentVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasData) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Version: ${snapshot.data}\nAndiGlobalSoft@2024",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Error 404',
                    style: GoogleFonts.outfit(fontSize: 12),
                  ),
                );
              },
            ),

            const Gap(20),
          ],
        ),
      ),
    );
  }

  _dialogExit() {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Keluar Aplikasi',
          style: GoogleFonts.outfit(
            fontSize: 17,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin logout?',
          style: GoogleFonts.outfit(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Tidak", style: TextStyle(color: blackColor)),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Variables().loading(message: 'Logout...');
              await ApiController().isAccountDeleted();
            },
            child: Text("Ya", style: GoogleFonts.outfit(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  _onWillPop(BuildContext context) {
    final now = DateTime.now();
    final maxDuration = Duration(seconds: 2);

    if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: redColor,
          content: Text(
            'Tekan sekali lagi untuk keluar',
            style: GoogleFonts.lexend(color: whiteColor),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false); // Prevent back navigation
    }

    return Future.value(true); // Allow back navigation
  }

  bottomNavBar(BuildContext context) {
    final model = Get.find<ModelController>();

    int totalApplications =
        model.leaveSize.value +
        model.attendanceSize.value +
        model.overtimeSize.value +
        model.changeShift.value;

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      height: 70,
      child: Row(
        children: [
          CustomTileBottomNav(
            icons: Iconsax.home_2_copy,
            title: 'Home',
            color: getColors(controller.curIndex.value, 0),
            onTap: () => controller.curIndex(0),
            isActive: controller.curIndex.value == 0,
          ),
          CustomTileBottomNav(
            icons: Iconsax.people_copy,
            title: 'Karyawan',
            color: getColors(controller.curIndex.value, 1),
            onTap: () => controller.curIndex(1),
            isActive: controller.curIndex.value == 1,
          ),
          Expanded(child: SizedBox()),
          CustomTileBottomNav(
            icons: Iconsax.sms_copy,
            widget: totalApplications == 0
                ? null
                : badges.Badge(
                    badgeContent: Text(
                      totalApplications.toString(),
                      style: GoogleFonts.quicksand(color: Colors.white),
                    ),
                    child: Icon(
                      Iconsax.sms_copy,
                      color: getColors(controller.curIndex.value, 2),
                    ),
                  ),
            title: 'Pesan',
            color: getColors(controller.curIndex.value, 2),
            onTap: () => controller.curIndex(2),
            isActive: controller.curIndex.value == 2,
          ),
          CustomTileBottomNav(
            icons: Iconsax.setting_2_copy,
            title: 'Setting',
            color: getColors(controller.curIndex.value, 3),
            onTap: () => controller.curIndex(3),
            isActive: controller.curIndex.value == 3,
          ),
        ],
      ),
    );
  }
}

showModalPengajuan(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pengajuan untukmu",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Gap(15),
            CustomTilePengajuan(
              icons: Iconsax.clock_1_copy,
              title: 'Pengajuan Cuti',
              onTap: () => Get.to(() => CutiView()),
            ),
            const Gap(10),
            CustomTilePengajuan(
              icons: Iconsax.calendar_copy,
              title: 'Pengajuan Presensi',
              onTap: () => Get.to(() => PengajuanAbsensiView()),
            ),
            const Gap(10),
            CustomTilePengajuan(
              icons: Iconsax.calendar_add_copy,
              title: 'Pengajuan Lembur',
              onTap: () => Get.to(() => LemburView()),
            ),
            const Gap(10),
            CustomTilePengajuan(
              icons: Iconsax.note_copy,
              title: 'Pengajuan Shift',
              onTap: () => Get.to(() => DaftarAbsenView(), arguments: 'shift'),
            ),
            const Gap(10),
          ],
        ),
      );
    },
  );
}

getColors(int curIndex, int index) =>
    (curIndex == index) ? HexColor('#01bede') : Colors.grey;

class CustomTilePengajuan extends StatelessWidget {
  const CustomTilePengajuan({
    super.key,
    required this.title,
    required this.icons,
    this.onTap,
  });

  final String title;
  final IconData icons;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      leading: Icon(icons, color: Colors.black87),
      trailing: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black87),
      minLeadingWidth: 0,
      tileColor: HexColor('#e1faff'),
      title: Text(
        title,
        style: GoogleFonts.varelaRound(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }
}

class CustomTileBottomNav extends StatelessWidget {
  const CustomTileBottomNav({
    super.key,
    required this.icons,
    required this.title,
    required this.isActive,
    this.onTap,
    this.color,
    this.widget,
  });

  final IconData icons;
  final Widget? widget;
  final Color? color;
  final String title;
  final bool isActive;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        overlayColor: MaterialStatePropertyAll(
          Colors.amber.shade100.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget ?? Icon(icons, color: color),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isActive ? 3 : 0,
            ),
            Text(
              title,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: isActive ? 12 : 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
