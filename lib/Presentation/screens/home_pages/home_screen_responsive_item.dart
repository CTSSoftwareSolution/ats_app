import 'package:ats_app/Presentation/screens/home_pages/select_vehicle.dart';
import 'package:ats_app/Presentation/screens/home_pages/vehicle_registration_screen.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/image_data.dart';
import '../../../vehicle_number_plate/vehicle_number_plate_screen.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import 'image_slider.dart';

class HomeScreenResponsiveItem extends StatefulWidget {
  const HomeScreenResponsiveItem({super.key});

  @override
  State<HomeScreenResponsiveItem> createState() => _HomeScreenResponsiveItemState();
}

class _HomeScreenResponsiveItemState extends State<HomeScreenResponsiveItem> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 40.0),
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: isTablet ? 50.0 : 30.0,horizontal: isTablet ? 20.0 : 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isTablet ?
            CustomText(text: "ATS Corporation", fontSize: isTablet ? 34.0 : 24.0, fontFamily: "Black") :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                    15.width,
                    CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                  ],
                ),
                InkWell(
                  onTap: (){
                    context.push(VehicleNumberPlateScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: BorderRadius.circular(40.0)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomImage(image: photoCaptureIcon,height: 15.0,width: 15.0,color: whiteColor,),
                      )),
                ),
              ],
            ),
            isTablet ? 20.height :25.height,
            // ImageSlider(),
            // isTablet ? 35.height :30.height,
            SelectVehicle(),
            isTablet ? 35.height :30.height,
            VehicleRegistrationScreen(),
            isTablet ? 70.height :60.height,
            CustomText(text: "Scan, Detect", fontFamily: "Heavy", fontSize:  isTablet ? 56.0 : 46.0,textColor: scanTextColor,),
            Row(
              children: [
                CustomText(text: "Drive Safe", fontFamily: "Heavy", fontSize:  isTablet ? 56.0 :46.0,textColor: scanTextColor,),
                10.width,
                CustomImage(image: heartIcon,scale:  isTablet ? 2.5 : 4),
              ],
            ),
            20.height,
            CustomImage(scale: isTablet ? 2.5 : 4, image: dividerImage,),
            20.height,
            Row(
              children: [
                CustomImage(image: logoImage,height: 18.0,width: 18.0,),
                10.width,
                CustomText(text: "ATS Corporation", fontSize: 15.0, fontFamily: "Black",)
              ],
            ),
            40.height
          ],
        ),
      ),
    );
  }
}
