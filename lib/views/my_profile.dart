import 'dart:io';

import 'package:fast_taxi/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({Key? key,}) : super(key: key);


  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if(image != null){
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  late LatLng address;

  @override
  void initState() {
    super.initState();
    nameController.text = authController.myUser.value.name??"";
    emailController.text = authController.myUser.value.email??"";
    addressController.text = authController.myUser.value.address??"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.4,
              child: Stack(
                children: [
                  fastIntroWidgetWithoutLogos(title: 'Trang cá nhân'),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null ?
                      authController.myUser.value.image!=null ? Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          image: authController.myUser.value.image == null ?  const DecorationImage(
                              image: AssetImage('assets/person.png'),
                              fit: BoxFit.fill
                          ) : DecorationImage(
                            image: NetworkImage(authController.myUser.value.image!),
                            fit: BoxFit.fill
                          ),
                            shape: BoxShape.circle,
                            color:  const Color(0xffD6D6D6)
                        ),
                      ) : Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD6D6D6)
                        ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                      ): Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(selectedImage!),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                            color: const Color(0xffD6D6D6)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget('Họ và tên', Icons.person_outlined,
                        nameController, (String? input) {
                          if(input!.isEmpty) {
                            return 'Vui lòng nhập Họ và tên!';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10,),
                    TextFieldWidget('Email', Icons.mail_outlined,
                        emailController, (String? input) {
                          if(input!.isEmpty) {
                            return 'Vui lòng nhập Email!';
                          }
                          if(!input.contains("@")) {
                            return 'Địa chỉ Email không đúng định dạng!';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10,),
                    TextFieldWidget('Địa chỉ', Icons.home_outlined,
                        addressController, (String? input) {
                          if(input!.isEmpty) {
                            return 'Vui lòng nhập địa chỉ!';
                          }
                          return null;
                        },
                        onTap: () async {
                          Prediction? p = await authController.showGoogleAutoComplete(context);
                          // Translate address đã chọn và convert sang LatLng obj
                          address = await authController.buildLatLngFromAddress(p!.description!);
                          addressController.text = p.description!;
                          // Lưu thông tin vào firebase khi click Button Cập nhật


                        }, readOnly: true),
                    const SizedBox(height: 30,),
                    Obx(() => authController.isProfileUploading.value
                        ? const Center(child: CircularProgressIndicator(),)
                        : yellowButton('Cập nhật', () {
                      if(!formKey.currentState!.validate()) {
                        return;
                      }
                      authController.isProfileUploading(true);
                      authController.storeUserInfo(
                          selectedImage,
                          nameController.text,
                          emailController.text,
                          addressController.text,
                        url: authController.myUser.value.image??"",
                        // addressLatLng: address,
                      );
                    })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFieldWidget(String title, IconData iconData,
      TextEditingController controller, Function validator, {Function? onTap,bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7)
          ),
        ),
        const SizedBox(height: 6,),
        Container(
          width: Get.width,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)
          ),
          child: TextFormField(
            readOnly: readOnly,
            onTap: () => onTap!(),
            validator: (input) => validator(input),
            controller: controller,
            style: GoogleFonts.poppins(fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xffA7A7A7)
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(iconData, color: const Color(0xffffeb00),),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget yellowButton(String title, Function onPressed) {
    return MaterialButton(
      minWidth: Get.width,
      height: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      color: const Color(0xffffeb00),
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
