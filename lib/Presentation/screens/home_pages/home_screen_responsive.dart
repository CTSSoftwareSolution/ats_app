import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen_responsive_item.dart';


class HomeScreenResponsive extends StatelessWidget {
  const HomeScreenResponsive({super.key});

  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return
          orientation == Orientation.landscape ?
            Row(
              children: [
                Expanded(child: HomeScreenResponsiveItem()),
                VerticalDivider(),
                Expanded(child: VehicleClassScreen()),
              ],
            ) :
          HomeScreenResponsiveItem();
      }
    );
  }
}
