import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/reset_password_provider.dart';
import '../../provider/send_otp_provider.dart';
import '../../provider/verify_otp_provider.dart';
import '../login_page/login_screen.dart';
import 'forgot_password_layout.dart';

/// Step 3 of the forgot password flow – choose a new password.
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const EdgeInsets _fieldPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  static const TextStyle _hintStyle =
      TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted);

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<ResetPasswordProvider>();
    if (provider.isLoading || !_formKey.currentState!.validate()) return;
    final sendOtpProvider = context.read<SendOtpProvider>();
    final verifyOtpProvider = context.read<VerifyOtpProvider>();
    final reset = await provider.resetPassword(
      email: sendOtpProvider.email,
      otp: verifyOtpProvider.verifiedOtp ?? verifyOtpProvider.otp,
    );
    if (!reset || !mounted) return;
    CustomLoader.message(provider.successMessage ?? "Password reset successfully");
    sendOtpProvider.startFlow();
    verifyOtpProvider.reset();
    provider.reset();
    context.pushAndRemoveUntil(const LoginScreen());
  }

  Widget _visibilityToggle({required bool obscured, required VoidCallback onPressed}) {
    return IconButton(
      color: textSecondary,
      tooltip: obscured ? "Show password" : "Hide password",
      onPressed: onPressed,
      icon: Icon(
        obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResetPasswordProvider>();
    return ForgotPasswordLayout(
      title: "Set new password",
      subtitle: "Use at least 8 characters with upper & lower case letters, a number and a special character",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordFieldLabel("New Password"),
            CustomTextField(
              contentPadding: _fieldPadding,
              maxLines: 1,
              fillColor: surface,
              hint: "Enter new password",
              controller: provider.newPasswordController,
              hintStyle: _hintStyle,
              readOnly: false,
              enable: !provider.isLoading,
              obscureText: provider.newPasswordObscured,
              textCapitalization: TextCapitalization.none,
              validator: (value) => Validators.newPasswordValidation(value!, context),
              inputFormatters: InputFormatters.spaceNotAllowed,
              onChanged: (_) => provider.clearMessages(),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
              suffixIcon: _visibilityToggle(
                obscured: provider.newPasswordObscured,
                onPressed: provider.toggleNewPasswordVisibility,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const ForgotPasswordFieldLabel("Confirm Password"),
            CustomTextField(
              contentPadding: _fieldPadding,
              maxLines: 1,
              fillColor: surface,
              hint: "Re-enter new password",
              controller: provider.confirmPasswordController,
              hintStyle: _hintStyle,
              readOnly: false,
              enable: !provider.isLoading,
              obscureText: provider.confirmPasswordObscured,
              textCapitalization: TextCapitalization.none,
              validator: (value) => Validators.confirmPasswordValidation(
                value!,
                context,
                provider.newPasswordController.text,
              ),
              inputFormatters: InputFormatters.spaceNotAllowed,
              onChanged: (_) => provider.clearMessages(),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
              suffixIcon: _visibilityToggle(
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
              onPressed: provider.isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
