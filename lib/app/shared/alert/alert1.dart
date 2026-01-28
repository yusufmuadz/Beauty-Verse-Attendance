import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../utils.dart';

class Alert1 extends StatelessWidget {
  const Alert1({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Icon(Iconsax.danger_copy, color: Colors.red),
          const Gap(10),
          Text('Peringatan'),
        ],
      ),
      titleTextStyle: TextStyle(
        fontWeight: medium,
        color: redColor,
        fontSize: 18,
      ),
      content: Text(
        'Anda berada diluar jangkauan, silahkan kembali',
        style: TextStyle(),
      ),
      actions: [
        TextButton(
          child: Text("Kembali", style: TextStyle()),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}
