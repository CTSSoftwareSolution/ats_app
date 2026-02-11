import 'package:flutter/material.dart';

import '../../../widgets/custom_text.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: CustomText(
      text: title,
        fontSize: 18,
        fontFamily: "Bold"
    ),
  );
}