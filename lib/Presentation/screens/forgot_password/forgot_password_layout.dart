import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utilities/logo_screen_item.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../utilities/new_app_theme/app_theme.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';

/// Shared shell for the forgot password screens. Mirrors the login screen:
/// brand background, logo and a white card holding the form.
class ForgotPasswordLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const ForgotPasswordLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.statusBarStyle,
      child: Scaffold(
        backgroundColor: appColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs, top: AppSpacing.xs),
                child: AppBackButton(onPressed: () => Navigator.of(context).maybePop()),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double gutter = constraints.isTablet ? AppSpacing.xl : AppSpacing.page;
                    return SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(gutter, 0, gutter, AppSpacing.xl),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: (constraints.maxHeight - AppSpacing.xl).clamp(0, double.infinity),
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: constraints.isTablet ? 480 : double.infinity),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const LogoScreenItem(),
                                const SizedBox(height: AppSpacing.xl + AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.xl),
                                  decoration: BoxDecoration(
                                    color: surface,
                                    borderRadius: BorderRadius.circular(AppRadius.xl),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(title, style: AppText.pageTitle),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(subtitle, style: AppText.bodySecondary),
                                      const SizedBox(height: AppSpacing.xl),
                                      child,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordFieldLabel extends StatelessWidget {
  final String text;

  const ForgotPasswordFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm - 2),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "SemiBold",
          fontSize: 13,
          color: textSecondary,
        ),
      ),
    );
  }
}

/// Inline error / success banner shown above the action button.
class ForgotPasswordMessage extends StatelessWidget {
  final String? errorMessage;
  final String? successMessage;

  const ForgotPasswordMessage({super.key, this.errorMessage, this.successMessage});

  @override
  Widget build(BuildContext context) {
    final bool isError = errorMessage != null;
    final String? message = errorMessage ?? successMessage;
    if (message == null) return const SizedBox.shrink();
    final Color color = isError ? fail : pass;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md - 2),
        decoration: BoxDecoration(
          color: isError ? failLight : passLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              size: 20,
              color: color,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: "Medium", fontSize: 13, color: color, height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
