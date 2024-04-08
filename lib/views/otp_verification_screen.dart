import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:fast_taxi/controller/auth_controller.dart';
import 'package:fast_taxi/widgets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {

  String phoneNumber;
  OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    authController.phoneAuth(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                fastIntroWidget(),
                Positioned(
                  top: 60,
                  left: 30,
                  child: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xffffeb00),
                        size: 20
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50,),
            otpVerificationWidget(),
          ],
        ),
      ),
    );
  }
}
