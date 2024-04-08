import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_taxi/utils/app_constants.dart';
import 'package:fast_taxi/widgets/text_widget.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

Widget loginWidget(CountryCode countryCode, Function onCountryChange, Function onSubmit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: 'Well come to Fast Taxi!'),
        textWidget(
            text: 'Đồng hành cùng Fast Taxi',
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),

        const SizedBox(height: 30,),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3
              )
            ],
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              // Chọn quốc gia
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => onCountryChange(),
                  child: Container(
                    child: Row(
                      children: [
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            child: countryCode.flagImage(),
                          ),
                        ),
                        textWidget(text: countryCode.dialCode),
                        const Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),

              // Text nhập số điện thoại
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onSubmitted: (String? input) => onSubmit(input),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(fontSize: 16),
                      hintText: 'Vui lòng nhập số điện thoại',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40,),
        // Text chính sách bảo mật
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
              children: [
                const TextSpan(
                  text: AppConstants.byCreating + " ",
                ),
                TextSpan(
                  text: AppConstants.termsOfService + " ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                ),
                const TextSpan(text: "và "),
                TextSpan(
                  text: AppConstants.privacyPolicy + " ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                ),
                const TextSpan(text: "của chúng tôi. "),
              ]
            ),
          ),
        )
      ],
    ),
  );
}