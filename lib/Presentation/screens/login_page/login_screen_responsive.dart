import 'package:ats_app/Core/network/InternetCheck/network_status.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utilities/logo_screen_item.dart';
import '../../provider/login_provider.dart';
import 'login_screen_item.dart';

class LoginResponsiveLayout extends StatefulWidget {
  const LoginResponsiveLayout({super.key});

  @override
  State<LoginResponsiveLayout> createState() => _LoginResponsiveLayoutState();
}

class _LoginResponsiveLayoutState extends State<LoginResponsiveLayout> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
     final checkInternet = context.watch<NetworkStatus>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Form(
          key: loginFormKey,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.contentMaxWidth,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LogoScreenItem(),
                    LoginScreenItem(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.horizontalPadding,
                        vertical: constraints.isTablet ? 24 : 16,
                      ),
                      child: CustomButton(
                        height: constraints.isTablet ? 56.0 : 50.0,
                        width: double.infinity,
                        buttonText: "Login",
                        onPress: () {
                          if (checkInternet.isConnected) {
                            if (loginFormKey.currentState!.validate()) {
                              context.read<LoginProvider>().login(context);
                            }
                          } else {
                            CustomLoader.internetMessage(
                              msg: "No Internet Connection",
                              context: context,
                            );
                          }
                        },
                        backgroundColor: whiteColor,
                        foregroundColor: blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        fontSize: constraints.isTablet ? 22.0 : 20.0,
                        fontFamily: "Bold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
