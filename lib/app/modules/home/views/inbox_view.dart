import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lancar_cat/app/shared/utils.dart';

import '../../inbox/views/agreement_view.dart';
import '../../inbox/views/notification_view.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);

    if (Get.arguments != null) {
      controller.index = int.parse(Get.arguments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 15,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12),
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: SizedBox(
              height: 48,
              child: TabBar(
                padding: const EdgeInsets.all(5),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.amber.shade900,
                  borderRadius: BorderRadius.circular(5),
                ),
                controller: controller,
                dividerHeight: 0,
                splashBorderRadius: BorderRadius.circular(5),
                labelStyle: GoogleFonts.outfit(
                  fontWeight: FontWeight.normal,
                  color: whiteColor,
                  fontSize: 14,
                ),
                unselectedLabelColor: Colors.black26,
                tabs: [
                  Tab(text: "Notifikasi"),
                  Tab(text: "Perlu persetujuan"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [NotificationView(), AgreementView()],
      ),
    );
  }
}
