import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utilities/color_data.dart';



class CustomLoader {
  static showToast(String? message,
      {EasyLoadingToastPosition position = EasyLoadingToastPosition.center}) {
    EasyLoading.showToast(message!, toastPosition: position);
  }

  static showLoader(String message) {
    EasyLoading.show(
        status: message,
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
  }

  static closeLoader() {
    EasyLoading.dismiss();
  }

  static message(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: appColor,
        textColor: whiteColor,
        fontSize: 16.0);
    Future.delayed(Duration(milliseconds: 750), () {
      Fluttertoast.cancel();
    });
  }

  static internetMessage({required String msg, required BuildContext context}) {
    context.showCustomSnackBar(message: "No Internet", backgroundColor: redColor);
  }

  static Widget loader() {
    return const Center(
      child: CircularProgressIndicator(color: appColor),
    );
  }
}
