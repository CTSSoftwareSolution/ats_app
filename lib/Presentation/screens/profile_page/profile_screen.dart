import 'package:ats_app/Presentation/provider/profile_details_provider.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:ats_app/utilities/profile_menu_widget.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_image.dart';
import '../../provider/login_provider.dart';
import '../login_page/login_screen.dart';
import '../profile_view_details_page/profile_view_screen.dart';
import '../profile_view_edit_page/profile_view_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileDetailsProvider>(
      context,
      listen: false,
    );
    provider.getAppVersion();
  }

  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final provider = Provider.of<ProfileDetailsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "SemiBold",
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(12.0),
          children: [
            ProfileDetailsContainer(),
            SizedBox(height: 20),
            buildSection([
              buildTile(
                editProfileIcon,
                "Personal Details",
                "View your personal details",
                Image.asset(forwardIcon, height: 12),
                    () {
                  context.push(ProfileViewScreen());
                },
              ),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(
                notificationIcon,
                "Notification",
                "Manage your alerts and notifications",
                Switch(
                  padding: EdgeInsets.zero,
                  activeThumbColor: appColor,
                  value: switchValue,
                  onChanged: (value) => setState(() => switchValue = value),
                ),
                () {},
              ),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(
                privacyIcon,
                "Privacy Policy",
                "Learn how we protect your data",
                Image.asset(forwardIcon, height: 12),
                () {},
              ),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(
                termsIcon,
                "Terms & Conditions",
                "Our rules, explained simply",
                Image.asset(forwardIcon, height: 12),
                () {},
              ),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(
                contactUsIcon,
                "Contact Us",
                "We are here, if you need any help",
                Image.asset(forwardIcon, height: 12),
                () {},
              ),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(logoutIcon, "Logout",
                  "Sign out safely and easily",
                  SizedBox.shrink(),
                      () {
                customShowDialog(
                  context: context,
                  title: "Log out",
                  subTitle: 'Are you sure, you want to log out?',
                  cancelClick: () {
                    context.pop(context);
                  },
                  okClick: () {
                    Preferences.clear();
                    loginProvider.emailController.clear();
                    loginProvider.passwordController.clear();
                    context.push(LoginScreen());
                  },
                );
              }),
            ]),
            SizedBox(height: 10),
            buildSection([
              buildTile(
                versionControlIcon,
                provider.appVersion,
                "",
                SizedBox.shrink(),
                () {},
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
