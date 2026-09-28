import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Presentation/provider/vehicle_class_provider.dart';
import '../utilities/color_data.dart';
import '../utilities/image_data.dart';
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
    final classProvider = context.watch<VehicleClassProvider>();
    return CustomTextField(
      inputFormatters: InputFormatters.searchFieldValidation,
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
      maxLines: 1,
      height: 48,
      fillColor: surface,
      borderWidth: 1,
      controller: controller,
      readOnly: false,
      obscureText: false,
      textCapitalization: TextCapitalization.characters,
      suffixIcon: suffixIcon,
      // classProvider.searchValue.isEmpty
      //     ? null
      //     : IconButton(
      //         icon: Container(
      //           height: 18.0,
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.all(Radius.circular(40.0)),
      //             color: greyLightColor,
      //           ),
      //           child: CustomImage(image: closeIcon, scale: 3.5),
      //         ),
      //         onPressed: onCloseClick,
      //         color: blackColor,
      //       ),
      prefixIcon: CustomImage(image: searchIcon, scale: 4.6, color: textSecondary),
      hint: 'Search...',
      hintStyle: const TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted),
      onChanged: onChanged,
    );
  }
}
