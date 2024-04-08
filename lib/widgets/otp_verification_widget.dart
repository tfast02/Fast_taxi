import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_taxi/utils/app_constants.dart';
import 'package:fast_taxi/widgets/text_widget.dart';
import 'package:fast_taxi/widgets/pinput_widget.dart';

Widget otpVerificationWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: 'Xác minh số điện thoại'),
        textWidget(
            text: 'Nhập mã OTP của bạn',
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),

        const SizedBox(height: 30,),
        Container(
          width: Get.width,
            height: 60,
            child: RoundedWithShadow()
        ),

        const SizedBox(height: 40,),

        // Text gửi lại mã OTP
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                children: [
                  const TextSpan(
                    text: "Gửi lại mã sau ",
                  ),
                  TextSpan(
                      text: "10 giây",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ]
            ),
          ),
        )
      ],
    ),
  );
}