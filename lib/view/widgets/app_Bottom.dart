// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../utils/app_style.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          label,
          style:
              Styles.headLineStyle2.copyWith(color: Colors.white, fontSize: 19),
        ),
      ),
    );
  }
}
