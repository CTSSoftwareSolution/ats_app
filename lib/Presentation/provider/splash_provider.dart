import 'dart:async';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import '../../utilities/preferences.dart';
import '../screens/bottom_navigation/bottom_navigation_bar.dart';
import '../screens/login_page/login_screen.dart';

class SplashProvider extends ChangeNotifier{

  final loginFormKey= GlobalKey<FormState>();

  void startTimer(BuildContext context){
    Timer(Duration(seconds: 2), (){
      checkLoginStatus(context); });
  }

  void checkLoginStatus(BuildContext context)async{
    await Preferences.setPreferences();
    String userId = Preferences.getUserId();
    if(userId.isEmpty){
      context.push(LoginScreen());
    }else{
     context.push(const BottomNavigationBarScreen());
    }
  }

}