import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';

class VehicleClassScreenItem extends StatelessWidget {
  final ClassDataModel classDataModel;
  final VoidCallback onTap;
  const VehicleClassScreenItem({super.key, required this.onTap, required this.classDataModel});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: cardBackgroundColor,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomImage(image: defaultImage,scale: 4,),
                      SizedBox(width: 15.0,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: classDataModel.vehicleClass.toString(),fontFamily: "Bold",fontSize: 18.0,),
                            CustomText(text: classDataModel.regNo.toString(),fontFamily: "Medium",fontSize: 14.0,overflow: TextOverflow.visible,),
                            SizedBox(height: 3.0,),
                            CustomText(text: classDataModel.make.toString(),fontFamily: "Medium",fontSize: 14.0,overflow: TextOverflow.visible,),
                          ],
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  CustomImage(image: petrolIcon,scale: 4.5,),
                  SizedBox(width: 5.0,),
                  CustomText(text: classDataModel.fuelType.toString(),fontSize: 14.0,fontFamily: "Bold",)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
