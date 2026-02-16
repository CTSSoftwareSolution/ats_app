import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/profile_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/profile_details_provider.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {


  @override
  void initState(){
    super.initState();
    context.read<ProfileDetailsProvider>().profileDetailsApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileDetails = context.watch<ProfileDetailsProvider>();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        title: CustomText(
          text: "Profile",
          fontSize: 20,
          fontFamily: "SemiBold",
          textColor: whiteColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: ImageIcon(
            AssetImage(backArrowIcon),
            color: whiteColor,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child:

        ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          children: [
           // ProfileDetailsContainer(),
            buildSection([
             20.height,
              CircleAvatar(
                backgroundColor: whiteColor,
                radius: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    child: CustomImage(image: profileDetails.imageUrl??"",fit: BoxFit.cover,switchToNetwork: true,defaultImage: userImage,),
                  ),
                ),
              ),
             15.height,
              buildProfileView(
                title: "Full Name",
                value: profileDetails.nameController.text
              ),
             10.height,
              buildProfileView(
                  title: "Email Id",
                  value: profileDetails.emailController.text
              ),
              10.height,
              buildProfileView(
                  title: "Mobile Number",
                  value: profileDetails.mobileController.text
              ),
              10.height,
              buildProfileView(
                  title: "Address",
                  value: profileDetails.addressController.text
              ),
              20.height,
            ]),
            15.height,
            buildSection([
              20.height,
              buildProfileView(
                  title: "Car Name",
                  value: profileDetails.carNameController.text
              ),
              10.height,
              buildProfileView(
                  title: "Car Brand",
                  value: profileDetails.carBrandController.text
              ),
              10.height,
              buildProfileView(
                  title: "Car Model",
                  value: profileDetails.carModelController.text
              ),
              20.height,
            ]),
          ],

        ),
      ),
    );
  }
}
