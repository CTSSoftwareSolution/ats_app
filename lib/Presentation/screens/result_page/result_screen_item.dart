import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/image_data.dart';

class ResultScreenItem extends StatelessWidget {
  final Appointments appointments;
  final VoidCallback? onRetest;

  const ResultScreenItem({
    super.key,
    required this.appointments,
    this.onRetest,
  });

  @override
  Widget build(BuildContext context) {

    bool isPass = appointments.manualStatus == "Pass";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// Vehicle Info Row
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF3F6FC),
                    ),
                    child: Center(
                      child: CustomImage(image: defaultImage, scale: 4),
                    ),
                  ),

                  8.width,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: appointments.registrationNo ?? "",
                          fontFamily: "Bold",
                          fontSize: 18,
                          textColor: const Color(0xFF1C2A45),
                        ),

                        2.height,

                        CustomText(
                          text: appointments.vehicleClass ?? "",
                          fontFamily: "Medium",
                          fontSize: 14,
                          textColor: const Color(0xFF8F9BB8),
                        ),
                      ],
                    ),
                  ),

                  /// Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isPass
                          ? const Color(0xFFDAFFE1)
                          : const Color(0xFFFFE2E2),
                    ),
                    child: CustomText(
                      text: appointments.manualStatus ?? "",
                      fontFamily: "Bold",
                      fontSize: 11,
                      textColor: isPass ? greenColor : redColor,
                    ),
                  ),
                ],
              ),

              6.height,

              Divider(
                color: Colors.grey.shade200,
                height: 1,
              ),

              6.height,

              /// Retest Button
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onRetest,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF5B8CFF),
                          Color(0xFF3D6BFF),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Retest",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}