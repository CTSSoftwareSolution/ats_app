import 'package:ats_app/Presentation/screens/profile_page/password_field.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/change_password_provider.dart';
import '../forgot_password/forgot_password_field_label.dart';
import '../forgot_password/forgot_password_message.dart';

/// Profile > Change Password.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChangePasswordProvider>().reset();
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangePasswordProvider>();
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: AppBackButton(onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xl,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: border),
              ),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Use at least 8 characters with upper & lower case letters, a number and a special character",
                      style: AppText.bodySecondary,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const ForgotPasswordFieldLabel("Current Password"),
                    PasswordField(
                      hint: "Enter current password",
                      controller: provider.currentPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.currentPasswordObscured,
                      onToggle: provider.toggleCurrentPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: provider.validateCurrentPassword,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ForgotPasswordFieldLabel("New Password"),
                    PasswordField(
                      hint: "Enter new password",
                      controller: provider.newPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.newPasswordObscured,
                      onToggle: provider.toggleNewPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: provider.validateNewPassword,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ForgotPasswordFieldLabel("Confirm New Password"),
                    PasswordField(
                      hint: "Re-enter new password",
                      controller: provider.confirmPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.confirmPasswordObscured,
                      onToggle: provider.toggleConfirmPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: provider.validateConfirmPassword,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ForgotPasswordMessage(
                      errorMessage: provider.errorMessage,
                      successMessage: provider.successMessage,
                    ),
                    PrimaryButton(
                      label: "Change Password",
                      onPressed: provider.isLoading ? null : provider.submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


