
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';



class NetworkStatus with ChangeNotifier {

  bool _isConnected = false;
  StreamSubscription? _subscription;

  bool get isConnected => _isConnected;

  NetworkStatus() {
    _init();
  }

  Future<void> _init() async {
    await _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = !connectivityResult.contains(ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}