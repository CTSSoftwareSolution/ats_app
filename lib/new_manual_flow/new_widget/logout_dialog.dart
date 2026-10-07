import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Presentation/screens/login_page/login_screen.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_layout.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../../widgets/new_app_ui/primary_button.dart';
import '../../widgets/new_app_ui/secondary_button.dart';
import '../auth_provider.dart';

/// Shows logout confirmation dialog, handles logout + navigation
Future<void> confirmLogout(BuildContext context) async {
  final auth = context.read<AuthProvider>();
  final user = auth.currentUser;

  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    // Same layout as AppDialog, with the signed-in user's name under the
    // title.
    builder: (_) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxDialogWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.dialog,
            AppSpacing.dialog,
            AppSpacing.dialog,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: failLight,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: fail,
                      size: AppIconSize.md + 2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sign Out?', style: AppText.dialogTitle),
                        if (user != null)
                          Text(
                            user.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySecondary,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'You will be returned to the login screen.',
                style: AppText.body.copyWith(color: textSecondary, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Sign Out',
                      color: fail,
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  if (confirmed == true && context.mounted) {
    await auth.logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
}
