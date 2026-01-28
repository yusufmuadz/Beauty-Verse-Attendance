import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PengajuanView extends GetView {
  const PengajuanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PengajuanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PengajuanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
