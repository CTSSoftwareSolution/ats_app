
import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:ats_app/utilities/profile_menu_widget.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';

import '../../../app_config/ip_address_bottom_sheet_screen.dart';
import '../../../Data/model/profile_model.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';

import '../login_page/login_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  static const int _logoutIndex = 5;

  Widget _menuTile(int index) {
    final item = profileGridValues[index];
    final isLogout = index == _logoutIndex;
    return InkWell(
      onTap: (){
        click(index,context);
      },
      child: buildTile(
        leadingImage: item.image,
        title: item.title,
        subtitle: item.subtitle,
        accent: isLogout ? fail : appColor,
        child: item.trailingType == ProfileTrailingType.arrow
            ? const Icon(Icons.chevron_right_rounded, color: textMuted)
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuIndexes = [
      for (int i = 0; i < profileGridValues.length; i++)
        if (i != _logoutIndex) i,
    ];
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileDetailsContainer(),
            const SizedBox(height: 20),
            const _SectionLabel("Settings"),
            buildSection(menuIndexes.map(_menuTile).toList()),
            if (_logoutIndex < profileGridValues.length) ...[
              const SizedBox(height: 16),
              buildSection([_menuTile(_logoutIndex)]),
            ],
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
      case 4:
        showIpAddressBottomSheet(context);
        break;
      case 5:
        customShowDialog(
          context: context,
          title: "Log out",
          subTitle: 'Are you sure, you want to log out?',
          cancelClick: () {
            context.pop(context);
          },
          okClick: () {
            Preferences.clear();
            context.push(LoginScreen());
          },
        );
        break;
      case 6:
        break;
      default:
        break;
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontFamily: "Bold",
          color: textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
