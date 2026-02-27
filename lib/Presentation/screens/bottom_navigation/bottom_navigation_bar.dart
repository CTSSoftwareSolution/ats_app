import 'dart:io';
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/navigation_bar_responsive.dart';
import 'package:ats_app/location/location_provider.dart';
import 'package:ats_app/widgets/custom_dialog_box.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/generated/i18n.dart';
import 'package:provider/provider.dart';



class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<LocationProvider>().initialize(context);
    });
  }

  @override
  void dispose(){
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed){
      context.read<LocationProvider>().checkLocationAndPermission(context);
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<LocationProvider>().initialize(context);
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
