import 'package:flutter/material.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/image_data.dart';
import '../../../../utilities/preferences.dart';
import '../../../../widgets/custom_image.dart';

class BuildHeaderHome extends StatelessWidget {
  const BuildHeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appColor, appColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: appColor.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LogoBadge(image: gvtLogo),
          Column(
            children: [
              const Text(
                'ATS Corporation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Vehicle Inspection System',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withOpacity(0.75),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Preferences.getLocation(),
                      style:  TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _LogoBadge(image: ceriseLogo),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  final String image;
  const _LogoBadge({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomImage(image: image, height: 38, width: 38),
    );
  }
}


