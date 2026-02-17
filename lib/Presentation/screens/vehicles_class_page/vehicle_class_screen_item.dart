import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';

class VehicleClassScreenItem extends StatelessWidget {
  final ClassDataModel classDataModel;
  final VoidCallback onTap;
  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9BA8C3).withOpacity(0.16),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              // Left accent bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        appColor,
                        appColor.withOpacity(0.35),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Vehicle icon box
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appColor.withOpacity(0.14),
                            appColor.withOpacity(0.06),
                          ],
                        ),
                      ),
                      child: Center(
                        child: CustomImage(image: defaultImage, scale: 5.5),
                      ),
                    ),

                    14.width,

                    // Main info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: classDataModel.vehicleClass.toString(),
                            fontFamily: "Bold",
                            fontSize: 16.0,
                            textColor: const Color(0xFF1A2340),
                          ),
                          5.height,
                          // Reg No pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFFDDE3F0), width: 1),
                            ),
                            child: CustomText(
                              text: classDataModel.regNo.toString(),
                              fontFamily: "Bold",
                              fontSize: 11.5,
                              textColor: const Color(0xFF3D5080),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          5.height,
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_car_outlined,
                                size: 12,
                                color: Color(0xFF9AA5C0),
                              ),
                              4.width,
                              CustomText(
                                text: classDataModel.make.toString(),
                                fontFamily: "Medium",
                                fontSize: 12.0,
                                textColor: const Color(0xFF8F9BB8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    10.width,

                    // Fuel type badge (top-right)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: appColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: appColor.withOpacity(0.20),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImage(image: petrolIcon, scale: 5.5),
                              5.width,
                              CustomText(
                                text: classDataModel.fuelType.toString(),
                                fontSize: 11.5,
                                fontFamily: "Bold",
                                textColor: appColor,
                              ),
                            ],
                          ),
                        ),
                        10.height,
                        // Arrow indicator
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4FB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: Color(0xFF9AA5C0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}