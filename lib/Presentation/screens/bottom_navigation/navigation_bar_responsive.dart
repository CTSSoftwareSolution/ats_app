import 'package:ats_app/Presentation/screens/bottom_navigation/navigation_rail.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/tablet_bottom_navigation.dart';
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
                    TabletNavigationRail(
                      currentIndex: navigationProvider.pageIndex,
                      onTabSelected: navigationProvider.updateIndex,
                    ),
                    Expanded(
                      child: navigationProvider
                          .pages[navigationProvider.pageIndex],
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: navigationProvider
                          .pages[navigationProvider.pageIndex],
                    ),
                    Positioned(
                      left: 15,
                      right: 15,
                      bottom: 20,
                      child: SafeArea(
                        child: CustomBottomNavigation(
                          currentIndex: navigationProvider.pageIndex,
                          onTabSelected: (index) {
                            navigationProvider.updateIndex(index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
