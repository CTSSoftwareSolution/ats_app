
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_bottom_navigation.dart';



class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<BottomNavigationProvider>(context);
    return Scaffold(
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
    );

  }
}
