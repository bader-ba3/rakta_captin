import 'package:flutter/material.dart';

import '../../utils/app_style.dart';


class LocationTextFiled extends StatelessWidget {
  const LocationTextFiled(
      {required this.controller,
      super.key,
      required this.hint,
      this.obscureText = false});

  final String hint;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      enabled: false,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        hintStyle: Styles.headLineStyle3.copyWith(fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(
          Icons.bookmark_add_outlined,
          color: blueRak,
        ),
        prefixIcon: Icon(
          Icons.circle,
          color: blueRak,
          size: 12,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }
}
