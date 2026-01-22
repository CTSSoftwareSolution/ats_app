import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
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
    final typeProvider = context.watch<VehicleTypeProvider>().vehicleTypeEntity?.data ?? [];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: Text("Type",style: TextStyle(color: Colors.white, fontFamily: "SemiBold",fontSize: 20),),
      ),
      body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: context.watch<VehicleTypeProvider>().isLoading
              ? Center(child: CustomLoader.loader(),)
              : typeProvider.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(image: emptyBoxImage,scale: 2.5,),
                CustomText(
                  text: "No active vehicle type found",
                  fontFamily: "Bold",
                  fontSize: 17,
                ),
              ],
            ),
          )
              :
          GridView.builder(
            itemCount: typeProvider.length <= 4 ? typeProvider.length : 4,
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
                  title: typeProvider[index].vehicleType.toString(),
                  imagePath: vehicleGridImages[index], onTap: () {
                context.read<VehicleTypeProvider>().setSelectedType(typeProvider[index]);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> VehicleClassScreen()));
                  }
              );
            },
          )

      ))
    );
  }
}
