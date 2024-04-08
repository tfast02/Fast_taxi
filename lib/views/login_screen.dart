import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fast_taxi/widgets/login_widget.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:fast_taxi/views/otp_verification_screen.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final countryPicker = const FlCountryCodePicker();
  CountryCode countryCode = const CountryCode(name: 'Vietnam', code: "VN", dialCode: "+84");

  // Hàm submit (Chuyển đến màn hình xác nhận sđt)
  onSubmit(String? input) {
    Get.to(() => OtpVerificationScreen(countryCode.dialCode+input!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fastIntroWidget(),

              const SizedBox(height: 50,),
              loginWidget(countryCode, () async {
                final code = await countryPicker.showPicker(context: context);
                if (code != null) countryCode = code;
                setState(() {});
              }, onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
