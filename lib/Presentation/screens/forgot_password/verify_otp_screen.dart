import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/reset_password_provider.dart';
import '../../provider/send_otp_provider.dart';
import '../../provider/verify_otp_provider.dart';
import 'forgot_password_layout.dart';
import 'set_new_password_screen.dart';

/// Step 2 of the forgot password flow – verify the six digit OTP.
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<VerifyOtpProvider>();
    final sendOtpProvider = context.read<SendOtpProvider>();
    if (provider.isLoading || sendOtpProvider.isLoading || !_formKey.currentState!.validate()) return;
    sendOtpProvider.clearMessages();
    final verified = await provider.verifyOtp(sendOtpProvider.email);
    if (!verified || !mounted) return;
    context.read<ResetPasswordProvider>().reset();
    await context.push(const SetNewPasswordScreen());
    provider.clearMessages();
  }

  Future<void> _resend() async {
    final provider = context.read<VerifyOtpProvider>();
    if (provider.isLoading) return;
    provider.reset();
    await context.read<SendOtpProvider>().resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VerifyOtpProvider>();
    final sendOtpProvider = context.watch<SendOtpProvider>();
    final bool busy = provider.isLoading || sendOtpProvider.isLoading;
    final radius = BorderRadius.circular(AppRadius.md);
    OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ForgotPasswordLayout(
      title: "Verify OTP",
      subtitle: "Enter the 6-digit code sent to ${sendOtpProvider.email}",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordFieldLabel("OTP"),
            TextFormField(
              controller: provider.otpController,
              enabled: !busy,
              autofocus: true,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: InputFormatters.pinController,
              textAlign: TextAlign.center,
              cursorColor: appColor,
              validator: (value) => Validators.sixDigitOtpValidation(value ?? ""),
              onChanged: (_) {
                provider.clearMessages();
                sendOtpProvider.clearMessages();
              },
              onFieldSubmitted: (_) => _submit(),
              style: const TextStyle(
                color: textPrimary,
                fontSize: 22,
                fontFamily: "Bold",
                letterSpacing: 12,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                filled: true,
                fillColor: surface,
                hintText: "••••••",
                hintStyle: const TextStyle(fontSize: 22, color: textMuted, letterSpacing: 12),
                enabledBorder: outline(border, 1),
                disabledBorder: outline(border, 1),
                border: outline(border, 1),
                focusedBorder: outline(appColor, 1.5),
                errorBorder: outline(fail, 1),
                focusedErrorBorder: outline(fail, 1.5),
                errorStyle: const TextStyle(color: fail, fontSize: 12),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _ResendOtpRow(
              secondsLeft: sendOtpProvider.resendSecondsLeft,
              onResend: sendOtpProvider.canResendOtp && !provider.isLoading ? _resend : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            ForgotPasswordMessage(
              errorMessage: provider.errorMessage ?? sendOtpProvider.errorMessage,
              successMessage: provider.successMessage ?? sendOtpProvider.successMessage,
            ),
            PrimaryButton(
              label: "Verify OTP",
              onPressed: busy ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResendOtpRow extends StatelessWidget {
  final int secondsLeft;
  final VoidCallback? onResend;

  const _ResendOtpRow({required this.secondsLeft, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Didn't receive the code?",
          style: TextStyle(fontFamily: "Medium", fontSize: 13, color: textSecondary),
        ),
        TextButton(
          onPressed: onResend,
          style: TextButton.styleFrom(
            foregroundColor: appColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: const Size(0, 36),
          ),
          child: Text(
            secondsLeft > 0 ? "Resend in 00:${secondsLeft.toString().padLeft(2, '0')}" : "Resend OTP",
            style: const TextStyle(fontFamily: "SemiBold", fontSize: 13),
          ),
        ),
      ],
    );
  }
}
