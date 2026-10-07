import 'package:ats_app/utilities/input_formatters.dart';
import 'package:flutter/material.dart';
import '../utilities/color_data.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../utilities/new_app_theme/app_text.dart';
import 'custom_text_field.dart';

class CustomSearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onApplyClick;
  final VoidCallback? onResetClick;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final String hint;
  const CustomSearchTextField({
    super.key,
    required this.onChanged,
    this.onApplyClick,
    this.onResetClick,
    this.suffixIcon,
    required this.controller,
    this.hint = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      inputFormatters: InputFormatters.searchFieldValidation,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      maxLines: 1,
      height: AppSpacing.inputHeight,
      fillColor: surface,
      borderWidth: 1,
      controller: controller,
      readOnly: false,
      obscureText: false,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.characters,
      suffixIcon: suffixIcon,
      prefixIcon: const Icon(Icons.search_rounded, color: na, size: 22),
      hint: hint,
      hintStyle: AppText.hint,
      onChanged: onChanged,
    );
  }
}

class SearchClearButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchClearButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Clear search',
      onPressed: onPressed,
      icon: const Icon(Icons.cancel_rounded, color: textMuted, size: 20),
    );
  }
}
