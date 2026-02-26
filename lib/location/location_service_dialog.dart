import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

Future<bool?> showLocationServiceDialog(BuildContext context,
    {required Function(BuildContext dialogContext) onDialogCreated}
    ) async {
  final locationProvider = Provider.of<LocationProvider>(
    context,
    listen: false,
  );
  return await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (dialogContext) {
      onDialogCreated(dialogContext);
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/Location.json',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              CustomText(
                text: locationProvider.errorMessage.toString(),
                fontSize: 18.0,
                fontFamily: "Bold",
              ),
              5.height,
              CustomText(
                textAlign: TextAlign.center,
                text: "Please enable location services to use this feature.",
                fontSize: 16.0,
                fontFamily: "Medium",
              ),
              15.height,
              CustomButton(
                width: double.infinity,
                height: 40.0,
                buttonText: "Enable",
                onPress: () async {
                  if (locationProvider.isLocationServiceDisabled) {
                    await Geolocator.openLocationSettings();
                  } else {
                    await Geolocator.openAppSettings();
                  }
                  context.pop();
                },
                backgroundColor: appColor,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fontSize: 18.0,
                fontFamily: "Bold",
              ),
              15.height,
            ],
          ),
        ),
      );

    }
  );
}
