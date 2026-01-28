import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lancar_cat/app/core/components/custom_empty_submission.dart';

import 'package:lancar_cat/app/core/components/detail_absensi_bottom_sheet.dart';
import 'package:lancar_cat/app/core/components/my_textfield.dart';
import 'package:lancar_cat/app/data/model/login_response_model.dart';
import 'package:lancar_cat/app/modules/employees/views/details_employee_view.dart';
import 'package:lancar_cat/app/routes/app_pages.dart';

import '../../../controllers/api_controller.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final a = Get.put(ApiController());
  final ScrollController _scrollController = ScrollController();
  final _searchController = TextEditingController();
  List<User> _karyawanList = [];
  List<User> _filteredKaryawanList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchKaryawan();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMoreData) {
      _fetchKaryawan();
    }
  }

  void _fetchKaryawan() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final fetchedKaryawan = await a.fetchUsers(
      _searchController.text,
      _currentPage,
    );

    setState(() {
      if (fetchedKaryawan.isEmpty) {
        _hasMoreData = false;
      } else {
        _karyawanList.addAll(fetchedKaryawan);
        _filteredKaryawanList.addAll(fetchedKaryawan);
        _currentPage++;
      }
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    _currentPage = 1;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      _filterKaryawan(query);
    });
  }

  void _filterKaryawan(String query) async {
    final fetchedKaryawan = await a.fetchUsers(
      _searchController.text,
      _currentPage,
    );

    setState(() {
      _filteredKaryawanList = fetchedKaryawan
          .where(
            (karyawan) =>
                karyawan.nama!.toLowerCase().contains(query.toLowerCase()) ||
                karyawan.jabatan!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  String getInitials({required String name}) {
    List<String> words = name.split(' ');

    if (words.isEmpty || words[0].isEmpty) {
      return '';
    }
    String firstInitial = words[0][0];

    String? secondInitial = '';
    if (words.length > 1 && words[1].isNotEmpty) {
      secondInitial = words[1][0];
    }

    return "$firstInitial$secondInitial";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _filteredKaryawanList.isEmpty && !_isLoading
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 15, top: 0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withValues(alpha: .05),
                        offset: Offset(0, 2),
                        blurRadius: 3.0,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: MyTextfield(
                    showTxt: false,
                    hintText: 'Cari karyawan',
                    controller: _searchController,
                    prefix: Icon(Icons.search),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: CustomEmptySubmission(
                            title: "Belum Ada Karyawan",
                            subtitle:
                                "Belum ada karyawan lainnya, tunggu personalia input data karyawan lainnya.",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 15, top: 0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withValues(alpha: .05),
                        offset: Offset(0, 2),
                        blurRadius: 3.0,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: MyTextfield(
                    showTxt: false,
                    hintText: 'Cari karyawan',
                    controller: _searchController,
                    prefix: Icon(Icons.search),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    cacheExtent: 300,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount:
                        _filteredKaryawanList.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < _filteredKaryawanList.length) {
                        final karyawan = _filteredKaryawanList[index];

                        return GestureDetector(
                          onTap: () => (m.u.value.superAdmin == "1")
                              ? Get.toNamed(
                                  Routes.DETAIL_INFORMATION_EMPLOYEE,
                                  arguments: karyawan.id,
                                )
                              : Get.to(
                                  () => DetailsEmployeeView(),
                                  arguments: karyawan,
                                ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 8,
                            shadowColor: Colors.amber.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.amber.shade600,
                                    Colors.amber.shade900,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -40,
                                    top: -10,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.2),
                                            Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.2),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: karyawan.avatar ?? "",
                                              fit: BoxFit.cover,
                                              errorWidget: (ctx, url, err) =>
                                                  Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                              memCacheHeight: 300,
                                              memCacheWidth: 300,
                                              maxWidthDiskCache: 300,
                                              maxHeightDiskCache: 300,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                karyawan.nama ?? "-",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.badge,
                                                    size: 16,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      karyawan.idKaryawan ??
                                                          "-",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.urbanist(
                                                            fontSize: 14,
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.9,
                                                                ),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      karyawan.cabang?.nama ??
                                                          "-",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.urbanist(
                                                            fontSize: 14,
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.9,
                                                                ),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (m.u.value.superAdmin ==
                                                  "1") ...[
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.work,
                                                      size: 16,
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        karyawan.divisi ?? "-",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.urbanist(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.9,
                                                                  ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      size: 16,
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        karyawan.email ?? "-",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.urbanist(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.9,
                                                                  ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
