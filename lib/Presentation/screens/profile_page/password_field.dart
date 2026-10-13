import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/input_formatters.dart';
import '../../../widgets/custom_text_field.dart';

class PasswordField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final bool obscured;
  final VoidCallback onToggle;
  final VoidCallback onChanged;
  final String? Function(String?) validator;

  const PasswordField({super.key,
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