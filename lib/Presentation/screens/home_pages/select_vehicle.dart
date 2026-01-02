import 'package:ats_app/Presentation/provider/vehicle_type_provider.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/select_vehicle_shimmer.dart';
import '../vehicles_class_page/vehicle_class_screen.dart';
import 'build_vehicle_card.dart';

class SelectVehicle extends StatefulWidget {
  const SelectVehicle({super.key});

  @override
  State<SelectVehicle> createState() => _SelectVehicleState();
}

class _SelectVehicleState extends State<SelectVehicle> {
  @override
  Widget build(BuildContext context) {
    final typeProvider = context.watch<VehicleTypeProvider>();
    return typeProvider.isLoading
        ? SelectVehicleShimmer()
        : typeProvider.vehicleTypeEntity!.data!.isEmpty
        ? SelectVehicleShimmer()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Select Vehicle",
                fontSize: 20.0,
                fontFamily: "ExtraBold",
              ),
              SizedBox(height: 10.0),
              GridView.builder(
                itemCount: typeProvider.vehicleTypeEntity!.data!.length <= 4
                    ? typeProvider.vehicleTypeEntity?.data?.length
                    : 4,
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
                    title: typeProvider
                        .vehicleTypeEntity!
                        .data![index]
                        .vehicleType
                        .toString(),
                    imagePath: vehicleGridImages[index],
                    onTap: () {
                      typeProvider.setSelectedType(
                        typeProvider.vehicleTypeEntity!.data![index],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleClassScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
  }
}
