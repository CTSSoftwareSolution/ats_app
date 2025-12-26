import 'package:ats_app/Presentation/screens/profile_view_edit_page/edit_personal_details_item.dart';
import 'package:ats_app/Presentation/screens/profile_view_edit_page/edit_vehicle_details_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/profile_details_provider.dart';

class ProfileViewEditScreen extends StatefulWidget {
  const ProfileViewEditScreen({super.key});

  @override
  State<ProfileViewEditScreen> createState() => _ProfileViewEditScreenState();
}

class _ProfileViewEditScreenState extends State<ProfileViewEditScreen> {

  @override
  void initState(){
    super.initState();
    final profileDetails = Provider.of<ProfileDetailsProvider>(context,listen:false);
    profileDetails.profileDetailsApi(context);
  }
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomText(text: "Personal Details", fontSize: 18, fontFamily: "Heavy",),
              ),
              EditPersonalDetailsItem(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomText(text: "Car Details", fontSize: 18, fontFamily: "Heavy",),
              ),
              EditVehicleDetailsItem()
            ],
          ),
        ),
      ),
    );
  }
}
