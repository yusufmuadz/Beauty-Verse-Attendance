import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFormatSchedule {
  timeOfDayFormat(String timeString) {
    // Split the time string into hours, minutes, and seconds
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);

    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateTime object with today's date and the specified time
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
      seconds,
    );

    // Format the DateTime object to local date and time format
    String formattedDateTime = DateFormat('HH:mm').format(dateTime);

    return formattedDateTime;
  }

  DateTime timeFormatDateTime(String timeString) {
    // Split the time string into hours, minutes, and seconds
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);

    int minutes = int.parse(timeParts[1]);
    int seconds = 0;

    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateTime object with today's date and the specified time
    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
      seconds,
    );

    // Format the DateTime object to local date and time format

    return dateTime;
  }

  bool selisihWaktu({required String time1, required String time2}) {
    // Konversi dari String ke TimeOfDay
    TimeOfDay timeOfDay1 = TimeOfDay(
      hour: int.parse(time1.split(':')[0]),
      minute: int.parse(time1.split(':')[1]),
    );

    TimeOfDay timeOfDay2 = TimeOfDay(
      hour: int.parse(time2.split(':')[0]),
      minute: int.parse(time2.split(':')[1]),
    );

    // Memeriksa apakah time1 sudah lewat dari time2
    bool isAfter = timeOfDay1.hour > timeOfDay2.hour ||
        (timeOfDay1.hour == timeOfDay2.hour &&
            timeOfDay1.minute > timeOfDay2.minute);

    if (isAfter) {
      print('Waktu $time1 sudah lewat dari $time2');
      return true;
    } else {
      print('Waktu $time1 belum lewat dari $time2');
      return false;
    }
  }

  static checkIsSameDay(DateTime date1, DateTime date2) {
    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day) {
      return true;
    } else {
      return false;
    }
  }
}
