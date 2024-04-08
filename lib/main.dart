import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fast_taxi/views/decision_screen.dart';
import 'package:fast_taxi/controller/auth_controller.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Yêu cầu cấp quyền truy cập vị trí
  await Permission.locationWhenInUse.request();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    authController.decideRoute();
    final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home: DecisionScreen(),
    );
  }
}
