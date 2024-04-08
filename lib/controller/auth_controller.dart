import 'dart:io';
import 'dart:developer';

import 'package:fast_taxi/views/home.dart';
import 'package:fast_taxi/utils/app_constants.dart';
import 'package:fast_taxi/views/profile_settings.dart';
import 'package:fast_taxi/views/driver/profile_setup.dart';
import 'package:fast_taxi/models/user_model/user_model.dart';
import 'package:fast_taxi/views/driver/car_registration/car_registration_template.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:path/path.dart' as Path;
import 'package:geocoding/geocoding.dart' as geoCoding;

class AuthController extends GetxController {

  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  var isProfileUploading = false.obs;
  bool isLoginAsDriver = false;

  // Lưu thông tin thẻ thanh toán
  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards').add({
      'name': name,
      'number': number,
      'cvv': cvv,
      'expiry': expiry
    });
    return true;
  }

  RxList userCards = [].obs;

  // Lấy thông tin thẻ thanh toán
  getUserCard() {
    FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards').snapshots().listen((event) {
          userCards.value = event.docs;
    });
  }

  // Kiểm tra số điện thoại
  phoneAuth(String phone) async {
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          credentials = credential;
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error occured $e");
    }
  }

  // Xác minh mã OTP
  verifyOtp(String otpNumber) async {
    log("Called");
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: verId, smsCode: otpNumber);
    log("LogedIn");

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      decideRoute();
    }).catchError((e) {
      print("Error while sign In $e");
    });
  }

  var isDecided = false;
  // Check người dùng đã từng đăng nhập hay chưa
  decideRoute() {
    if(isDecided) {
      return;
    }
    isDecided = true;
    // Kiểm tra đã login chưa
    User? user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      // Kiểm tra người dùng có tồn tại không
      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((value) {
          if(isLoginAsDriver) {
            if(value.exists) {
              print("Driver Home Screen");
            } else {
              Get.offAll(() => const DriverProfileSetup());
            }
          } else {
            if(value.exists) {
              Get.offAll(() => const Home());
            } else {
              Get.offAll(() => const ProfileSettingScreen());
            }
          }
        }).catchError((e) {
          print("Error while decideRoute $e");
        });
    }
  }

  // Upload hình ảnh
  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('users/$fileName'); // Modify this path/string as your need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
      print("Download URL: $value");
    });
    return imageUrl;
  }

  // Lưu thông tin ngời dùng
  storeUserInfo(File? selectedImage, String name, String email, String address,
      {String url = '', LatLng? addressLatLng}) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'email': email,
      'address': address,
      'address_latlng': const GeoPoint(16.071746, 107.9133134),
    }).then((value) {
      print('Okeeeeeeeeee');
      isProfileUploading(false);
      Get.to(() => const Home());
    });
  }

  var myUser = UserModel().obs;

  // Lấy thông tin người dùng
  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }

  // Hiển thị kết quả tìm kiếm địa điểm
  Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
    // const kGoogleApiKey = "AIzaSyBcyjDKkcbcevaWeyjfIllnSASJ2wQLvzg";

    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "vn",
      language: "vi",
      context: context,
      mode: Mode.overlay,
      apiKey: AppConstants.kGoogleApiKey,
      components: [new Component(Component.country, "vn")],
      types: [],
      hint: "Tìm kiếm ở đây",
    );
    return p;
  }

  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations = await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  // Lưu thông tin Driver
  storeDriverProfile(File? selectedImage, String name, String email,
      {String url = '', LatLng? addressLatLng}) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'email': email,
      'isDriver': true,
      'address_latlng': const GeoPoint(16.071746, 107.9133134),
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);
      Get.off(() => const CarRegistrationTemplate());
    });
  }

  Future<bool> uploadCarEntry(Map<String, dynamic> carData) async {
    bool isUploaded = false;
    String uid =  FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid)
        .set(carData, SetOptions(merge: true));

    isUploaded = true;

    return isUploaded;
  }
}
