import 'package:ats_app/Presentation/provider/inspection_result_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

statusDialogBox({required BuildContext context}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (BuildContext context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: [
            BoxShadow(
              color: appColor.withOpacity(0.12),
              blurRadius: 40,
              spreadRadius: 0,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      appColor,
                      appColor.withOpacity(0.72),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.manage_search_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            10.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: "Change Status",
                                  fontSize: 15.0,
                                  fontFamily: "Bold",
                                  textColor: Colors.white,
                                ),
                                2.height,
                                CustomText(
                                  text: "Update inspection result",
                                  fontSize: 11.0,
                                  fontFamily: "Medium",
                                  textColor: Colors.white.withOpacity(0.70),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _statusCard(
                            label: "System Status",
                            status: "Pass",
                            isPass: true,
                            icon: Icons.computer_rounded,
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: _statusCard(
                            label: "Current Status",
                            status: "Pass",
                            isPass: true,
                            icon: Icons.verified_rounded,
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFFDF1F1),
                        border: Border.all(
                          color: const Color(0xFFE53935).withOpacity(0.20),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE5E5),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: Color(0xFFD94040),
                                  size: 13,
                                ),
                              ),
                              8.width,
                              const CustomText(
                                text: "Change status to FAIL",
                                fontSize: 12.5,
                                fontFamily: "Bold",
                                textColor: Color(0xFFBF2E2E),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Transform.scale(
                              scale: 0.82,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(
                                    color: Color(0xFFD94040), width: 2),
                                activeColor: const Color(0xFFD94040),
                                checkColor: Colors.white,
                                value: context
                                    .watch<InspectionResultProvider>()
                                    .isChecked,
                                onChanged: (value) {
                                  context
                                      .read<InspectionResultProvider>()
                                      .toggleCheckbox(value!);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.height,
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: appColor,
                          ),
                        ),
                        7.width,
                        const CustomText(
                          text: "Reason",
                          fontSize: 12.5,
                          fontFamily: "Bold",
                          textColor: Color(0xFF1A2340),
                        ),
                      ],
                    ),
                    8.height,
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE4E8F4), width: 1.2),
                      ),
                      child: CustomTextField(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        fillColor: Colors.transparent,
                        minLines: 3,
                        hint: "Describe the reason here...",
                        controller: context
                            .watch<InspectionResultProvider>()
                            .controller,
                        hintStyle: const TextStyle(
                          fontFamily: "Medium",
                          fontSize: 12,
                          color: Color(0xFFB8C0D4),
                        ),
                        readOnly: false,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: InputFormatters.descriptionValidation,
                      ),
                    ),
                    14.height,
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F3FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const CustomText(
                                text: "Cancel",
                                fontSize: 13.5,
                                fontFamily: "Bold",
                                textColor: Color(0xFF6B7A99),
                              ),
                            ),
                          ),
                        ),
                        10.width,
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  appColor,
                                  appColor.withOpacity(0.78),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: appColor.withOpacity(0.30),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CustomButton(
                              width: double.infinity,
                              height: 44,
                              buttonText: "Submit",
                              onPress: () => context.pop(),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              fontSize: 13.5,
                              fontFamily: "Bold",
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
      ),
    ),
  );
}

Widget _statusCard({
  required String label,
  required String status,
  required bool isPass,
  required IconData icon,
}) {
  final Color statusColor =
  isPass ? const Color(0xFF2A8C44) : const Color(0xFFBF2E2E);
  final Color bgColor =
  isPass ? const Color(0xFFEDF7EF) : const Color(0xFFFDF0F0);
  final Color iconBg =
  isPass ? const Color(0xFFD4F0DC) : const Color(0xFFFFE5E5);

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FD),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFEAEDF5), width: 1.2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, color: statusColor, size: 12),
            ),
            5.width,
            Flexible(
              child: CustomText(
                text: label,
                fontSize: 10,
                fontFamily: "Medium",
                textColor: const Color(0xFF8F9BB8),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        6.height,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                ),
              ),
              4.width,
              CustomText(
                text: status,
                fontSize: 11,
                fontFamily: "Bold",
                textColor: statusColor,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}