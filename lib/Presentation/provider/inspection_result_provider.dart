import 'package:flutter/cupertino.dart';

class InspectionResultProvider extends ChangeNotifier{

  final controller = TextEditingController();
  bool isChecked = false;


  void toggleCheckbox(bool value) {
    isChecked = value;
    notifyListeners();
  }
}