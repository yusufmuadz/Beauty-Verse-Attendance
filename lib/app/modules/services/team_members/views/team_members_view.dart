import 'package:google_fonts/google_fonts.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/modules/services/team_members/views/expansion_tile_team.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/data/model/identify_job_scope_response_model.dart';
import '../controllers/team_members_controller.dart';

// ignore: must_be_immutable
class TeamMembersView extends StatefulWidget {
  const TeamMembersView({super.key});

  @override
  State<TeamMembersView> createState() => _TeamMembersViewState();
}

class _TeamMembersViewState extends State<TeamMembersView> {
  final controller = Get.put(TeamMembersController());
  final a = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    Get.put(TeamMembersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tim Anda'),
        elevation: 1,
        centerTitle: true,
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.utc(2019, 10, 16),
                lastDay: DateTime.now(),
                focusedDay: controller.selectedDate.value,
                onDaySelected: (date, _) => controller.selectedDate(date),
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
                currentDay: controller.selectedDate.value,
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Detail Karyawan',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const Gap(10),
              FutureBuilder(
                future: a.identifyJobScope(
                  date: DateFormat(
                    'yyyy-MM-dd',
                  ).format(controller.selectedDate.value),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Skeletonizer(
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return expansionTileTeam(
                              User(nama: "Ini adalah nama dummy text"),
                              'Nama Siapa Ini Terserah',
                              1,
                              context,
                              '',
                              '',
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    IdentifyJobScopeResponseModel response = snapshot.data;

                    response.data!.sort((a, b) => a.attendance != null ? 0 : 1);

                    return Expanded(
                      child: ListView.builder(
                        addRepaintBoundaries: true,
                        addAutomaticKeepAlives: false,
                        itemCount: response.data!.length,
                        itemBuilder: (context, index) {
                          final e = response.data![index];

                          int subordinate = e.subordinate!;
                          String idKaryawan = e.id!;
                          String imgUrl = e.avatar!;
                          String leave = e.leave!;

                          return expansionTileTeam(
                            e,
                            leave,
                            subordinate,
                            context,
                            imgUrl,
                            idKaryawan,
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
