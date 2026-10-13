import 'package:ats_app/Presentation/screens/forgot_password/resend_otp_row.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/verify_otp_provider.dart';
import 'forgot_password_field_label.dart';
import 'forgot_password_layout.dart';
import 'forgot_password_message.dart';
import 'set_new_password_screen.dart';

/// Step 2 of the forgot password flow – verify the six digit OTP.
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VerifyOtpProvider>().reset();
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VerifyOtpProvider>();
    final radius = BorderRadius.circular(AppRadius.md);
    OutlineInputBorder outline(Color color, double width) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ForgotPasswordLayout(
      title: "Verify OTP",
      subtitle: "Enter the 6-digit code sent to ${provider.email}",
      child: Form(
        key: provider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordFieldLabel("OTP"),
            TextFormField(
              controller: provider.otpController,
              enabled: !provider.isBusy,
              autofocus: true,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: InputFormatters.pinController,
              textAlign: TextAlign.center,
              cursorColor: appColor,
              validator: provider.validateOtp,
              onChanged: (_) => provider.clearAllMessages(),
              onFieldSubmitted: (_) => provider.submit(),
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
            ResendOtpRow(
              secondsLeft: provider.resendSecondsLeft,
              onResend: provider.canResendOtp ? provider.resend : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            ForgotPasswordMessage(
              errorMessage: provider.displayErrorMessage,
              successMessage: provider.displaySuccessMessage,
            ),
            PrimaryButton(
              label: "Verify OTP",
              onPressed: provider.isBusy ? null : provider.submit,
            ),
          ],
        ),
      ),
    );
  }
}
