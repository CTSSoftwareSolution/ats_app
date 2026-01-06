
import 'dart:io';

import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_dialog_box.dart';
import 'custom_bottom_navigation.dart';



class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {

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
      child: Scaffold(
       body:  Stack(
         children: [
           Positioned.fill(
             child: navigationProvider
                 .pages[navigationProvider.pageIndex],
           ),
           Positioned(
             left: 15,right: 15,bottom: 20,
             child: SafeArea(
               child: CustomBottomNavigation(
                 currentIndex: navigationProvider.pageIndex,
                 onTabSelected: (index) {
                   setState(() {
                     navigationProvider.pageIndex = index;
                   });
                 },
               ),
             ),
           ),
         ],
       )
      ),
    );

  }
}
