import 'package:flutter/material.dart';
import 'package:get/get.dart';

noInternetConnection(BuildContext context) {
  showBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: Get.width,
        child: Column(
          children: [
            Icon(Icons.signal_cellular_connected_no_internet_0_bar_rounded),
            Text(
              'Jaringan tidak tersedia, silahkan coba lagi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    },
  );
}
