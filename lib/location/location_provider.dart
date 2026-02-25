import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service_dialog.dart';

class LocationProvider extends ChangeNotifier {
  String? errorMessage;
  bool isLocationServiceDisabled = false;
  StreamSubscription<ServiceStatus>? streamSubscription;

  String? get getErrorMsg => errorMessage;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  void serviceListener(BuildContext context){
    streamSubscription?.cancel();
    streamSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
      if(status == ServiceStatus.disabled){
        isLocationServiceDisabled = true;
        errorMessage = "Location services are disabled on your device.";
        notifyListeners();
        await showLocationServiceDialog(context);
      }else if(status == ServiceStatus.enabled){
        isLocationServiceDisabled = false;
        errorMessage = null;
        notifyListeners();
      }
    });
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    // Location services disabled
    if (!serviceEnable) {
      isLocationServiceDisabled = true;
      errorMessage = "Location services are disabled on your device.";
      notifyListeners();
      await showLocationServiceDialog(context);
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage = "Location permissions are denied.";
        notifyListeners();
        await showLocationServiceDialog(context);
        return;
      }
    }

    // Permission denied forever
    if (permission == LocationPermission.deniedForever) {
      errorMessage =
      "Location permission permanently denied. Please enable it from app settings.";
      notifyListeners();
      await showLocationServiceDialog(context);
      return;
    }

    // Get current location
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    notifyListeners();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}