
import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_menu_section.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_menu_tile.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config/ip_address_bottom_sheet_screen.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../provider/create_queue_provider.dart';
import '../../provider/login_provider.dart';

import '../login_page/login_screen.dart';
import 'change_password_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  /// Index of the "Logout" entry in [profileGridValues] (see [click]).
  static const int _logoutIndex = 6;

  /// Index of the "Change Password" entry in [profileGridValues] (see [click]).
  static const int _changePasswordIndex = 4;

  /// Index of the "Ip Config" entry in [profileGridValues] (see [click]).
  static const int _ipConfigIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.page,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xl,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileDetailsContainer(),
            const SizedBox(height: AppSpacing.xl),
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
              child: Text("SETTINGS", style: AppText.overline),
            ),
            ProfileMenuSection(
              children: List.generate(profileGridValues.length, (index) {
                final item = profileGridValues[index];
                return ProfileMenuTile(
                  image: item.image,
                  icon: index == _ipConfigIndex
                      ? Icons.settings_ethernet_rounded
                      : index == _changePasswordIndex
                          ? Icons.lock_reset_rounded
                          : null,
                  title: item.title,
                  subtitle: item.subtitle,
                  destructive: index == _logoutIndex,
                  onTap: () {
                    click(index, context);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void click(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:

        break;
      case 3:

        break;
      case _changePasswordIndex:
        context.push(const ChangePasswordScreen());
        break;
      case _ipConfigIndex:
        showIpAddressBottomSheet(context);
        break;
      case _logoutIndex:
        customShowDialog(
          context: context,
          title: "Log out",
          subTitle: 'Are you sure, you want to log out?',
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
        break;
      default:
        break;
    }
  }
}



