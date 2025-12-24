import 'package:flutter/cupertino.dart';

import '../screens/home_pages/home_screen.dart';
import '../screens/profile_page/profile_screen.dart';
import '../screens/result_page/result_screen.dart';
import '../screens/vehicle_type_page/type_screen.dart';

class BottomNavigationProvider extends ChangeNotifier{

  int pageIndex = 0;
  bool isSelected = false;

  final pages = [
    HomeScreen(),
    ResultScreen(),
    TypeScreen(),
    ProfileScreen(),
  ];

  void updateIndex(int newIndex) {
    pageIndex = newIndex;
    notifyListeners();
  }

}