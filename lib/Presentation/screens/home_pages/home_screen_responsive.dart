import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/vehicle_type_provider.dart';
import '../vehicles_class_page/tablet_vehicle_class_screen.dart';
import 'home_screen_responsive_item.dart';


class HomeScreenResponsive extends StatelessWidget {
   const HomeScreenResponsive({super.key});



  @override
  Widget build(BuildContext context) {
    final selectedType =
        context.watch<VehicleTypeProvider>().selectedType;
    return OrientationBuilder(
      builder: (context, orientation) {

        return
          orientation == Orientation.landscape ?
            Row(
              children: [
                Expanded(child: HomeScreenResponsiveItem()),
               Padding(
                 padding: const EdgeInsets.only(top: 50.0,bottom: 15),
                 child: VerticalDivider(thickness: 3,),
               ),
                Expanded(child:
                selectedType?.id == null ?
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(image: noDataIcon,scale: 4,),
                      15.height,
                      CustomText(
                        text: "No data found",
                        fontFamily: "Bold",
                        fontSize: 17,
                      ),
                      7.height,
                      CustomText(
                        textAlign: TextAlign.center,
                        text: "Select a vehicle to\n continue.",
                        fontFamily: "Medium",
                        fontSize: 17,
                      ),
                    ],
                  ),
                ) :
                TabletVehicleClassScreen()),
              ],
            ) :
          HomeScreenResponsiveItem();
      }
    );
  }
}
