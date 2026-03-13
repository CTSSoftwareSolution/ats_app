import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/image_data.dart';

class ResultScreenItem extends StatelessWidget {
  final ManualLisAppointments appointments;
  final VoidCallback? onRetest;

  const ResultScreenItem({
    super.key,
    required this.appointments,
    this.onRetest,
  });

  @override
  Widget build(BuildContext context) {

    bool isPass = appointments.manualStatus == "Pass";

    final Color passGreen = const Color(0xFF1DB77A);
    final Color failRed  = const Color(0xFFE24B4A);
    final Color statusColor = isPass ? passGreen : failRed;

    final Color passBg = const Color(0xFFEAF8F1);
    final Color failBg = const Color(0xFFFCEBEB);
    final Color statusBg = isPass ? passBg : failBg;

    final List<Color> accentGradient = isPass
        ? [const Color(0xFF1DB77A), const Color(0xFF5DCAA5)]
        : [const Color(0xFFE24B4A), const Color(0xFFF09595)];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.08),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color(0xFFF3F6FC),
                          border: Border.all(
                            color: const Color(0xFFE4EAF6),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: CustomImage(image: defaultImage, scale: 4),
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: appointments.registrationNo ?? "",
                              fontFamily: "Bold",
                              fontSize: 17,
                              textColor: const Color(0xFF1C2A45),
                            ),

                            4.height,

                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF8F9BB8),
                                  ),
                                ),
                                4.width,
                                CustomText(
                                  text: appointments.vehicleClass ?? "",
                                  fontFamily: "Medium",
                                  fontSize: 12,
                                  textColor: const Color(0xFF8F9BB8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: statusBg,
                          border: Border.all(
                            color: statusColor.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                              ),
                            ),
                            5.width,
                            CustomText(
                              text: appointments.manualStatus ?? "",
                              fontFamily: "Bold",
                              fontSize: 11,
                              textColor: statusColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Divider(
                    color: const Color(0xFFF0F3FA),
                    height: 1,
                    thickness: 1,
                  ),
                  10.height,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFFF3F6FC),
                          border: Border.all(
                            color: const Color(0xFFE4EAF6),
                            width: 1,
                          ),
                        ),
                        child: CustomText(
                          text: "Manual",
                          fontFamily: "Medium",
                          fontSize: 11,
                          textColor: const Color(0xFF8F9BB8),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onRetest,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFF1C2A45),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.refresh_rounded,
                                  color: Colors.white, size: 13),
                              SizedBox(width: 5),
                              Text(
                                "Retest",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}