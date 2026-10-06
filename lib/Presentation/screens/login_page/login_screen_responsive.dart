import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utilities/logo_screen_item.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/login_provider.dart';
import 'login_screen_item.dart';

class LoginResponsiveLayout extends StatefulWidget {
  const LoginResponsiveLayout({super.key});

  @override
  State<LoginResponsiveLayout> createState() => _LoginResponsiveLayoutState();
}

class _LoginResponsiveLayoutState extends State<LoginResponsiveLayout> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void _submit() {
    if (loginFormKey.currentState!.validate()) {
      context.read<LoginProvider>().login(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double gutter = constraints.isTablet ? AppSpacing.xl : AppSpacing.page;
        return Form(
          key: loginFormKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: gutter, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              // Keeps the content vertically centred on tall screens while
              // still allowing it to scroll when the keyboard is open.
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - AppSpacing.xl * 2).clamp(0, double.infinity),
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
                            const Text("Sign in", style: AppText.pageTitle),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              "Enter your credentials to continue",
                              style: AppText.bodySecondary,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const LoginScreenItem(),
                            const SizedBox(height: AppSpacing.xl),
                            PrimaryButton(
                              label: "Login",
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
