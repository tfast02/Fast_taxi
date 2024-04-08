import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fast_taxi/widgets/fast_intro_widget.dart';
import 'package:fast_taxi/controller/auth_controller.dart';

class DriverProfileSetup extends StatefulWidget {
  const DriverProfileSetup({Key? key}) : super(key: key);

  @override
  State<DriverProfileSetup> createState() => _DriverProfileSetupState();
}

class _DriverProfileSetupState extends State<DriverProfileSetup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
   GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
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
                  fastIntroWidgetWithoutLogos(
                      title: 'Đăng ký thông tin',
                      subtitle: 'Vui lòng hoàn thành thông tin!'
                  ),
                  // Truy cập Camera
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2
                              )
                            ],
                            shape: BoxShape.circle,
                            color:Colors.white),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      )
                          : Container(
                        width: 120,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                        'Họ và tên', Icons.person_outlined, nameController,(String? input){
                      if(input!.isEmpty){
                        return 'Vui lòng nhập Họ và tên!';
                      }
                      return null;
                    }),

                    const SizedBox(height: 10,),
                    // Text Họ tên, Email
                    TextFieldWidget(
                        'Email', Icons.email, emailController,(String? input){
                      if(input!.isEmpty){
                        return 'Vui lòng nhập email!';
                      }

                      if(!input.isEmail){
                        return 'Enter valid email.';
                      }
                      return null;
                    },onTap: ()async{},readOnly: false),

                    const SizedBox(height: 30,),
                    // Button Đăng ký
                    Obx(() => authController.isProfileUploading.value
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : yellowButton('Đăng ký', () {
                      if(!formKey.currentState!.validate()){
                        return;
                      }
                      if (selectedImage == null) {
                        Get.snackbar('Thông báo', 'Vui lòng thêm ảnh hồ sơ!');
                        return;
                      }
                      authController.isProfileUploading(true);
                      authController.storeDriverProfile(
                          selectedImage!,
                          nameController.text,
                          emailController.text,
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

  TextFieldWidget(String title, IconData iconData, TextEditingController controller,
      Function validator,{Function? onTap,bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7)),
        ),
        const SizedBox(
          height: 6,
        ),
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
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            readOnly: readOnly,
            onTap: ()=> onTap!(),
            validator: (input)=> validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xffA7A7A7)),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: const Color(0xffffeb00),
                ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
