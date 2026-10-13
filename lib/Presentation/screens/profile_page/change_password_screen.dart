import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../provider/change_password_provider.dart';
import '../forgot_password/forgot_password_layout.dart';

/// Profile > Change Password.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ChangePasswordProvider>().reset();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<ChangePasswordProvider>();
    if (provider.isLoading || !_formKey.currentState!.validate()) return;
    final changed = await provider.changePassword();
    if (!changed || !mounted) return;
    CustomLoader.message(provider.successMessage ?? "Password changed successfully");
    Navigator.of(context).pop();
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Use at least 8 characters with upper & lower case letters, a number and a special character",
                      style: AppText.bodySecondary,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const ForgotPasswordFieldLabel("Current Password"),
                    _PasswordField(
                      hint: "Enter current password",
                      controller: provider.currentPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.currentPasswordObscured,
                      onToggle: provider.toggleCurrentPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: (value) => Validators.currentPasswordValidation(value ?? ""),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ForgotPasswordFieldLabel("New Password"),
                    _PasswordField(
                      hint: "Enter new password",
                      controller: provider.newPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.newPasswordObscured,
                      onToggle: provider.toggleNewPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: (value) => Validators.changedPasswordValidation(
                        value ?? "",
                        context,
                        provider.currentPasswordController.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const ForgotPasswordFieldLabel("Confirm New Password"),
                    _PasswordField(
                      hint: "Re-enter new password",
                      controller: provider.confirmPasswordController,
                      enabled: !provider.isLoading,
                      obscured: provider.confirmPasswordObscured,
                      onToggle: provider.toggleConfirmPasswordVisibility,
                      onChanged: provider.clearMessages,
                      validator: (value) => Validators.confirmPasswordValidation(
                        value ?? "",
                        context,
                        provider.newPasswordController.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ForgotPasswordMessage(
                      errorMessage: provider.errorMessage,
                      successMessage: provider.successMessage,
                    ),
                    PrimaryButton(
                      label: "Change Password",
                      onPressed: provider.isLoading ? null : _submit,
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

class _PasswordField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final bool obscured;
  final VoidCallback onToggle;
  final VoidCallback onChanged;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.hint,
    required this.controller,
    required this.enabled,
    required this.obscured,
    required this.onToggle,
    required this.onChanged,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      maxLines: 1,
      fillColor: surface,
      hint: hint,
      controller: controller,
      hintStyle: const TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted),
      readOnly: false,
      enable: enabled,
      obscureText: obscured,
      textCapitalization: TextCapitalization.none,
      validator: validator,
      inputFormatters: InputFormatters.spaceNotAllowed,
      onChanged: (_) => onChanged(),
      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
      suffixIcon: IconButton(
        color: textSecondary,
        tooltip: obscured ? "Show password" : "Hide password",
        onPressed: onToggle,
        icon: Icon(
          obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          size: 20,
        ),
      ),
    );
  }
}
