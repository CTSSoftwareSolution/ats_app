import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/logo_screen_item.dart';

class SplashScreenResponsiveLayout extends StatefulWidget {
  const SplashScreenResponsiveLayout({super.key});

  @override
  State<SplashScreenResponsiveLayout> createState() => _SplashScreenResponsiveLayoutState();
}

class _SplashScreenResponsiveLayoutState extends State<SplashScreenResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.contentMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.horizontalPadding),
              child: Column(
                children: [
                  const Expanded(child: Center(child: LogoScreenItem())),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: whiteColor,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: constraints.isTablet ? 96 : AppSpacing.xl * 2.5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
