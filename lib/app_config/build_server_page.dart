import 'package:flutter/material.dart';
import 'package:ats_app/utilities/new_app_theme/app_text.dart';
import 'package:flutter/services.dart';
import '../utilities/color_data.dart';
import '../utilities/input_formatters.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/new_app_ui/field_label.dart';

Widget buildServerField({
  required String title,
  required TextEditingController controller,
  final Widget? suffixIcon,
  final String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(title),
      CustomTextField(
        validator: validator,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r" ")),
          IpPortInputFormatter(),
        ],
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        hint: "192.168.1.100:8080",
        hintStyle: AppText.hint,
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
