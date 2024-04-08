import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String? address;
  String? email;
  String? image;
  String? name;

  LatLng? latLngAddress;

  UserModel({this.name, this.email, this.image, this.address});

  UserModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    email = json['email'];
    image = json['image'];
    name = json['name'];
    latLngAddress = LatLng(json['address_latlng'].latitude, json['address_latlng'].longitude);
  }
}