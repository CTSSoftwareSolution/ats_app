import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/utilities/new_app_theme/app_layout.dart';
import 'package:ats_app/utilities/new_app_theme/app_spacing.dart';
import 'package:ats_app/utilities/new_app_theme/app_text.dart';
import 'package:ats_app/widgets/new_app_ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

Future<bool?> showLocationServiceDialog(
  BuildContext context, {
  VoidCallback? onSettingsOpened,
}) async {
  final locationProvider = Provider.of<LocationProvider>(
    context,
    listen: false,
  );

  return await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxDialogWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.dialog),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/Location.json',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                locationProvider.errorMessage.toString(),
                textAlign: TextAlign.center,
                style: AppText.dialogTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Please enable location services to use this feature.",
                textAlign: TextAlign.center,
                style: AppText.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: "Enable",
                icon: Icons.location_on_rounded,
                onPressed: () async {
                  Navigator.pop(ctx); // Close the dialog first
                  onSettingsOpened?.call(); // then set the flag
                  await Geolocator.openAppSettings();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
