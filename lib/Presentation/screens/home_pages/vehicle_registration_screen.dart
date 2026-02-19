import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

import '../../../utilities/extension.dart';
import '../../../widgets/custom_text.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 100.0,
          decoration: BoxDecoration(
            color: appColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                appColor.withOpacity(0.65),
                appGradientColor.withOpacity(0.35),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [

            ],
          ),
        )
      ],
    );
  }
}
