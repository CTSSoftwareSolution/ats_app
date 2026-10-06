import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/animated_rail_icon.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_image.dart';
import '../../provider/bottom_navigation_provider.dart';
import '../../provider/create_queue_provider.dart';
import '../login_page/login_screen.dart';

/// Tablet navigation: flat brand-coloured rail with logo, labelled
/// destinations and log out at the bottom.
class TabletNavigationRail extends StatelessWidget {
  const TabletNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        0,
        AppSpacing.lg,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: NavigationRail(
          selectedIndex: navigationProvider.pageIndex,
          onDestinationSelected: navigationProvider.updateIndex,
          minWidth: 80,
          backgroundColor: Colors.transparent,
          labelType: NavigationRailLabelType.all,
          useIndicator: false,
          leadingAtTop: true,
          trailingAtBottom: true,
          selectedLabelTextStyle: AppText.navLabel.copyWith(
            fontFamily: "Bold",
            color: textWhite,
          ),
          unselectedLabelTextStyle: AppText.navLabel.copyWith(color: textWhiteSub),
          leading: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xl,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              padding: const EdgeInsets.all(8),
              child: CustomImage(image: logoImage, height: 28, width: 28),
            ),
          ),

          destinations: bottomNavValue.map((item) {
            return NavigationRailDestination(
              icon: AnimatedRailIcon(icon: item.image, isActive: false),
              selectedIcon: AnimatedRailIcon(icon: item.image, isActive: true),
              label: Text(item.title),
            );
          }).toList(),

          trailing: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: IconButton(
              tooltip: 'Log out',
              onPressed: () {
                customShowDialog(
                  context: context,
                  title: "Log out",
                  subTitle: 'Are you sure you want to log out?',
                  cancelLabel: "Cancel",
                  confirmLabel: "Log out",
                  icon: Icons.logout_rounded,
                  destructive: true,
                  cancelClick: () {
                    context.pop(context);
                  },
                  okClick: () {
                    Preferences.clear();
                    context.read<CreateQueueProvider>().clearUploadedImages();
                    context.read<LoginProvider>().emailController.clear();
                    context.read<LoginProvider>().passwordController.clear();
                    context.push(LoginScreen());
                  },
                );
              },
              icon: CustomImage(
                image: logoutIcon,
                height: 22,
                width: 22,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
