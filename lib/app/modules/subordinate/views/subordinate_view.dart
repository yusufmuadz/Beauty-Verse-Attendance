import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/subordinate_controller.dart';

class SubordinateView extends GetView<SubordinateController> {
  const SubordinateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tim Anda'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                controller.isShowDate(!controller.isShowDate.value),
            icon: Icon(Iconsax.calendar_copy),
          ),
        ],
      ),
      body: ListView(
        children: [
          Obx(() {
            if (controller.isShowDate.value) {
              return _buildCalendar();
            } else {
              return SizedBox();
            }
          }),
          Obx(() {
            if (controller.isLoading.value) {
              return _widgetSkeletonizer();
            } else if (!controller.isLoading.value &&
                controller.subordinate.isNotEmpty) {
              return _buildSubordinate(context);
            } else {
              return CustomEmptySubmission(
                title: 'Tidak ada data yang ditemukan',
                subtitle:
                    "Belum ada presensi yang dilakukan oleh Tim Anda, silahkan menunggu hingga ada presensi dari Tim Anda.",
              );
            }
          }),
        ],
      ),
    );
  }

  Skeletonizer _widgetSkeletonizer() {
    return Skeletonizer(
      child: Column(
        children: List.generate(5, (index) {
          return ListTile(
            leading: Skeleton.shade(child: CircleAvatar(radius: 25)),
            title: Text('Hello World'),
            subtitle: Text('Subtitle'),
          );
        }),
      ),
    );
  }

  Column _buildSubordinate(BuildContext context) {
    return Column(
      children: controller.subordinate
          .map(
            (e) => RepaintBoundary(
              key: ValueKey(e.id),
              child: ListTile(
                tileColor: e.attendance!.isEmpty
                    ? Colors.red.withValues(alpha: 0.2)
                    : Colors.white,
                onTap: () => controller.showAttendance(context, e),
                titleTextStyle: GoogleFonts.figtree(color: Colors.black),
                subtitleTextStyle: GoogleFonts.figtree(color: Colors.black54),
                title: Text(e.nama ?? ''),
                subtitle: Text(e.jabatan ?? ''),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade200,
                  child: CachedNetworkImage(
                    imageUrl: e.avatar ?? '',
                    maxWidthDiskCache: 100,
                    maxHeightDiskCache: 100,
                    memCacheHeight: 100,
                    memCacheWidth: 100,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  _buildCalendar() {
    return Obx(
      () => TableCalendar(
        locale: 'id_ID',
        firstDay: DateTime.utc(2019, 10, 16),
        lastDay: DateTime.now(),
        focusedDay: controller.selectedDay.value,
        onDaySelected: (date, _) => controller.selectDay(date),
        calendarFormat: CalendarFormat.month,
        headerVisible: true,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.figtree(color: Colors.black),
          weekendStyle: GoogleFonts.figtree(color: Colors.red),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: GoogleFonts.figtree(color: Colors.black),
          weekendTextStyle: GoogleFonts.figtree(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Colors.amber.shade900,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.figtree(),
          formatButtonVisible: false,
          titleCentered: true,
          formatButtonShowsNext: false,
        ),
        currentDay: controller.selectedDay.value,
      ),
    );
  }
}
