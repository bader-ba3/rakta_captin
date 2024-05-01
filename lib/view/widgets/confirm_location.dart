import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_Bottom.dart';



class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5)
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: AppButton(label: "Confirm Location"),
      ),
    );
  }
}
