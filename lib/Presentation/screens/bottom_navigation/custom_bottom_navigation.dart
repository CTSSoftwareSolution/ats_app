import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/app_navigation.dart';
import '../../provider/bottom_navigation_provider.dart';

/// Docked bottom navigation bar: flat white surface with a hairline top
/// border. It takes its own space so page content is never covered.
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    // A Material (rather than a DecoratedBox) is the ink surface, so the
    // destinations' tap ripples are painted on top of the bar's colour.
    return Material(
      color: surface,
      shape: const Border(top: BorderSide(color: border)),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                for (var i = 0; i < appNavDestinations.length; i++)
                  AppNavBarItem(
                    destination: appNavDestinations[i],
                    selected: navigationProvider.pageIndex == i,
                    onTap: () => navigationProvider.updateIndex(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
