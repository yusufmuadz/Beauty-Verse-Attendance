import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:lancar_cat/app/modules/home/views/menu_view.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/daftar_absen_absensi_view.dart';
import 'package:lancar_cat/app/modules/services/daftar_absen/views/daftar_absen_shift_view.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import 'daftar_absen_riwayat_view.dart';

class DaftarAbsenView extends StatefulWidget {
  const DaftarAbsenView({super.key});

  @override
  State<DaftarAbsenView> createState() => _DaftarAbsenViewState();
}

class _DaftarAbsenViewState extends State<DaftarAbsenView>
    with TickerProviderStateMixin {
  late TabController tabController;
  RxInt curIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    if (Get.arguments == 'menu') {
      tabController.animateTo(2);
    } else if (Get.arguments == 'shift') {
      tabController.index = 1;
    } else if (Get.arguments == 'presensi') {
      tabController.index = 2;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MenuView());
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: Text('Daftar Presensi'),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(68),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: HexColor("#F8FAFC"),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                indicatorPadding: EdgeInsetsGeometry.all(5),
                labelStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                unselectedLabelStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                ),
                dividerHeight: 0,
                controller: tabController,
                tabs: [
                  Tab(text: "Riwayat"),
                  Tab(text: "Shift"),
                  Tab(text: "Presensi"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            DaftarAbsenRiwayatView(),
            DaftarAbsenShiftView(),
            DaftarAbsenAbsensiView(),
          ],
        ),
      ),
    );
  }
}
