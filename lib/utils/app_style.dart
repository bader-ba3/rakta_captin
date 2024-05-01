import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primary = const Color(0xff7F7F7F);
Color blueRak = const Color(0xff0f3b7f);

class Styles {
  static Color primaryColor = primary;
  static Color secondaryColor = const Color(0xffBA8C0A);

  static Color textColor = const Color(0xFF3b3b3b);


  static TextStyle textStyle =
  GoogleFonts.roboto(color: textColor, fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle1 =
  GoogleFonts.roboto(fontSize: 26, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle2 =
  GoogleFonts.roboto(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle3 = GoogleFonts.roboto(
      fontSize: 17, color: Colors.grey.shade500, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle4 = GoogleFonts.roboto(
      fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500);
}
