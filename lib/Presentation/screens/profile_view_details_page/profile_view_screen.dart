import 'package:ats_app/utilities/profile_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/profile_details_provider.dart';
import '../profile_page/profile_details_container.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {


  @override
  void initState(){
    super.initState();
    final profileDetails = Provider.of<ProfileDetailsProvider>(context,listen:false);
    profileDetails.profileDetailsApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileDetails = Provider.of<ProfileDetailsProvider>(context);
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          children: [
           // ProfileDetailsContainer(),
            buildSection([
              SizedBox(height: 20.0),
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
              SizedBox(height: 15.0),
              buildProfileView(
                title: "Full Name",
                value: profileDetails.nameController.text
              ),
              SizedBox(height: 10.0),
              buildProfileView(
                  title: "Email Id",
                  value: profileDetails.emailController.text
              ),
              SizedBox(height: 10.0),
              buildProfileView(
                  title: "Mobile Number",
                  value: profileDetails.mobileController.text
              ),
              SizedBox(height: 10.0),
              buildProfileView(
                  title: "Address",
                  value: profileDetails.addressController.text
              ),
              SizedBox(height: 20.0),
            ]),
            SizedBox(height: 15.0),
            buildSection([
              SizedBox(height: 20.0),
              buildProfileView(
                  title: "Car Name",
                  value: profileDetails.carNameController.text
              ),
              SizedBox(height: 10.0),
              buildProfileView(
                  title: "Car Brand",
                  value: profileDetails.carBrandController.text
              ),
              SizedBox(height: 10.0),
              buildProfileView(
                  title: "Car Model",
                  value: profileDetails.carModelController.text
              ),
              SizedBox(height: 20.0),
            ]),
          ],

        ),
      ),
    );
  }
}
