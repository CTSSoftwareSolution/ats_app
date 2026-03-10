import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreenItem extends StatelessWidget {
  const LoginScreenItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0,horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Username",fontFamily: "Regular",fontSize: 16,textColor: whiteColor,),
          5.height,
          CustomTextField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            maxLines: 1,
            fillColor: textFieldColor,
            errorColor: whiteColor,
            focusedErrorBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: appColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            hint: "Enter your username",
            controller: context.watch<LoginProvider>().emailController,
            hintStyle: TextStyle(fontSize: 16, fontFamily: "Regular"),
            readOnly: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) => Validators.userNameValidation(value!, context),
            inputFormatters: InputFormatters.specialRestrictions,
          ),
        20.height,
          CustomText(text: "PASSWORD",fontFamily: "Regular",fontSize: 16,textColor: whiteColor,),
          5.height,
          CustomTextField(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            maxLines: 1,
            fillColor: textFieldColor,
            errorColor: whiteColor,
            focusedErrorBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: appColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            hint: "Enter your password",
            controller: context.watch<LoginProvider>().passwordController,
            hintStyle: TextStyle(fontSize: 16, fontFamily: "Regular"),
            readOnly: false,
            obscureText: context.watch<LoginProvider>().passwordVisible,
            textCapitalization: TextCapitalization.none,
            validator: (value) => Validators.passwordValidation(value!, context),
            inputFormatters: InputFormatters.spaceNotAllowed,
            suffixIcon: IconButton(
              color: appColor,
                onPressed: (){
                context.read<LoginProvider>().passwordVisibility();
                },
                icon: Icon(
                    context.watch<LoginProvider>().passwordVisible == true ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
          ),
        ],
      ),
    );
  }
}
