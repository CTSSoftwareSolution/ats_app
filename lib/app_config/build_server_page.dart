import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/color_data.dart';
import '../utilities/input_formatters.dart';
import '../utilities/validators.dart';
import '../widgets/custom_text.dart';
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
      Row(
        children: [
          Icon(
            Icons.storage_rounded,
            size: 16,
            color: appColor,
            //color: Colors.blue[700],
          ),
          const SizedBox(width: 6),
          CustomText(text: title, fontSize: 13,
            textColor: Colors.grey[800],
            fontFamily: "Bold",)
        ],
      ),
      const SizedBox(height: 10),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: appColor.withOpacity(0.06),
              //color: Colors.blue.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: CustomTextField(
          validator: validator,
             // (value) => Validators.validateIpAddress(value!),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r" ")),
            IpPortInputFormatter(),
          ],
          controller:controller,
          keyboardType: TextInputType.number,
          hint: "192.168.1.100:8080",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'Medium',
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appColor.withOpacity(0.75),
                  appColor.withOpacity(0.95),
                  // Colors.blue[400]!,
                  // Colors.blue[600]!,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.settings_ethernet_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          suffixIcon: suffixIcon,
          fillColor: Colors.white,
          readOnly: false,
          textCapitalization: TextCapitalization.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),

      const SizedBox(height: 12),
    ],
  );
}
