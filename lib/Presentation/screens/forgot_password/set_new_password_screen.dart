import 'package:ats_app/Presentation/screens/forgot_password/visibility_toggle_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/reset_password_provider.dart';
import '../login_page/login_screen.dart';
import 'forgot_password_field_label.dart';
import 'forgot_password_layout.dart';
import 'forgot_password_message.dart';

/// Step 3 of the forgot password flow – choose a new password.
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ResetPasswordProvider>().reset();
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResetPasswordProvider>();
    return ForgotPasswordLayout(
      title: "Set new password",
      subtitle: "Use at least 8 characters with upper & lower case letters, a number and a special character",
      child: Form(
        key: provider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordFieldLabel("New Password"),
            CustomTextField(
              contentPadding: ResetPasswordProvider.fieldPadding,
              maxLines: 1,
              fillColor: surface,
              hint: "Enter new password",
              controller: provider.newPasswordController,
              hintStyle: ResetPasswordProvider.hintStyle,
              readOnly: false,
              enable: !provider.isLoading,
              obscureText: provider.newPasswordObscured,
              textCapitalization: TextCapitalization.none,
              validator: provider.validateNewPassword,
              inputFormatters: InputFormatters.spaceNotAllowed,
              onChanged: (_) => provider.clearMessages(),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
              suffixIcon: visibilityToggle(
                obscured: provider.newPasswordObscured,
                onPressed: provider.toggleNewPasswordVisibility,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const ForgotPasswordFieldLabel("Confirm Password"),
            CustomTextField(
              contentPadding: ResetPasswordProvider.fieldPadding,
              maxLines: 1,
              fillColor: surface,
              hint: "Re-enter new password",
              controller: provider.confirmPasswordController,
              hintStyle: ResetPasswordProvider.hintStyle,
              readOnly: false,
              enable: !provider.isLoading,
              obscureText: provider.confirmPasswordObscured,
              textCapitalization: TextCapitalization.none,
              validator: provider.validateConfirmPassword,
              inputFormatters: InputFormatters.spaceNotAllowed,
              onChanged: (_) => provider.clearMessages(),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
              suffixIcon: visibilityToggle(
                obscured: provider.confirmPasswordObscured,
                onPressed: provider.toggleConfirmPasswordVisibility,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ForgotPasswordMessage(
              errorMessage: provider.errorMessage,
              successMessage: provider.successMessage,
            ),
            PrimaryButton(
              label: "Reset Password",
              onPressed: provider.isLoading ? null : provider.submit,
            ),
          ],
        ),
      ),
    );
  }
}
