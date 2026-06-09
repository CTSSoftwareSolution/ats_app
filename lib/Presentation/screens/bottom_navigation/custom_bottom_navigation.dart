import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/widget_navigation_icon.dart';
import '../../provider/bottom_navigation_provider.dart';
import '../vehicle_test_parameter/vehicle_parts_screen.dart';

class CustomBottomNavigation extends StatelessWidget {

  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: appColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                navigationIcon(homeIcon, 0, 'Home',
                    navigationProvider.pageIndex,
                    navigationProvider.updateIndex),
                navigationIcon(resultIcon, 1, 'Result',
                    navigationProvider.pageIndex,
                    navigationProvider.updateIndex),
                navigationIcon(profileIcon, 2, 'Profile',
                    navigationProvider.pageIndex,
                    navigationProvider.updateIndex),
              ],
            ),
          ),
        ),

       // const SizedBox(width: 10),

        Expanded(
          flex: 1,
          child: InkWell(
            onTap: (){
              context.push(VehiclePartsScreen());
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: appColor,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              child: Center(child: Icon(Icons.precision_manufacturing_outlined,color: whiteColor,),)
            ),
          ),
        ),
      ],
    );
  }
}
