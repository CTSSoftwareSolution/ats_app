import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widget_navigation_icon.dart';
import '../../provider/bottom_navigation_provider.dart';

class CustomBottomNavigation extends StatelessWidget {

  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          navigationIcon(homeIcon, 0, 'Home',navigationProvider.pageIndex,navigationProvider.updateIndex),
          navigationIcon(resultIcon, 1, 'Result',navigationProvider.pageIndex,navigationProvider.updateIndex),
         // navigationIcon(vehicleIcon, 2, 'Plate',navigationProvider.pageIndex,navigationProvider.updateIndex),
          navigationIcon(profileIcon, 2, 'Profile',navigationProvider.pageIndex,navigationProvider.updateIndex),
        ],
      ),
    );
  }
}