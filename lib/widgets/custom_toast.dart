import '../utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ToastExtension on BuildContext {
  void showToast({required String msg, required Toast toastLength}) {
    Fluttertoast.showToast(
      gravity: ToastGravity.BOTTOM,
      msg: msg,
      toastLength: toastLength,
    );
  }

  void showSuccessfulToast({required String msg, required Toast toastLength}) {
    Fluttertoast.showToast(
      gravity: ToastGravity.CENTER,
      msg: msg,
      backgroundColor: pass,
      toastLength: toastLength,
    );
  }

  void showErrorToast({required String msg, required Toast toastLength}) {
    Fluttertoast.showToast(
      gravity: ToastGravity.CENTER,
      msg: msg,
      backgroundColor: fail,
      toastLength: toastLength,
    );
  }
}
