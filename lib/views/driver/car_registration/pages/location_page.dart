import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.selectedLocation, required this.onSelect}) : super(key: key);

  final String selectedLocation;
  final Function onSelect;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  List<String> locations = ['Hà nội', 'TP Đà Nẵng', 'TP Hồ Chí Mình'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Địa điểm bạn muốn đăng ký?',
          style: TextStyle(
            fontSize: 20,
            fontWeight:FontWeight.w600,
            color: Colors.black
          ),
        ),

        const SizedBox(height: 10,),
        ListView.builder(
          itemBuilder: (ctx,i){
            return ListTile(
              onTap: () => widget.onSelect(locations[i]),
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(locations[i]),
              trailing: widget.selectedLocation == locations[i] ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xffffeb00),
                  child: Icon(Icons.check, color: Colors.white, size: 15,),
                ),
              ): const SizedBox.shrink(),
            );
          },
          itemCount: locations.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
