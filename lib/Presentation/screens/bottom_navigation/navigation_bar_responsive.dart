import 'package:ats_app/Presentation/screens/bottom_navigation/navigation_rail.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/bottom_navigation_provider.dart';
import 'custom_bottom_navigation.dart';

class NavigationBarResponsiveLayout extends StatefulWidget {
  const NavigationBarResponsiveLayout({super.key});

  @override
  State<NavigationBarResponsiveLayout> createState() =>
      _NavigationBarResponsiveLayoutState();
}

class _NavigationBarResponsiveLayoutState
    extends State<NavigationBarResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.contentMaxWidth),
          child: constraints.isTablet
              ? Row(
                  children: [
                    TabletNavigationRail(),
                    Expanded(
                      child: navigationProvider
                          .pages[navigationProvider.pageIndex],
                    ),
                  ],
                )
              : Column(
                  children: [
                    // The docked bar below owns the system bottom inset.
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child: navigationProvider
                            .pages[navigationProvider.pageIndex],
                      ),
                    ),
                    const CustomBottomNavigation(),
                  ],
                ),
        );
      },
    );
  }
}
