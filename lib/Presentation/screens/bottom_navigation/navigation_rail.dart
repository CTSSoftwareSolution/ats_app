import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/animated_rail_icon.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_image.dart';
import '../../provider/bottom_navigation_provider.dart';
import '../login_page/login_screen.dart';

class TabletNavigationRail extends StatelessWidget {


  const TabletNavigationRail({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return Padding(
      padding: EdgeInsets.only(top: 40, bottom: 15, left: 20),
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: [Color(0xff345afa), Color(0xff19162e)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        child: NavigationRail(
          selectedIndex: navigationProvider.pageIndex,
          onDestinationSelected: navigationProvider.updateIndex,
          minWidth: 70,
          backgroundColor: Colors.transparent,
          labelType: NavigationRailLabelType.none,
          useIndicator: false,
          leadingAtTop: true,
          trailingAtBottom: true,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(8),
              child: CustomImage(
                image: logoImage,
                height: 28,
                width: 28,
              ),
            ),
          ),

          destinations: bottomNavValue.map((item) {
            return NavigationRailDestination(
              icon: CustomImage(
                image: item.image,
                height: 22,
                width: 22,
                color: whiteColor.withOpacity(0.6),
              ),
              selectedIcon: AnimatedRailIcon(icon: item.image, isActive: true),
              label: const SizedBox.shrink(),
            );
          }).toList(),

          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: InkWell(
              onTap: () {
                customShowDialog(
                  context: context,
                  title: "Log out",
                  subTitle: 'Are you sure, you want to log out?',
                  cancelClick: () {
                    context.pop(context);
                  },
                  okClick: () {
                    Preferences.clear();
                    context.read<LoginProvider>().emailController.clear();
                    context.read<LoginProvider>().passwordController.clear();
                    context.push(LoginScreen());
                  },
                );
              },
              child: CustomImage(
                image: logoutIcon,
                height: 25,
                width: 25,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
