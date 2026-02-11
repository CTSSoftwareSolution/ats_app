import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/inspection_form_provider.dart';

Widget radioButton(int questionId, String value, BuildContext context) {
  final formProvider = context.watch<InspectionFormProvider>();
  return Row(
    children: [
      Radio<String>(
        fillColor: WidgetStateProperty.all(appColor),
        activeColor: appColor,
        value: value,
        groupValue: formProvider.answers[questionId],
        onChanged: (val)  {
         formProvider.setAnswer(questionId, val!);
            },
      ),
      CustomText(text: value, fontSize: 15, fontFamily: "SemiBold",)
    ],
  );
}