import 'package:ats_app/Presentation/screens/pre_inspection_form/question_card.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_text.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8,left: 10),
    child: CustomText(
      text: title,
        fontSize: 18,
        fontFamily: "Bold"
    ),
  );
}


Widget categoryHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 8,left: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: "Black",
        color: Colors.black,
      ),
    ),
  );
}

Widget buildSection(dynamic section, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sectionTitle(section.title ?? ""),
      ...section.carData!
          .map((question) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: questionCard(question, context),
      ))
          .toList(),
      const SizedBox(height: 20),
    ],
  );
}