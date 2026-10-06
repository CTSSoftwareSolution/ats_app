import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/color_data.dart';
import '../utilities/input_formatters.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../widgets/custom_text_field.dart';

Widget buildServerField({
  required String title,
  required TextEditingController controller,
  final Widget? suffixIcon,
  final String? Function(String?)? validator
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm - 2),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: "SemiBold",
            fontSize: 13,
            color: textSecondary,
          ),
        ),
      ),
      CustomTextField(
        validator: validator,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r" ")),
          IpPortInputFormatter(),
        ],
        controller: controller,
        keyboardType: TextInputType.number,
        hint: "192.168.1.100:8080",
        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
          fontFamily: 'Medium',
        ),
        prefixIcon: const Icon(
          Icons.settings_ethernet_rounded,
          color: textSecondary,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        fillColor: surface,
        readOnly: false,
        textCapitalization: TextCapitalization.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      const SizedBox(height: AppSpacing.md),
    ],
  );
}
