import 'package:ats_app/Presentation/provider/vehicle_type_provider.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
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
    final typeProvider = context.watch<VehicleTypeProvider>().vehicleTypeEntity?.data ?? [];
    return context.watch<VehicleTypeProvider>().isLoading
        ? SelectVehicleShimmer()
        : typeProvider.isEmpty
        ? SelectVehicleShimmer()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Select Vehicle",
                fontSize: 18.0,
                fontFamily: "ExtraBold",
              ),
              10.height,
              GridView.builder(
                itemCount: typeProvider.length <= 4
                    ? typeProvider.length
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
                    title: typeProvider[index].vehicleType.toString(),
                    imagePath: vehicleGridImages[index],
                    onTap: () {
                      context.read<VehicleTypeProvider>().setSelectedType(typeProvider[index]);
                      final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                      if (!isLandscape) {
                        context.push(VehicleClassScreen());
                      }
                      },
                  );
                },
              ),
            ],
          );
  }
}
