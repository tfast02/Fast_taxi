import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:fast_taxi/views/login_screen.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:fast_taxi/controller/auth_controller.dart';

class DecisionScreen extends StatelessWidget {
  DecisionScreen({super.key});

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            fastIntroWidget(),

            const SizedBox(height: 50,),
            // Đăng nhập tài xế
            DecisionButton(
              'assets/driver.png',
              'Đăng nhập tài xế',
                (){
                authController.isLoginAsDriver = true;
                Get.to(() => const LoginScreen());
                },
              Get.width*0.8
            ),

            // Đăng nhập người dùng
            const SizedBox(height: 20,),
            DecisionButton(
                'assets/customer.png',
                'Đăng nhập người dùng',
                    (){
                      authController.isLoginAsDriver = false;
                      Get.to(() => const LoginScreen());
                    },
                Get.width*0.8
            ),
          ],
        ),
      ),
    );
  }

  // Button Decision (Tài xế và người dùng)
  Widget DecisionButton (String icon, String text, Function onPressed,
      double width, {double height = 60}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  spreadRadius: 1
              )
            ]
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: height,
              decoration: const BoxDecoration(
                color: Color(0xffffeb00),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)
                ),
              ),
              child: Center(child: Image.asset(icon, width: 40,),),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black,  fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
