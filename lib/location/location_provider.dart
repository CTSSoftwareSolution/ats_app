import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service_dialog.dart';

class LocationProvider extends ChangeNotifier {

  bool isLocationServiceDisabled = false;

  StreamSubscription<ServiceStatus>? streamSubscription;
  StreamSubscription<Position>? positionSubscription;

  String? errorMessage;
  String? get getErrorMsg => errorMessage;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _isDialogShowing = false;
  bool get isDialogShowing => _isDialogShowing;

  //BuildContext? dialogContext;

  void initialize(BuildContext context) async{
    serviceListener(context);
    await checkLocationAndPermission(context);
  }

  void serviceListener(BuildContext context){
    streamSubscription?.cancel();
    streamSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) async {
      if(status == ServiceStatus.disabled){
        isLocationServiceDisabled = true;
        errorMessage = "Location services are disabled on your device.";
        notifyListeners();
        showLocationDialog(context);
      }else if(status == ServiceStatus.enabled){
        isLocationServiceDisabled = false;
        errorMessage = null;
        notifyListeners();
       // cancelLocationDialog();
        await getCurrentLocation(context);
      }
    });
  }


  Future<void> checkLocationAndPermission(BuildContext context) async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();


    // Location services disabled
    if (!serviceEnable) {
      isLocationServiceDisabled = true;
      errorMessage = "Location services are disabled on your device.";
      notifyListeners();
      showLocationDialog(context);

      return;
    }
    isLocationServiceDisabled = false;
    errorMessage = null;
    notifyListeners();

    await getCurrentLocation(context);
  }

  Future<void> getCurrentLocation(BuildContext context) async {



     // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        errorMessage = "Location permissions are denied.";
        notifyListeners();
        showLocationDialog(context);
        return;
      }

      startLiveLocation();
  }

  void startLiveLocation(){
    positionSubscription?.cancel();
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )
    ).listen((Position position){
      _currentPosition = position;
      notifyListeners();
    });
  }


  void showLocationDialog(BuildContext context){
    if(_isDialogShowing) return;
     _isDialogShowing = true;

     showLocationServiceDialog(context).then((_){

      _isDialogShowing = false;


     });
  }

  // void cancelLocationDialog(){
  //   if(_isDialogShowing && dialogContext != null){
  //     Navigator.of(dialogContext!).pop();
  //     _isDialogShowing = false;
  //     dialogContext = null;
  //   }
  // }

  @override
  void dispose() {
    streamSubscription?.cancel();
    positionSubscription?.cancel();
    super.dispose();
  }
}