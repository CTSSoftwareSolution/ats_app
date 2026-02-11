import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_text.dart';
import '../../provider/inspection_form_provider.dart';

Widget questionCard(CarData carData, BuildContext context) {


  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: carData.questionText.toString(),
              fontSize: 16,
              fontFamily: "Medium"
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              radioButton(int.parse(carData.questionId.toString()), "Yes", context,),
              const SizedBox(width: 20),
              radioButton(int.parse(carData.questionId.toString()), "No", context),
            ],
          ),


        ],
      ),
    ),
  );
}