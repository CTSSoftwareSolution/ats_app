import 'package:ats_app/Presentation/provider/profile_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_page/inspection_page.dart';
import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:ats_app/utilities/profile_menu_widget.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/model/profile_model.dart';
import '../../../app_config/ip_address_bottom_sheet_screen.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../provider/login_provider.dart';
import '../login_page/login_screen.dart';
import '../manual_inspection_images/manual_inspection_image_screen.dart';
import '../profile_view_details_page/profile_view_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailsProvider>().getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 12, right: 10
              ),
              child: ProfileDetailsContainer(),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top:10,bottom: 100),
                physics: BouncingScrollPhysics(),
                itemCount: profileGridValues.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 12,
                    ),
                    child: InkWell(
                      onTap: (){
                        click(index,context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Column(
                          children: [
                            buildTile(
                              profileGridValues[index].image,
                              index == 7 ? context.watch<ProfileDetailsProvider>().appVersion : profileGridValues[index].title,
                              profileGridValues[index].subtitle,
                              getTrailingWidget(profileGridValues[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void click(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.push(ProfileViewScreen());
        break;
      case 1:
        break;
      case 2:
        context.push(InspectionPage());
        break;
      case 3:
        context.push(ManualInspectionImageScreen());
        break;
      case 4:
        break;
      case 5:
        showIpAddressBottomSheet(context);
        break;
      case 6:
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
        break;
      case 7:
        break;
      default:
        break;
    }
  }

  Widget getTrailingWidget(ProfileModel item) {
    switch (item.trailingType) {
      case ProfileTrailingType.arrow:
        return Image.asset(forwardIcon, height: 12);
      case ProfileTrailingType.switchButton:
        return Switch(
          activeThumbColor: appColor,
          value:  context.watch<ProfileDetailsProvider>().switchValue,
          onChanged: (value) {
            setState(() {
              context.read<ProfileDetailsProvider>().switchValue = value;
            });
          },
        );
      case ProfileTrailingType.none:
        return SizedBox.shrink();
    }
  }
}
