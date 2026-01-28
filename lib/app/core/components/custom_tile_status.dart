import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTileStatus extends StatelessWidget {
  const CustomTileStatus({
    super.key,
    required this.status,
    required this.mainTitle,
    required this.mainSubtitle,
    required this.secTitle,
    required this.secSubtitle,
    required this.thirdTitle,
    required this.thirdSubtitle,
    this.onTap,
    this.showStatus = true,
  });

  final String status;
  final String mainTitle;
  final String mainSubtitle;

  final String secTitle;
  final String secSubtitle;

  final String thirdTitle;
  final String thirdSubtitle;

  final Function()? onTap;
  final bool? showStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [setColor(status).withOpacity(0.2), Colors.white],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  color: setColor(status),
                ),
                height: 120,
                width: 10,
              ),
              const Gap(5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mainTitle,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                mainSubtitle,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          if (showStatus!)
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                // color:
                                //     setColor(status).shade100.withOpacity(0.3),
                                color: Colors.white,
                                border: Border.all(
                                  color: setColor(status),
                                  width: 1.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  status,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.normal,
                                    color: setColor(status),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                secTitle,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                                child: Text(
                                  secSubtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                thirdTitle,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.3,
                                child: Text(
                                  thirdSubtitle,
                                  maxLines: 2,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

setColor(String status) {
  switch (status) {
    case 'Canceled':
      return Colors.red;
    case 'Approved':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'Pending':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
