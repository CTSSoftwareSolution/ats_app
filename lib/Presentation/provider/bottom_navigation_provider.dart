import 'package:flutter/cupertino.dart';
import '../screens/ai_inspection_list/ai_inspection_list_screen.dart';
import '../screens/home_pages/home_screen.dart';
import '../screens/profile_page/profile_screen.dart';
import '../screens/result_page/result_screen.dart';

class BottomNavigationProvider extends ChangeNotifier{

  int pageIndex = 0;
  bool isSelected = false;
  bool isTablet = false;
  bool get isTabletMode => isTablet;

  void setTabletMode(bool value) {
    isTablet = value;
    notifyListeners();
  }

  final pages = [
    HomeScreen(),
    AiInspectionListScreen(),
  //  ResultScreen(),
  //  VehicleNumberPlateScreen(),
    ProfileScreen(),
  ];

  void updateIndex(int newIndex) {
    pageIndex = newIndex;
    notifyListeners();
  }

}