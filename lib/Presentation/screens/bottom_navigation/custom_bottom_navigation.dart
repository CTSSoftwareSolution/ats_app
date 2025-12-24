import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:flutter/material.dart';

import '../../../widgets/widget_navigation_icon.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          navigationIcon(homeIcon, 0, 'Home',currentIndex,onTabSelected),
          navigationIcon(resultIcon, 1, 'Result',currentIndex,onTabSelected),
          navigationIcon(vehicleIcon, 2, 'Type',currentIndex,onTabSelected),
          navigationIcon(profileIcon, 3, 'Profile',currentIndex,onTabSelected),
        ],
      ),
    );

  }



}
