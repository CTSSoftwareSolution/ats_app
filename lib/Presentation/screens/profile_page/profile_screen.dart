import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_image.dart';
import '../../provider/login_provider.dart';
import '../login_page/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: Text("Profile",style: TextStyle(color: Colors.white, fontFamily: "SemiBold",fontSize: 20),),
      ),
      body: SafeArea(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                child: ProfileDetailsContainer(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                child: GestureDetector(
                  onTap: (){
                    customShowDialog(context: context, title: "Log out", subTitle: 'Are you sure, you want to log out?',
                        cancelClick: () {
                          context.pop(context);
                        },
                        okClick: () {
                          Preferences.clear();
                          loginProvider.emailController.clear();
                          loginProvider.passwordController.clear();
                          context.push(LoginScreen());
                        }
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: cardBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                      child: Row(
                        children: [
                          CustomImage(image: logoutIcon,height: 35.0,width: 35.0,color: appColor,),
                          SizedBox(width: 10.0,),
                          CustomText(text: "Logout",fontSize: 16.0,fontFamily: "Bold",)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
