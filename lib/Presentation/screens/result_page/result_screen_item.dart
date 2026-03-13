import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/image_data.dart';

class ResultScreenItem extends StatelessWidget {
  final Appointments appointments;
  const ResultScreenItem({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Icon container
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: const Color(0xFFF0F4FB),
                    ),
                    child: Center(
                      child: CustomImage(image: defaultImage, scale: 6.5),
                    ),
                  ),
                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: appointments.registrationNo!,
                          fontFamily: "Bold",
                          fontSize: 17.0,
                          textColor: const Color(0xFF1C2A45),
                        ),
                        5.height,
                        CustomText(
                          text: appointments.vehicleClass!,
                          fontFamily: "Medium",
                          fontSize: 12.5,
                          textColor: const Color(0xFF8F9BB8),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              14.height,
              Container(
                height: 1,
                color: const Color(0xFFF0F2F7),
              ),
              12.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 7.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: appointments.manualStatus=="Pass"?Color(0xFFDAFFE1):const Color(0xFFFDF0F0),
                    ),
                    child: CustomText(
                      text: appointments.manualStatus!,
                      fontFamily: "Bold",
                      fontSize: 12.5,
                      textColor: appointments.manualStatus=="Pass"?greenColor:redColor,
                    ),
                  ),
                  10.width,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}