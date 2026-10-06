import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/field_label.dart';

class LoginScreenItem extends StatelessWidget {
  /// Called when the user presses the keyboard's "done" action on the
  /// password field.
  final VoidCallback? onSubmit;

  const LoginScreenItem({super.key, this.onSubmit});

  static const EdgeInsets _fieldPadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  static const TextStyle _hintStyle =
      TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted);

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel("Username"),
          CustomTextField(
            contentPadding: _fieldPadding,
            maxLines: 1,
            fillColor: surface,
            hint: "Enter your username",
            controller: loginProvider.emailController,
            hintStyle: _hintStyle,
            readOnly: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username],
            validator: (value) => Validators.userNameValidation(value!, context),
            inputFormatters: InputFormatters.specialRestrictions,
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          const FieldLabel("Password"),
          CustomTextField(
            contentPadding: _fieldPadding,
            maxLines: 1,
            fillColor: surface,
            hint: "Enter your password",
            controller: loginProvider.passwordController,
            hintStyle: _hintStyle,
            readOnly: false,
            obscureText: loginProvider.passwordVisible,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: onSubmit == null ? null : (_) => onSubmit!(),
            validator: (value) => Validators.passwordValidation(value!, context),
            inputFormatters: InputFormatters.spaceNotAllowed,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: textSecondary),
            suffixIcon: IconButton(
              color: textSecondary,
              tooltip: loginProvider.passwordVisible == true ? "Show password" : "Hide password",
              onPressed: () {
                context.read<LoginProvider>().passwordVisibility();
              },
              icon: Icon(
                loginProvider.passwordVisible == true
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
