import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_motion.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// One main-navigation destination: outlined icon when idle, filled when
/// selected.
class AppNavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

/// Main destinations, in the same order as `BottomNavigationProvider.pages`
/// (index 0 = Home, 1 = Result, 2 = Profile). Shared by the phone bottom bar
/// and the tablet navigation rail.
const List<AppNavDestination> appNavDestinations = [
  AppNavDestination(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  AppNavDestination(
    label: 'Result',
    icon: Icons.fact_check_outlined,
    selectedIcon: Icons.fact_check_rounded,
  ),
  AppNavDestination(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];

/// Navigation indicator shared by the phone bar and the tablet rail: a
/// 56 × 32dp stadium behind a 24dp icon. Selected: filled icon on a tinted
/// pill. Unselected: outlined icon, no pill.
class AppNavIndicator extends StatelessWidget {
  final IconData icon;
  final bool selected;

  /// Icon colour when selected / unselected.
  final Color selectedColor;
  final Color unselectedColor;

  /// Pill colour when selected.
  final Color pillColor;

  const AppNavIndicator({
    super.key,
    required this.icon,
    required this.selected,
    this.selectedColor = appColor,
    this.unselectedColor = textSecondary,
    this.pillColor = accentLight,
  });

  static const double width = 56;
  static const double height = 32;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.curve,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? pillColor : pillColor.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Icon(
        icon,
        size: AppIconSize.lg,
        color: selected ? selectedColor : unselectedColor,
      ),
    );
  }
}

/// Phone bottom-bar destination: [AppNavIndicator] over the label, filling
/// an equal share of the bar. Selection changes colour and the pill only –
/// the label keeps one weight so nothing shifts when switching tabs.
class AppNavBarItem extends StatelessWidget {
  final AppNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const AppNavBarItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? appColor : textSecondary;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: destination.label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          splashColor: accentLight,
          highlightColor: accentLight.withValues(alpha: 0.5),
          // The bar has a fixed height, so labels follow the system text size
          // only up to 1.2× (as Material's NavigationBar does) to avoid
          // clipping.
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxs,
                horizontal: AppSpacing.xs,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppNavIndicator(
                    icon: selected
                        ? destination.selectedIcon
                        : destination.icon,
                    selected: selected,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.navLabel.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
