import 'package:flutter/material.dart';

class VehicleMakePage extends StatefulWidget {
  const VehicleMakePage({Key? key,required this.onSelect,required this.selectedVehicle}) : super(key: key);

  final String selectedVehicle;
  final Function onSelect;

  @override
  State<VehicleMakePage> createState() => _VehicleMakePageState();
}

class _VehicleMakePageState extends State<VehicleMakePage> {


  List<String> vehicleMake = ['Honda', 'GMC', 'Ford', 'BMW', 'Khác'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        const Text(
          'Hãng xe bạn đăng ký?',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(itemBuilder: (ctx,i){
            return ListTile(
              onTap: ()=> widget.onSelect(vehicleMake[i]),
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(vehicleMake[i]),
              trailing: widget.selectedVehicle == vehicleMake[i] ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xffffeb00),
                  child: Icon(Icons.check,color: Colors.white,size: 15,),
                ),
              ): const SizedBox.shrink(),
            );
          },itemCount: vehicleMake.length),
        ),

      ],
    );
  }
}
