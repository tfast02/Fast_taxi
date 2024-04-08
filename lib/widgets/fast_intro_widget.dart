import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_taxi/widgets/text_widget.dart';

Widget fastIntroWidget() {
  return Container(
    width: Get.width,
    height: Get.height*0.55,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/mask1.png'),
          fit: BoxFit.cover
      )
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/leaf_icon.svg'),
        const SizedBox(height: 20,),
        titleWidget(
            text: 'Fast Taxi',
            fontSize: 48,
            fontWeight: FontWeight.bold,
        ),
      ],
    ),
  );
}

Widget fastIntroWidgetWithoutLogos({String title = "Thông tin cá nhân", String? subtitle}) {
  return Container(
    width: Get.width,
    height: Get.height*0.3,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mask.png'),
            fit: BoxFit.fill
        )
    ),
    child: Container(
        height: Get.height*0.1,
        width: Get.width,
        margin: EdgeInsets.only(bottom: Get.height*0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          if(subtitle != null)
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white
              ),
            ),
        ],
      ),
    ),
  );
}