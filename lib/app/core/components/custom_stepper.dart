import 'package:flutter/material.dart';

class CustomStepper<T> extends StatelessWidget {
  const CustomStepper({
    super.key,
    required this.items,
  });

  final List<T> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        items.length,
        (index) {
          return ListTile();
        },
      ),
    );
  }
}
