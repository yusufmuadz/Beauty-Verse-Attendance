import 'package:get/get.dart';

import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/models/shift.dart';

class CalendarController extends GetxController {
  final List<Map<String, dynamic>> events = [];

  DateTime startDate = DateTime.now();
  List<Map<String, String?>> customDayOff = [];

  final m = Get.find<ModelController>();

  checkSelectedDate(DateTime date) {
    // Set customDayOff using the shift pattern
    var customDayOff = m.schedule!.schedule!.shiftPattern.pattern;

    // Calculate the number of days between the current date and the effective date
    int daysSinceEffectiveDate = date.difference(m.effectiveDate!).inDays;

    // Calculate the index of today's shift directly using modulo
    int dayOffIndex = daysSinceEffectiveDate % customDayOff.length;

    // Set today's shift
    return Shift.fromMap(customDayOff[dayOffIndex]);
  }
}
