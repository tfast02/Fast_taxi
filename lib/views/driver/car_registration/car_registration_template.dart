import 'dart:io';

import 'package:fast_taxi/controller/auth_controller.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/document_uploaded_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/location_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/upload_document_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_color_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_make_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_model_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_model_year_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_number_page.dart';
import 'package:fast_taxi/views/driver/car_registration/pages/vehicle_type_page.dart';
import 'package:fast_taxi/views/driver/verification_pending_screen.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarRegistrationTemplate extends StatefulWidget {
  const CarRegistrationTemplate({Key? key,}) : super(key: key);

  @override
  State<CarRegistrationTemplate> createState() => _CarRegistrationTemplateState();
}

class _CarRegistrationTemplateState extends State<CarRegistrationTemplate> {

  int currentPage = 0;
  String selectedLocation = '';
  String selectedVehicleType = '';
  String selectedVehicleMake = '';
  String selectModelYear = '';
  PageController pageController = PageController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();

  File? vehicleRegistration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          fastIntroWidgetWithoutLogos(
              title: 'Đăng ký thông tin xe',
              subtitle: 'Vui lòng hoàn thành quá trình đăng ký!'
          ),
          const SizedBox(height: 20,),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // Các Page đăng ký xe
            child: PageView(
              onPageChanged: (int page) {
                currentPage = page;
              },
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LocationPage(
                  selectedLocation: selectedLocation,
                  onSelect: (String location) {
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                ),
                VehicleTypePage(
                  selectedVehicle: selectedVehicleType,
                  onSelect: (String vehicleType) {
                    setState(() {
                      selectedVehicleType = vehicleType;
                    });
                  },
                ),
                VehicleMakePage(
                  selectedVehicle: selectedVehicleMake,
                  onSelect: (String vehicleMake) {
                    setState(() {
                      selectedVehicleMake = vehicleMake;
                    });
                  },
                ),
                VehicleModelPage(
                  controller: vehicleModelController,
                ),
                VehicleModelYearPage(
                  onSelect: (int year){
                    setState(() {
                      selectModelYear = year.toString();
                    });
                  },
                ),
                VehicleNumberPage(
                  controller: vehicleNumberController,
                ),

                VehicleColorPage(
                  controller: vehicleColorController,
                ),
                UploadDocumentPage(onImageSelected: (File image){
                  vehicleRegistration = image;
                },),
                const DocumentUploadedPage()
              ],
            ),
          )),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => isUploading.value
                  ? const Center(child: CircularProgressIndicator(),)
                  : FloatingActionButton(
                onPressed: () {
                  if(currentPage < 8) {
                    pageController.animateToPage(
                        currentPage + 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn
                    );
                  } else {
                    uploadDriverCarEntry();
                  }
                },
                child: Icon(Icons.arrow_forward, color: Colors.white,),
                backgroundColor: const Color(0xffffeb00),
              )
              ),
            ),
          ),
        ],
      ),
    );
  }

  var isUploading = false.obs;

  void uploadDriverCarEntry() async {

    isUploading(true);
    String imageUrl = await Get.find<AuthController>()
        .uploadImage(vehicleRegistration!);

    Map<String, dynamic> carData = {
      'country': selectedLocation,
      'vehicle_type': selectedVehicleType,
      'vehicle_make': selectedVehicleMake,
      'vehicle_year': selectModelYear,
      'vehicle_model': vehicleModelController.text.trim(),
      'vehicle_number': vehicleNumberController.text.trim(),
      'vehicle_color': vehicleColorController.text.trim(),
      'vehicle_registration': imageUrl
    };
    await Get.find<AuthController>().uploadCarEntry(carData);
    isUploading(false);
    Get.off(() => const VerificationPendingScreen());
  }
}
