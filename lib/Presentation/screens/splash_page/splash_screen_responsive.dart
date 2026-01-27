import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:flutter/material.dart';

import '../../../utilities/custom_progress_indicator.dart';
import '../../../utilities/extension.dart';
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
        builder: (context, constraints){
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.contentMaxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: constraints.horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: LogoScreenItem()),
                    CustomProgressIndicator(),
                    constraints.isTablet ? 140.height : 100.height,
                  ],
                ),
              ),
            ),
          );
    });


  }
}
