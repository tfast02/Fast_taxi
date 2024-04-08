import 'package:flutter/material.dart';

class VehicleTypePage extends StatefulWidget {
  const VehicleTypePage({Key? key,required this.onSelect,required this.selectedVehicle}) : super(key: key);

  final String selectedVehicle;
  final Function onSelect;

  @override
  State<VehicleTypePage> createState() => _VehicleTypePageState();
}

class _VehicleTypePageState extends State<VehicleTypePage> {

  List<String> vehicleType = ['Cá nhân', 'Doanh nghiệp'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Bạn đăng ký cho cá nhân hay doanh nghiệp?',
          style: TextStyle(
              fontSize: 20,
              fontWeight:FontWeight.w600,
              color: Colors.black
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(itemBuilder: (ctx,i){
            return ListTile(
              onTap: ()=> widget.onSelect(vehicleType[i]),
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(vehicleType[i]),
              trailing: widget.selectedVehicle == vehicleType[i] ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xffffeb00),
                  child: Icon(Icons.check,color: Colors.white,size: 15,),
                ),
              ): const SizedBox.shrink(),
            );
          },itemCount: vehicleType.length),
        ),
      ],
    );
  }
}
