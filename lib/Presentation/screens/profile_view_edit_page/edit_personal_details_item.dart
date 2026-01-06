import 'package:ats_app/Presentation/provider/profile_details_provider.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/input_formatters.dart';
import '../../../utilities/preferences.dart';
import '../../../utilities/validators.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';

class EditPersonalDetailsItem extends StatelessWidget {
  const EditPersonalDetailsItem({super.key});

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
              SizedBox(
                width: 80,
                height: 80,
                child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                      child: CustomImage(image: Preferences.getImage(),fit: BoxFit.cover,switchToNetwork: true,defaultImage: userImage),
                    )
                ),
              ),
              CustomText(text: "Full Name", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.nameController,
                keyboardType: TextInputType.text,
                inputFormatters: InputFormatters.normalText,
                validator: (value) => Validators.textValidation(value!,context),
                hint: 'Enter your full name',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.words,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),
              18.height,
              CustomText(text: "Email Id", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.emailController,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: InputFormatters.specialRestrictions,
                validator: (value) => Validators.emailValidation(value!,context),
                hint: 'Enter your email id',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.none,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),
              18.height,
              CustomText(text: "Mobile Number", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                readOnly: true,
                controller: profileDetails.mobileController,
                keyboardType: TextInputType.phone,
                inputFormatters: InputFormatters.mobileNumber,
                validator: (value) => Validators.mobileValidation(value!,context),
                hint: 'Enter your mobile number',
                contentPadding: const EdgeInsets.only(left: 10),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: appColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ), textCapitalization: TextCapitalization.none,
                hintStyle: TextStyle(fontFamily: "Medium", fontSize: 12),
              ),
              18.height,
              CustomText(text: "Address", fontSize: 15, fontFamily: "Bold"),
              8.height,
              CustomTextField(
                minLines: 4,
                readOnly: true,
                controller: profileDetails.addressController,
                keyboardType: TextInputType.text,
                inputFormatters: InputFormatters.addressValidation,
                validator: (value) => Validators.globalValidation(value!),
                hint: 'Enter your address',
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal:10 ),
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
