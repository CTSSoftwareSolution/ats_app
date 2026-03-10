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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();


    // Future<void> getAppVersion() async {
    //   try {
    //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //
    //     appVersion = 'Version: ${packageInfo.version}';
    //
    //   } catch (e) {
    //
    //     appVersion = 'Error';
    //   }
    //   notifyListeners();
    // }
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
                              leadingImage: profileGridValues[index].image,
                             title: profileGridValues[index].title,
                             subtitle: profileGridValues[index].subtitle,
                             child: Text("")
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
            context.read<LoginProvider>().emailController.clear();
            context.read<LoginProvider>().passwordController.clear();
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
