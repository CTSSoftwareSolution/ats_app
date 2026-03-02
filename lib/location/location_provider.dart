import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service_dialog.dart';

class LocationProvider extends ChangeNotifier with WidgetsBindingObserver{

  bool isLocationServiceDisabled = false;

  StreamSubscription<ServiceStatus>? streamSubscription;
  StreamSubscription<Position>? positionSubscription;

  String? errorMessage;
  String? get getErrorMsg => errorMessage;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _isDialogShowing = false;
  bool get isDialogShowing => _isDialogShowing;





  void initialize(BuildContext context) async{
    WidgetsBinding.instance.addObserver(this);
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

        // await Future.delayed(Duration(milliseconds: 800));
        //
        // bool stillDisable = !(await Geolocator.isLocationServiceEnabled());
        // if(stillDisable && !_isDialogShowing){
        //   showLocationDialog(context);
        // }
      }else if(status == ServiceStatus.enabled){
        isLocationServiceDisabled = false;
        errorMessage = null;
        notifyListeners();

        cancelLocationDialog(context);
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

  Future<void> checkPermissionAfterSettings(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      errorMessage = null;
      cancelLocationDialog(context);
      startLiveLocation();
    }
  }

  Future<void> getCurrentLocation(BuildContext context) async {



     // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage = "Location permissions are denied.";
        notifyListeners();
        showLocationDialog(context);
        return;
      }
    }

    // Permission denied forever
    if (permission == LocationPermission.deniedForever) {
      errorMessage = "Location permission permanently denied. Please enable it from app settings.";
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

  void cancelLocationDialog(BuildContext context){
    if (_isDialogShowing) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogShowing = false;
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    positionSubscription?.cancel();
    super.dispose();
  }
}