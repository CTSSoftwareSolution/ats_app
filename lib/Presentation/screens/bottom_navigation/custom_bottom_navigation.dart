import 'package:ats_app/Core/network/InternetCheck/network_status.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widget_navigation_icon.dart';
import '../../provider/bottom_navigation_provider.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.read<BottomNavigationProvider>();

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        children: [
          navigationIcon(homeIcon, 0, 'Home',navigationProvider.pageIndex,
            (index) {
              if (context.read<NetworkStatus>().isConnected) {
                navigationProvider.updateIndex(index);
              } else {
                CustomLoader.internetMessage(
                  msg: "No Internet Connection",
                  context: context,
                );
              }
            },
          ),
          navigationIcon(resultIcon, 1, 'Result',navigationProvider.pageIndex,
            (index) {
              if (context.read<NetworkStatus>().isConnected) {
                navigationProvider.updateIndex(index);
              } else {
                CustomLoader.internetMessage(
                  msg: "No Internet Connection",
                  context: context,
                );
              }
            },
          ),
          navigationIcon(profileIcon, 2, 'Profile',navigationProvider.pageIndex,
            (index) {
              if (context.read<NetworkStatus>().isConnected) {
                navigationProvider.updateIndex(index);
              } else {
                CustomLoader.internetMessage(
                  msg: "No Internet Connection",
                  context: context,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}