import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:fast_taxi/views/payment.dart';
import 'package:fast_taxi/views/my_profile.dart';
import 'package:fast_taxi/widgets/text_widget.dart';
import 'package:fast_taxi/views/decision_screen.dart';
import 'package:fast_taxi/controller/auth_controller.dart';
import 'package:fast_taxi/controller/polyline_handler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoding/geocoding.dart' as geoCoding;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends   State<Home> {
  String? _mapStyle;

  AuthController authController = Get.find<AuthController>();

  late LatLng destination;
  late LatLng source;

  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  @override
  void initState() {
    super.initState();
    authController.getUserInfo();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    loadCustomMarker();
  }

  String dropdownValue = '**** **** **** 8789';
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(15.9752982,108.2497801),
    zoom: 14,
  );

  GoogleMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              // mapType: MapType.terrain,
              markers: markers,
              polylines: polyline,
              zoomControlsEnabled: false, // Ẩn nút zoom lớn nhỏ của Google Maps
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
              },
              initialCameraPosition: _kGooglePlex,
            ),
          ),

          buildProfileTile(),
          buildTextField(),
          showSourceField ? buildTextFieldForSource() : Container(),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 48,
      left: 16,
      right: 16,
      child: Obx(() => authController.myUser.value.name == null ?
      const Center(child: CircularProgressIndicator(),) :
      Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(color: Colors.white70),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: authController.myUser.value.image == null ?  const DecorationImage(
                      image: AssetImage('assets/person.png'),
                      fit: BoxFit.fill
                  ) : DecorationImage(
                      image: NetworkImage(authController.myUser.value.image!),
                      fit: BoxFit.fill
                  )
              ),
            ),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Xin chào ',
                            style: TextStyle(color: Colors.black, fontSize: 16)
                        ),
                        TextSpan(
                          text: authController.myUser.value.name == null
                              ? "User" : authController.myUser.value.name!,
                          style: const TextStyle(
                            color: Color(0xffffeb00),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                  ),
                ),
                const Text(
                  "Bạn muốn đi đâu?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  bool showSourceField = false;

  Widget buildTextField() {
    return Positioned(
      top: 148,
      left: 16,
      right: 16,
      child: Container(
        width: Get.width,
        height: 52,
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 8)
            ],
            borderRadius: BorderRadius.circular(8)
        ),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            Prediction? p = await authController.showGoogleAutoComplete(context);
            String selectedPlace = p!.description!;
            destinationController.text = selectedPlace;
            List<geoCoding.Location> locations = await geoCoding.locationFromAddress(selectedPlace);
            destination = LatLng(locations.first.latitude, locations.first.longitude);

            markers.add(Marker(
              markerId: MarkerId(selectedPlace),
              infoWindow: InfoWindow(title: 'Đến: $selectedPlace',),
              position: destination,
              icon: BitmapDescriptor.fromBytes(markIcons),
            ));

            myMapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14)
                //17 is new zoom level
              )
            );
            setState(() {
              showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7)
          ),
          decoration: InputDecoration(
            hintText: 'Nhập nơi bạn muốn đến...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.search,),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 200,
      left: 16,
      right: 16,
      child: Container(
        width: Get.width,
        height: 52,
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 4,
                  blurRadius: 8)
            ],
            borderRadius: BorderRadius.circular(8)
        ),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {
            buildSourceSheet();
          },
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7)
          ),
          decoration: InputDecoration(
            hintText: 'Từ: ',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            suffixIcon:  const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.search,),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildCurrentLocationIcon() {
    return const Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 32, right: 12),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xffffeb00),
          child: Icon(Icons.my_location, color: Colors.white,),
        ),
      ),
    );
  }

  Widget buildNotificationIcon () {
    return  const Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 32, left: 12),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications, color: Colors.grey,),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width*0.8,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 10,
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
          )
        ),
        child: Center(
          child: Container(
            width: Get.width*0.4,
            height: 2,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  buildDrawerItem({required String title, required Function onPressed,
    Color color = Colors.black, double fontSize = 20, double height = 44,
    FontWeight fontWeight = FontWeight.normal, bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(title, style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color
            ),),
            const SizedBox(width: 4,),
            isVisible? CircleAvatar(
              backgroundColor: const Color(0xffffeb00),
              radius: 12,
              child: Text('1', style: GoogleFonts.poppins(color: Colors.white),
              ),
            ): Container()
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const MyProfile());
            },
            child: SizedBox(
              height: 148,
              child: DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: authController.myUser.value.image == null ? const DecorationImage(
                          image: AssetImage('assets/person.png'),
                          fit: BoxFit.fill
                        ) : DecorationImage(
                            image: NetworkImage(authController.myUser.value.image!),
                            fit: BoxFit.fill
                        )
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Xin chào',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.24),
                              fontSize: 16
                            ),
                          ),
                          Text(
                            authController.myUser.value.name == null ? "User"
                                : authController.myUser.value.name!,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Thanh toán',
                    onPressed:() => Get.to(()=> PaymentScreen())
                ),
                buildDrawerItem(
                    title: 'Lịch sử đi lại',
                    onPressed:(){},
                    isVisible: true
                ),
                buildDrawerItem(title: 'Mời bạn bè', onPressed:(){}),
                buildDrawerItem(title: 'Mã giảm giá', onPressed:(){}),
                buildDrawerItem(title: 'Hỗ trợ', onPressed:(){}),
                buildDrawerItem(title: 'Cài đặt', onPressed:(){}),
                buildDrawerItem(title: 'Đăng xuất', onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => DecisionScreen());
                }),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          Text(
            'Copyright©2023 Fast Taxi All Rights Reserved | Designed by TFast',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.12),
            ),
          ),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }

  late Uint8List markIcons;
  loadCustomMarker() async {
      markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec  codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void buildSourceSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height*0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8)
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 12,),
          const Text(
            "Chọn vị trí của bạn",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            "Vị trí của bạn",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12,),
          InkWell(
            onTap: () async {
              source = authController.myUser.value.latLngAddress!;
              overflow: TextOverflow.ellipsis;
              maxLines: 1;
              if(markers.length >= 2) {
                markers.remove(markers.last);
              }

              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.address!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.address!}',
                  ),
                  position: source
              ));
              await getPolyLines(source, destination);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});
              Get.back();
              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 8,
                    )
                  ]
              ),
              child: Row(
                children: [
                  Text(
                    authController.myUser.value.address!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
          InkWell(
            onTap: () async {
              Get.back();
              Prediction? p = await authController.showGoogleAutoComplete(context);
              String place = p!.description!;
              sourceController.text = place;

              source = await authController.buildLatLngFromAddress(place);
              if(markers.length >= 2) {
                markers.remove(markers.last);
              }

              markers.add(Marker(
                  markerId: MarkerId(place),
                  infoWindow: InfoWindow(title: 'Source: $place',),
                  position: source
              ));
              await getPolyLines(source, destination);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});
              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 8,
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Tìm kiếm vị trí",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20,),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(height: 20,),
          buildDriversList(),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Xác nhận',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  color: const Color(0xffffeb00),
                  shape: const StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  int selectedRide = 0;
  buildDriversList() {
    return Container(
      height: 92,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 4, left: 4, top: 4, bottom: 4),
      height: 84,
      width: 172,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? const Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1
            )
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? const Color(0xff2DBB54) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '50.000',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 phút',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/mask_group.png'))
        ],
      ),
    );
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/visa.png',width: 40,),
          const SizedBox(width: 10,),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
