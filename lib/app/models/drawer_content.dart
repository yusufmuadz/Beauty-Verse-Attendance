import 'package:flutter/cupertino.dart';

class DrawerContent {
  final IconData icons;
  final String title;
  final int? value;
  final void Function()? onTap;

  DrawerContent({
    required this.icons,
    required this.title,
    required this.onTap,
    this.value,
  });
}
