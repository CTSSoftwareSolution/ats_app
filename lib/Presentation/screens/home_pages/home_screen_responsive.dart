import 'package:ats_app/Presentation/screens/home_pages/select_vehicle.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import 'image_slider.dart';

class HomeScreenResponsive extends StatelessWidget {
  const HomeScreenResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.contentMaxWidth),
        child:
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40.0),
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical:constraints.isTablet ? 40.0 : 30.0,horizontal: constraints.isTablet ? 25.0 : 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                constraints.isTablet ?
                CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black") :
                Row(
                  children: [
                    CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                    15.width,
                    CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                  ],
                ),
                25.height,
                ImageSlider(),
                30.height,
                SelectVehicle(),
                60.height,
                CustomText(text: "Scan, Detect", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
                Row(
                  children: [
                    CustomText(text: "Drive Safe", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
                    10.width,
                    CustomImage( image: heartIcon,scale: 4,),
                  ],
                ),
                20.height,
                CustomImage(scale: 4, image: dividerImage,),
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
        ),
      );
    });
  }
}
