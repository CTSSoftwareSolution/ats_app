import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/image_data.dart';
import '../../provider/vehicle_type_provider.dart';
import '../home_pages/build_vehicle_card.dart';
import '../vehicles_class_page/vehicle_class_screen.dart';


class TypeScreen extends StatefulWidget {
  const TypeScreen({super.key});

  @override
  State<TypeScreen> createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  @override
  Widget build(BuildContext context) {
    final typeProvider = context.watch<VehicleTypeProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: Text("Type",style: TextStyle(color: Colors.white, fontFamily: "SemiBold",fontSize: 20),),
      ),
      body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: typeProvider.vehicleTypeEntity!.data!.length <= 4 ? typeProvider.vehicleTypeEntity?.data?.length : 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (BuildContext context, int index) {
              return buildVehicleCard(
                  title: typeProvider.vehicleTypeEntity!.data![index].vehicleType.toString(),
                  imagePath: vehicleGridImages[index], onTap: () {
                    typeProvider.setSelectedType(typeProvider.vehicleTypeEntity!.data![index]);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> VehicleClassScreen()));
                  }
              );
            },
          )

      ))
    );
  }
}
