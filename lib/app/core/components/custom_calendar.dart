import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> customCalendar({
  required BuildContext context,
  required DateTime initialDateTime,
  required DateTime maximumDate,
  required DateTime minimumDate,
  required Function(DateTime) onDateTimeChanged,
}) async {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
            CupertinoButton(
              child: Text("Done"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  } else {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: minimumDate,
      lastDate: maximumDate,
      locale: const Locale('id', 'ID'),
    );

    if (selectedDate != null) {
      onDateTimeChanged(selectedDate);
    }
  }
}
