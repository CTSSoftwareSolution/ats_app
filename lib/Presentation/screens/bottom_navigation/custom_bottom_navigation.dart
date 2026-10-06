import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widget_navigation_icon.dart';
import '../../provider/bottom_navigation_provider.dart';

/// Docked bottom navigation bar: flat white surface with a hairline top
/// border. It takes its own space so page content is never covered.
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                navigationIcon(
                  homeIcon,
                  0,
                  'Home',
                  navigationProvider.pageIndex,
                  navigationProvider.updateIndex,
                ),
                navigationIcon(
                  resultIcon,
                  1,
                  'Result',
                  navigationProvider.pageIndex,
                  navigationProvider.updateIndex,
                ),
                navigationIcon(
                  profileIcon,
                  2,
                  'Profile',
                  navigationProvider.pageIndex,
                  navigationProvider.updateIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
