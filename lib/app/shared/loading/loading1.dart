import 'package:lancar_cat/app/shared/utils.dart';
import 'package:flutter/material.dart';

class Loading1 extends StatelessWidget {
  const Loading1({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: transparentColor,
      elevation: 0,
      content: Center(child: CircularProgressIndicator()),
    );
  }
}
