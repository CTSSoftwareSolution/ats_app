import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/profile_details_provider.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailsProvider>().profileDetailsApi();
  }

  @override
  Widget build(BuildContext context) {
    final profileDetails = context.watch<ProfileDetailsProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        backgroundColor: appColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [appColor, appColor.withValues(alpha:0.78)],
            ),
          ),
        ),
        title: const CustomText(
          text: "Profile",
          fontSize: 20,
          fontFamily: "Bold",
          textColor: Colors.white,
        ),
      ),

      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [appColor, appColor.withValues(alpha:0.78)],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -30,
                    right: -20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha:0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -14,
                    left: -14,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha:0.05),
                      ),
                    ),
                  ),

                  // Avatar + name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                    child: Column(
                      children: [
                        // Avatar ring
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 74,
                                height: 74,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha:0.18),
                                ),
                              ),
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha:0.13),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CustomImage(
                                      image: profileDetails.imageUrl ?? "",
                                      fit: BoxFit.cover,
                                      switchToNetwork: true,
                                      defaultImage: userImage,
                                    ),
                                  ),
                                ),
                              ),
                              // Online dot
                              Positioned(
                                right: 6,
                                bottom: 6,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF3DB85C),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        10.height,

                        CustomText(
                          text: profileDetails.nameController.text.isNotEmpty
                              ? profileDetails.nameController.text
                              : "Your Name",
                          fontSize: 17,
                          fontFamily: "Bold",
                          textColor: Colors.white,
                        ),
                        4.height,
                        CustomText(
                          text: profileDetails.emailController.text.isNotEmpty
                              ? profileDetails.emailController.text
                              : "your@email.com",
                          fontSize: 12,
                          fontFamily: "Medium",
                          textColor: Colors.white.withValues(alpha:0.72),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.height,
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(
                    icon: Icons.person_outline_rounded,
                    label: "Personal Information",
                  ),
                  8.height,
                  _infoCard(children: [
                    _infoRow(
                      icon: Icons.badge_outlined,
                      label: "Full Name",
                      value: profileDetails.nameController.text,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.email_outlined,
                      label: "Email Id",
                      value: profileDetails.emailController.text,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.phone_outlined,
                      label: "Mobile Number",
                      value: profileDetails.mobileController.text,
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.location_on_outlined,
                      label: "Address",
                      value: profileDetails.addressController.text,
                    ),
                  ]),
                  20.height,
                  _sectionLabel(
                    icon: Icons.directions_car_outlined,
                    label: "Vehicle Information",
                  ),
                  8.height,
                  _infoCard(children: [
                    _infoRow(
                      icon: Icons.car_rental_outlined,
                      label: "Car Name",
                      value: profileDetails.carNameController.text=="null"?"N/A":profileDetails.carNameController.text.toString(),
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.branding_watermark_outlined,
                      label: "Car Brand",
                      value: profileDetails.carBrandController.text=="null"?"N/A":profileDetails.carBrandController.text.toString(),
                    ),
                    _divider(),
                    _infoRow(
                      icon: Icons.model_training_outlined,
                      label: "Car Model",
                      value: profileDetails.carModelController.text=="null"?"N/A":profileDetails.carModelController.text,
                    ),
                  ]),
                  24.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _sectionLabel({required IconData icon, required String label}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: appColor.withValues(alpha:0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: appColor),
      ),
      10.width,
      CustomText(
        text: label,
        fontSize: 13.5,
        fontFamily: "Bold",
        textColor: const Color(0xFF1A2340),
      ),
    ],
  );
}

Widget _infoCard({required List<Widget> children}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF9BA8C3).withValues(alpha:0.14),
          blurRadius: 18,
          spreadRadius: 0,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(children: children),
    ),
  );
}

Widget _infoRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColor.withValues(alpha:0.13),
                appColor.withValues(alpha:0.05),
              ],
            ),
          ),
          child: Icon(icon, size: 16, color: appColor),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontSize: 11,
                fontFamily: "Medium",
                textColor: const Color(0xFF9AA5C0),
              ),
              3.height,
              CustomText(
                text: value.isNotEmpty ? value : "—",
                fontSize: 14,
                fontFamily: "Bold",
                textColor: const Color(0xFF1A2340),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _divider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0xFFEAEDF5),
            Colors.transparent,
          ],
        ),
      ),
    ),
  );
}