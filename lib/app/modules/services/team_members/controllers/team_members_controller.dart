import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamMembersController extends GetxController {
  final dateC = TextEditingController();
  
  Rx<DateTime> selectedDate = DateTime.now().obs;

}
