import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/send_otp_provider.dart';
import 'forgot_password_field_label.dart';
import 'forgot_password_layout.dart';
import 'forgot_password_message.dart';
import 'verify_otp_screen.dart';

/// Step 1 of the forgot password flow – collect the email and send an OTP.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SendOtpProvider>().startFlow();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SendOtpProvider>();
    return ForgotPasswordLayout(
      title: "Forgot password",
      subtitle: "Enter your registered email and we'll send you a one-time password",
      child: Form(
        key: provider.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ForgotPasswordFieldLabel("Email"),
            CustomTextField(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              maxLines: 1,
              fillColor: surface,
              hint: "Enter your email",
              controller: provider.emailController,
              hintStyle: const TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted),
              readOnly: false,
              enable: !provider.isLoading,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: provider.validateEmail,
              inputFormatters: InputFormatters.specialRestrictions,
              onChanged: (_) => provider.clearMessages(),
              prefixIcon: const Icon(Icons.email_outlined, size: 20, color: textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            ForgotPasswordMessage(
              errorMessage: provider.errorMessage,
              successMessage: provider.successMessage,
            ),
            PrimaryButton(
              label: "Send OTP",
              onPressed: provider.isLoading ? null : provider.submit,
            ),
          ],
        ),
      ),
    );
  }
}
