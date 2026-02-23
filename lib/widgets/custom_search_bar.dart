import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Presentation/provider/vehicle_class_provider.dart';
import '../utilities/color_data.dart';
import '../utilities/image_data.dart';
import 'custom_text_field.dart';

class CustomSearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback onCloseClick;
  final VoidCallback? onApplyClick;
  final VoidCallback? onResetClick;
  final TextEditingController controller;
  const CustomSearchTextField({
    super.key,
    required this.onChanged,
    required this.onCloseClick,
    this.onApplyClick,
    this.onResetClick,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final classProvider = context.watch<VehicleClassProvider>();
    return CustomTextField(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
      maxLines: 1,
      height: 43,
      fillColor: scaffoldBgColor,
      borderWidth: 2,
      controller: controller,
      readOnly: false,
      obscureText: false,
      textCapitalization: TextCapitalization.none,
      suffixIcon: classProvider.searchValue.isEmpty
          ? null
          : IconButton(
              icon: Container(
                height: 18.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: greyLightColor,
                ),
                child: CustomImage(image: closeIcon, scale: 3.5),
              ),
              onPressed: onCloseClick,
              color: blackColor,
            ),
      prefixIcon: CustomImage(image: searchIcon, scale: 4),
      hint: 'Search...',
      hintStyle: const TextStyle(fontSize: 15, fontFamily: "Medium"),
      onChanged: onChanged,
    );
  }
}
