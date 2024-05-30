import 'package:fast_taxi/views/home.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({Key? key}) : super(key: key);

  @override
  State<VerificationPendingScreen> createState() => _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          fastIntroWidgetWithoutLogos(title: 'Thông báo!',subtitle: 'Trạng thái đăng ký'),

          const SizedBox(height: 20,),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  const [
              Text(
                'Hoàn tất đăng ký',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                ),
              ),
              SizedBox(height: 20,),
              Text('Thông tin của bạn đã được xác nhận. '
                  'Bạn có thể bắt đầu nhận các chuyến đi từ khách hàng!',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7D7D7D)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
          const SizedBox(height: 40,),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  Get.off(() => const Home());
                },
                child: Icon(Icons.arrow_forward, color: Colors.white,),
                backgroundColor: const Color(0xffffeb00),
              )
            ),
          ),
        ],
      ),
    );
  }
}
