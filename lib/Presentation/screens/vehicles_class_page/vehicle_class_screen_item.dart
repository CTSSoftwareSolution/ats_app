import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';

class VehicleClassScreenItem extends StatefulWidget {
  final Appointments classDataModel;
  final VoidCallback onTap;

  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
  });

  @override
  State<VehicleClassScreenItem> createState() => _VehicleClassScreenItemState();
}

class _VehicleClassScreenItemState extends State<VehicleClassScreenItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: appColor.withValues(alpha: 0.09),
                blurRadius: 28,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF9BA8C3).withValues(alpha: 0.08),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          appColor.withValues(alpha: 0.07),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          appColor,
                          appColor.withValues(alpha: 0.20),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFDDE3F0),
                                width: 1,
                              ),
                            ),
                            child: CustomText(
                              text: "Booking Id : ${widget.classDataModel.bookingId}"
                                  .toString(),
                              fontFamily: "Bold",
                              fontSize: 11.0,
                              textColor: const Color(0xFF3D5080),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFDDE3F0),
                                width: 1,
                              ),
                            ),
                            child: CustomText(
                              text: "${formatDate(widget.classDataModel.appointmentDate.toString())} : ${formatTime(widget.classDataModel.appointmentDate.toString())}",
                              fontFamily: "Bold",
                              fontSize: 11.0,
                              textColor: const Color(0xFF3D5080),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  appColor.withValues(alpha: 0.16),
                                  appColor.withValues(alpha: 0.05),
                                ],
                              ),
                              border: Border.all(
                                color: appColor.withValues(alpha: 0.14),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: CustomImage(image: defaultImage, scale: 5.0),
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: widget.classDataModel.registrationNo
                                            .toString(),
                                        fontFamily: "Bold",
                                        fontSize: 16.5,
                                        textColor: const Color(0xFF0F1829),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            appColor.withValues(alpha: 0.14),
                                            appColor.withValues(alpha: 0.06),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: appColor.withValues(alpha: 0.20),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomImage(
                                              image: petrolIcon, scale: 5.5),
                                          5.width,
                                          CustomText(
                                            text: widget.classDataModel.fuelType
                                                .toString(),
                                            fontSize: 11.5,
                                            fontFamily: "Bold",
                                            textColor: appColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                8.height,
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 9, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F6FB),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFFDDE3F0),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.tag_rounded,
                                              size: 10,
                                              color: Color(0xFF6B7BA4)),
                                          4.width,
                                          CustomText(
                                            text: widget.classDataModel.vehicleClass
                                                .toString(),
                                            fontFamily: "Bold",
                                            fontSize: 11.0,
                                            textColor: const Color(0xFF3D5080),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    10.width,
                                    const Icon(
                                      Icons.directions_car_outlined,
                                      size: 12,
                                      color: Color(0xFF9AA5C0),
                                    ),
                                    4.width,
                                    Flexible(
                                      child: CustomText(
                                        text: widget.classDataModel.make
                                            .toString(),
                                        fontFamily: "Medium",
                                        fontSize: 12.0,
                                        textColor: const Color(0xFF8F9BB8),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
}