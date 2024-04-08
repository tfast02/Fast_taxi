import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textWidget({required String text, double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal, Color color = Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}
Widget titleWidget({required String text, double fontSize = 48,
  FontWeight fontWeight = FontWeight.bold,}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.white
    ),
  );
}