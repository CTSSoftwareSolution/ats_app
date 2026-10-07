import 'package:flutter/material.dart';

import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';

class ErrorScreen extends StatelessWidget {
  final InspectionFormProvider provider;
  const ErrorScreen({super.key, required this.provider});

  /// Plain-language reason for the provider's error text. The provider's
  /// messages carry exception details ("SocketException…", "status=false…")
  /// that mean nothing to an inspector; only the kind of failure is shown.
  static (IconData, String) describe(String detail) {
    final d = detail.toLowerCase();
    if (d.startsWith('request timed out')) {
      return (
        Icons.timer_off_outlined,
        'The server took too long to respond. Check your connection and try again.',
      );
    }
    if (d.startsWith('no internet connection')) {
      return (
        Icons.wifi_off_rounded,
        "You're offline. Connect to the internet and try again.",
      );
    }
    if (d.startsWith('api error')) {
      return (
        Icons.cloud_off_rounded,
        "The server couldn't return the questions for this vehicle. Try again in a moment.",
      );
    }
    return (
      Icons.error_outline_rounded,
      'Something went wrong while loading the questions. Try again.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final (icon, message) = describe(provider.errorMessage.trim());
    return Center(
      child: SingleChildScrollView(
        child: AppStateView.error(
          icon: icon,
          title: "Couldn't load inspection questions",
          message: message,
          actionLabel: 'Try again',
          onAction: () => provider.fetchInspectionData(),
        ),
      ),
    );
  }
}
