import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomStepperApprove<T> extends StatelessWidget {
  const CustomStepperApprove({
    super.key,
    required this.listStepper,
    required this.activeIndex,
    required this.isRejected,
    this.listDate,
  });

  final List listStepper;
  final List<dynamic>? listDate;
  final int activeIndex;
  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(listStepper.length, (index) {
        return Stack(
          children: [
            if (listStepper.length - 1 != index)
              Container(
                margin: const EdgeInsets.only(left: 59, top: 10),
                width: 1.5,
                height: 60,
                color: _settingColor(index).shade100,
              ),
            customStepBar(
              indicatorColor: _settingColor(index),
              status: listStepper[index],
              time: listDate![index] == null
                  ? "N/a"
                  : DateFormat('dd MMM\n HH:mm', 'id_ID').format(
                      listDate![index] == null
                          ? DateTime.now()
                          : DateTime.parse("${listDate![index]}"),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Row customStepBar({
    required Color indicatorColor,
    required String time,
    required String status,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 45,
          child: Text(
            time,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: indicatorColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            status,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  _settingColor(int index) {
    return isRejected
        ? Colors.red
        : index <= activeIndex
        ? Colors.amber
        : Colors.orange;
  }
}
