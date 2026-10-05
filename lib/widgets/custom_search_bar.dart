import 'package:ats_app/utilities/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/provider/vehicle_class_provider.dart';
import '../utilities/color_data.dart';
import 'custom_text_field.dart';

class CustomSearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onApplyClick;
  final VoidCallback? onResetClick;
  final TextEditingController controller;
  final Widget? suffixIcon;
  const CustomSearchTextField({
    super.key,
    required this.onChanged,
    this.onApplyClick,
    this.onResetClick,
    this.suffixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<VehicleClassProvider>();
    return CustomTextField(
      inputFormatters: InputFormatters.searchFieldValidation,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      maxLines: 1,
      height: 48,
      fillColor: surface,
      borderWidth: 1,
      controller: controller,
      readOnly: false,
      obscureText: false,
      textCapitalization: TextCapitalization.characters,
      suffixIcon: suffixIcon,
      prefixIcon: const Icon(Icons.search_rounded, color: textMuted, size: 22),
      hint: 'Search...',
      hintStyle: const TextStyle(
        fontSize: 15,
        fontFamily: "Medium",
        color: textMuted,
      ),
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
