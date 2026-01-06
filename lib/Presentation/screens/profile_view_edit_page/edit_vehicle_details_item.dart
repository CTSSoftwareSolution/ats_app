import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/input_formatters.dart';
import '../../../utilities/validators.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
import '../../provider/profile_details_provider.dart';

class EditVehicleDetailsItem extends StatelessWidget {
  const EditVehicleDetailsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final profileDetails = context.watch<ProfileDetailsProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Car Name", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.carNameController,
                keyboardType: TextInputType.text,
                inputFormatters: InputFormatters.specialRestrictions,
                validator: (value) => Validators.textValidation(value!,context),
                hint: 'Enter car name',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.words,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),
              18.height,
              CustomText(text: "Car Brand", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.carBrandController,
                keyboardType: TextInputType.text,
                inputFormatters: InputFormatters.specialRestrictions,
                validator: (value) => Validators.textValidation(value!,context),
                hint: 'Enter car brand',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.none,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),
              18.height,
              CustomText(text: "Car Model", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.carModelController,
                keyboardType: TextInputType.text,
                inputFormatters: InputFormatters.specialRestrictions,
                validator: (value) => Validators.mobileValidation(value!,context),
                hint: 'Enter car model',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.none,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
