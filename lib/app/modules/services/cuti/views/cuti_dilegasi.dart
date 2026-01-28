import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/utils.dart';

class CutiDilegasi extends StatelessWidget {
  const CutiDilegasi({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: OutlineInputBorder(
            borderSide: BorderSide(width: 0.3, color: greyColor),
            borderRadius: BorderRadius.zero,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: greyColor,
          ),
          title: RichText(
            text: TextSpan(
                text: 'Dilegasi ke Lucky Alma\n',
                style: TextStyle(
                  color: blackColor,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                      text:
                          '${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())}\n',
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12,
                      )),
                  TextSpan(
                    text: 'approved',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 12,
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
