import 'package:ats_app/Presentation/screens/login_page/terms_conditions_screen.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/logo_screen_item.dart';
import '../../provider/login_provider.dart';
import 'login_screen_item.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff345afa), Color(0xff19162e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: TermsConditionsScreen(),
        body: SafeArea(
          child: Form(
            key: loginFormKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LogoScreenItem(),
                    LoginScreenItem(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: CustomButton(
                        height: 50.0,
                        width: double.infinity,
                        buttonText: "Login",
                        onPress: () {
                          if(loginFormKey.currentState!.validate()){
                           context.read<LoginProvider>().login(context);
                          }
                        },
                        backgroundColor: whiteColor,
                        foregroundColor: blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        fontSize: 20.0,
                        fontFamily: "Bold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
