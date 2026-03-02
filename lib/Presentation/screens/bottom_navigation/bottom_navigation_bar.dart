import 'dart:io';
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/navigation_bar_responsive.dart';
import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/widgets/custom_dialog_box.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> with WidgetsBindingObserver {


  bool _openedSettings = false; // ✅ track karo ki settings gaye the ya nahi

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await locationProvider.getCurrentLocation(context);
      });
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.inactive) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await locationProvider.getCurrentLocation(context);
      });
    } else if (state == AppLifecycleState.detached) {
    } else if (state == AppLifecycleState.hidden) {
    }
  }

  Future<void> locationPermission() async {
    final locationProvider = Provider.of<LocationProvider>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await locationProvider.getCurrentLocation(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<BottomNavigationProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (navigationProvider.pageIndex == 0) {
          customShowDialog(
            context: context,
            title: "Exit",
            subTitle: "Do you really want to exit this app?",
            cancelClick: () {
              context.pop();
            },
            okClick: () {
              exit(0);
            },
          );
        } else {
          context.read<BottomNavigationProvider>().updateIndex(0);
        }
      },
      child: Scaffold(body: NavigationBarResponsiveLayout()),
    );
  }
}
