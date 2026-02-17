import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import '../utilities/image_data.dart';
import 'custom_button.dart';
import 'custom_text.dart';

customShowDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required VoidCallback cancelClick,
  required VoidCallback okClick,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final isTablet = constraints.isTablet;
            final isLandscape = orientation == Orientation.landscape;
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet
                      ? (isLandscape
                      ? constraints.maxWidth / 2.5
                      : constraints.maxWidth / 1.5)
                      : double.infinity,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28.0),
                    boxShadow: [
                      BoxShadow(
                        color: appColor.withOpacity(0.12),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
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
                          padding: EdgeInsets.fromLTRB(
                              20, isTablet ? 22 : 18, 20, isTablet ? 22 : 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [appColor, appColor.withOpacity(0.75)],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.help_outline_rounded,
                                        color: Colors.white, size: 16,
                                      ),
                                    ),
                                    10.width,
                                    CustomText(
                                      text: title,
                                      fontSize: isTablet ? 18.0 : 15.5,
                                      fontWeight: FontWeight.w700,
                                      textColor: Colors.white,
                                    ),
                                  ]),
                                  // Close button
                                  GestureDetector(
                                    onTap: () => context.pop(),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.white, size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              20, isTablet ? 22 : 18,
                              20, isTablet ? 22 : 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFFE4E8F4), width: 1),
                                ),
                                child: CustomText(
                                  text: subTitle,
                                  fontSize: isTablet ? 17.0 : 14.0,
                                  fontWeight: FontWeight.w500,
                                  textColor: const Color(0xFF3D5080),
                                ),
                              ),

                              16.height,
                              Row(children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          appColor,
                                          appColor.withOpacity(0.78),
                                        ],
                                      ),
                                      boxShadow: [BoxShadow(
                                        color: appColor.withOpacity(0.28),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      )],
                                    ),
                                    child: CustomButton(
                                      width: double.infinity,
                                      height: isTablet ? 44.0 : 40.0,
                                      buttonText: "Yes",
                                      onPress: okClick,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      fontSize: isTablet ? 16.0 : 13.5,
                                    ),
                                  ),
                                ),
                                10.width,
                                Expanded(
                                  child: GestureDetector(
                                    onTap: cancelClick,
                                    child: Container(
                                      height: isTablet ? 44.0 : 40.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F3FA),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: "No",
                                        fontSize: isTablet ? 16.0 : 13.5,
                                        fontWeight: FontWeight.w700,
                                        textColor: const Color(0xFF6B7A99),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}