import 'dart:developer';

import 'package:lancar_cat/app/shared/snackbar/snackbar_1.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/modules/home/controllers/home_controller.dart';
import 'package:lancar_cat/app/modules/settings/views/detail_information_view.dart';
import 'package:lancar_cat/app/modules/settings/views/emergency%20contact/emergency_contact_view.dart';
import 'package:lancar_cat/app/modules/settings/views/ganti_password_view.dart';
import 'package:lancar_cat/app/modules/settings/views/job_information_view.dart';
import 'package:lancar_cat/app/modules/settings/views/pusat_bantuan_view.dart';
import 'package:lancar_cat/app/service/local_notification_service.dart';
import 'package:lancar_cat/app/shared/tile/tile1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

// ignore: must_be_immutable
class SettingView extends GetView {
  SettingView({Key? key}) : super(key: key);

  final _myBox = Hive.box("andioffset");

  final a = Get.put(ApiController());
  final m = Get.find<ModelController>();

  RxBool isEnableNotification = false.obs;

  @override
  Widget build(BuildContext context) {
    User user = m.u.value;
    isEnableNotification(_myBox.get("notification-status"));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12),
          child: SizedBox(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.nama ?? '-',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const Gap(4),
                SizedBox(
                  width: Get.width * 0.5,
                  child: Text(
                    user.jabatan!.isEmpty ? '-' : user.jabatan!,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            // Bagian kanan, gambar avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: (m.u.value.avatar == null)
                    ? Image.asset('assets/logo/logo.png')
                    : (m.u.value.avatar!.split('/').last.contains('default'))
                    ? Image.asset('assets/logo/logo.png')
                    : CachedNetworkImage(
                        imageUrl: m.u.value.avatar ?? '',
                        errorWidget: (context, url, error) {
                          return Center(
                            child: Icon(Icons.person, color: Colors.grey),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // debugPrint('Controller Mana: ${a.runtimeType}');
          await a.fetchCurrentUser();
          await a.todayAttendance();
        },
        child: ListView(
          children: [
            const Gap(10),
            MenuSetting(
              title: 'Detail Informasi',
              listTile: [
                ListTile1(
                  onTap: () => Get.to(
                    () => DetailInformationView(),
                    transition: Transition.cupertino,
                  ),
                  prefixIcon: Iconsax.user_copy,
                  title: 'Informasi personal',
                  suffixIcon: Iconsax.arrow_right_3_copy,
                ),
                ListTile1(
                  onTap: () => Get.to(
                    () => JobInformationView(),
                    transition: Transition.cupertino,
                  ),
                  prefixIcon: Iconsax.personalcard_copy,
                  title: 'Informasi pekerjaan',
                  suffixIcon: Iconsax.arrow_right_3_copy,
                ),
                ListTile1(
                  onTap: () => Get.to(
                    () => EmergencyContactView(),
                    transition: Transition.cupertino,
                  ),
                  prefixIcon: Iconsax.flag_copy,
                  title: 'Informasi Kontak Darurat',
                  suffixIcon: Iconsax.arrow_right_3_copy,
                ),
              ],
            ),
            const Gap(10),
            Obx(
              () => MenuSetting(
                title: 'Bantuan',
                listTile: [
                  ListTile1(
                    title: 'Hidupkan Notifikasi',
                    prefixIcon: Iconsax.notification_copy,
                    widgetSuffix: Switch(
                      activeColor: Colors.amber,
                      inactiveTrackColor: Colors.grey.shade100,
                      value: isEnableNotification.value,
                      onChanged: (value) {
                        _myBox.put('notification-status', value);
                        isEnableNotification(_myBox.get('notification-status'));

                        bool status = _myBox.get('notification-status');
                        if (status) {
                          // note: jika diaktifkan maka aktifkan notifikasi
                          final data = Get.put(HomeController());
                          data.initializeNotification();
                        } else {
                          // note: jika dinonaktifkan maka hapus semua notifikasi
                          LocalNotificationService service =
                              LocalNotificationService();
                          service.initialize();
                          service.clearAllScheduledNotifications();
                        }

                        Snackbar().snackbar1(
                          'Informasi',
                          'Pengingat ${status ? 'diaktifkan' : 'dinonaktifkan'}',
                          Iconsax.notification_copy,
                          Colors.white,
                          status ? Colors.amber : Colors.red,
                        );
                      },
                    ),
                  ),
                  ListTile1(
                    onTap: () {
                      Get.to(() => PusatBantuanView());
                    },
                    title: 'Pusat bantuan',
                    prefixIcon: Iconsax.info_circle_copy,
                    colors: blackColor,
                    suffixIcon: Iconsax.arrow_right_3_copy,
                  ),
                ],
              ),
            ),
            const Gap(10),
            MenuSetting(
              title: 'Pusat Akun',
              listTile: [
                ListTile1(
                  title: 'Ubah Kata Sandi',
                  prefixIcon: Iconsax.lock_1_copy,
                  suffixIcon: Iconsax.arrow_right_3_copy,
                  onTap: () {
                    Get.to(() => ChangePasswordView());
                  },
                ),
              ],
            ),
            const Gap(10),
            MenuSetting(
              title: 'Lainnya',
              listTile: [
                ListTile1(
                  onTap: _dialogExit,
                  title: 'Logout',
                  prefixIcon: Iconsax.logout_copy,
                  colors: redColor,
                  suffixIcon: Iconsax.arrow_right_3_copy,
                ),
              ],
            ),
            const Gap(10),
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
          style: GoogleFonts.varelaRound(
            fontSize: 17,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin logout?',
          style: GoogleFonts.varelaRound(fontSize: 14),
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
              await a.isAccountDeleted();
            },
            child: Text(
              "Ya",
              style: GoogleFonts.varelaRound(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

Future checkCurrentVersion() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  } catch (e) {
    log(e.toString());
  }
}

class MenuSetting extends StatelessWidget {
  const MenuSetting({super.key, required this.title, required this.listTile});

  final String title;
  final List<ListTile1> listTile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title.capitalizeFirst!,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.normal,
                letterSpacing: 0.4,
                fontSize: 14,
              ),
            ),
          ),
          ...List.generate(listTile.length, (index) => listTile[index]),
        ],
      ),
    );
  }
}
