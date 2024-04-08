import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleModelYearPage extends StatefulWidget {
  const VehicleModelYearPage({Key? key,required this.onSelect}) : super(key: key);

  final Function onSelect;

  @override
  State<VehicleModelYearPage> createState() => _VehicleModelYearPageState();
}

class _VehicleModelYearPageState extends State<VehicleModelYearPage> {


  List<int> years = [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014,
    2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        const Text(
          'Năm Sản xuất xe (Model year)?',
          style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(child: Center(
          child: CupertinoPicker.builder(
            childCount: years.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                  child: Text(
                    years[index].toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )
              );
            },
            itemExtent: 100,
            onSelectedItemChanged: (value) {
              widget.onSelect(years[value]);
            },
          ),
        )),
      ],
    );
  }
}
