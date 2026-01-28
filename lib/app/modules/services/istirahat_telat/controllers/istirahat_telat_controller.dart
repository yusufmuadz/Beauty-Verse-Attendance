import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IstirahatTelatController extends GetxController {
  final m = Get.find<ModelController>();
  final searchC = TextEditingController();

  RxBool isAlreadyExists = false.obs;
  RxInt yearSelected = DateTime.now().year.obs;
  RxInt monthSelected = DateTime.now().month.obs;

  @override
  void onInit() {
    super.onInit();

    searchC.text = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime(yearSelected.value, monthSelected.value));
  }
}
