import 'package:flutter/material.dart';

import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';

class ErrorScreen extends StatelessWidget {
  final InspectionFormProvider provider;
  const ErrorScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final detail = provider.errorMessage.trim();
    return Center(
      child: SingleChildScrollView(
        child: AppStateView.error(
          icon: Icons.wifi_off_rounded,
          title: "Couldn't load inspection questions",
          message: detail.isEmpty
              ? 'Check your internet connection and try again.'
              : '$detail\nCheck your internet connection and try again.',
          actionLabel: 'Try again',
          onAction: () => provider.fetchInspectionData(),
        ),
      ),
    );
  }
}
