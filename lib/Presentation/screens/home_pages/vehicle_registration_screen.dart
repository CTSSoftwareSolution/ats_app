import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import '../../../utilities/image_data.dart';
import '../../../vehicle_number_plate/vehicle_number_plate_screen.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(VehicleNumberPlateScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC5CAD8).withValues(alpha:0.35),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha:0.9),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 60,
                    height:  60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xFFF0F4FB),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CustomImage(
                        scale: 5,
                        image: carNumberPlateImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Detect Number Plate",
                        fontSize: 17.0,
                        fontFamily: "Bold",
                        textColor: blackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      5.height,
                      CustomText(
                        text: "Smart Detection, Secure Roads",
                        fontSize: 13.0,
                        fontFamily: "Medium",
                        textColor: greyColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CustomImage(image: forwardIcon, color: blackColor, scale: 4,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
