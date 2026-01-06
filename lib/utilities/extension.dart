import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


extension StringExtensions on String {
  String removeExtraSpaces() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String getFormattedTime() {
    try {
      DateFormat parser = DateFormat("dd-MMM-yyyy hh:mm a");
      DateTime dateTime = parser.parse(this);
      DateFormat formatter = DateFormat("hh:mm a");
      return formatter.format(dateTime); // Returns "12:30 PM"
    } catch (e) {
      return '';
    }
  }
}


extension IntExtensions on int? {
  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) {
    return this ?? value;
  }

  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());

  /// HTTP status code
  bool isSuccessful() => this! >= 200 && this! <= 206;

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: validate());

  /// Returns if a number is between `first` and `second`
  /// ```dart
  /// 100.isBetween(50, 150) // true;
  /// 100.isBetween(100, 100) // true;
  /// ```
  bool isBetween(num first, num second) {
    if (first <= second) {
      return validate() >= first && validate() <= second;
    } else {
      return validate() >= second && validate() <= first;
    }
  }

  /// Returns Size
  Size get size => Size(this!.toDouble(), this!.toDouble());





}

mixin TimerMixin<T extends StatefulWidget> on State<T> {
  int _secondsRemaining = 0;
  Timer? _timer;

  void startTimer(Function updateState) {
    setState(() {
      _secondsRemaining = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          updateState();
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }
  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  int get secondsRemaining => _secondsRemaining;
}






