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

  static const _labelStyleSize = 14.0;
  static const _fieldPadding = EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0);
  static const _hintStyle = TextStyle(fontSize: 15, fontFamily: "Medium", color: textMuted);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Sign in",
            fontFamily: "Bold",
            fontSize: 22,
            textColor: whiteColor,
          ),
          4.height,
          const CustomText(
            text: "Use your inspector credentials to continue",
            fontFamily: "Medium",
            fontSize: 14,
            textColor: textWhiteSub,
          ),
          28.height,
          const CustomText(text: "Username", fontFamily: "SemiBold", fontSize: _labelStyleSize, textColor: whiteColor),
          8.height,
          CustomTextField(
            contentPadding: _fieldPadding,
            maxLines: 1,
            fillColor: whiteColor,
            errorColor: whiteColor,
            hint: "Enter your username",
            controller: context.watch<LoginProvider>().emailController,
            hintStyle: _hintStyle,
            readOnly: false,
            textCapitalization: TextCapitalization.none,
            prefixIcon: const Icon(Icons.person_outline_rounded, color: textSecondary),
            validator: (value) => Validators.userNameValidation(value!, context),
            inputFormatters: InputFormatters.specialRestrictions,
          ),
          20.height,
          const CustomText(text: "Password", fontFamily: "SemiBold", fontSize: _labelStyleSize, textColor: whiteColor),
          8.height,
          CustomTextField(
            contentPadding: _fieldPadding,
            maxLines: 1,
            fillColor: whiteColor,
            errorColor: whiteColor,
            hint: "Enter your password",
            controller: context.watch<LoginProvider>().passwordController,
            hintStyle: _hintStyle,
            readOnly: false,
            obscureText: context.watch<LoginProvider>().passwordVisible,
            textCapitalization: TextCapitalization.none,
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: textSecondary),
            validator: (value) => Validators.passwordValidation(value!, context),
            inputFormatters: InputFormatters.spaceNotAllowed,
            suffixIcon: IconButton(
              color: appColor,
              tooltip: context.watch<LoginProvider>().passwordVisible == true ? "Show password" : "Hide password",
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
