import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import '../utilities/app_theme.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../utilities/new_app_theme/app_text.dart';
import '../widgets/app_ui.dart';
import '../widgets/new_app_ui/primary_button.dart';

class LocationProvider extends ChangeNotifier {

  Position? _currentPosition;
  String? _currentAddress;
  String? _placeName;
  bool _isLoading = false;
  bool _isCurrentLocationLoading = false;
  String? _errorMessage;
  bool _isLocationServiceDisabled = false;
  bool _isPermissionDenied = false;
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  String? get placeName => _placeName;
  bool get isLoading => _isLoading;
  bool get isCurrentLocationLoading => _isCurrentLocationLoading;
  String? get errorMessage => _errorMessage;
  bool get isLocationServiceDisabled => _isLocationServiceDisabled;
  bool get isPermissionDenied => _isPermissionDenied;
  StreamSubscription<ServiceStatus>? streamSubscription;
  bool _isLocationDialogOpen = false;

  String getLatitudeDirection(double latitude) {
    return latitude >= 0 ? "North" : "South";
  }

  String getLongitudeDirection(double longitude) {
    return longitude >= 0 ? "East" : "West";
  }

  // LocationProvider(BuildContext context) {
  //   _initializeLocation(context);
  //
  // }

  Future<void> initializeLocation(BuildContext context) async {
    //await _getLastKnownPosition(context);
     await getCurrentLocation(context);
     _listenToLocationService(context);
  }

  void _listenToLocationService(BuildContext context){
    streamSubscription?.cancel();
    streamSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) async{
      if(status == ServiceStatus.enabled){
        _isLocationServiceDisabled = false;
        _errorMessage = null;

        if (_isLocationDialogOpen && Navigator.canPop(context)) {
          Navigator.pop(context);
        }


        await getCurrentLocation(context);

      }else if(status == ServiceStatus.disabled){
        _isLocationServiceDisabled = true;
        _errorMessage = "Location services are disabled on your device.";
        notifyListeners();
      }

    });
  }



  Future<void> _getLastKnownPosition(BuildContext context) async {
    try {
      if (_currentPosition != null) return;
      final hasPermission = await _checkLocationPermission(context);
      if (!hasPermission) return;
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        _currentPosition = lastPosition;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getting last known position: $e');
    }
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    if (_isCurrentLocationLoading) return;
    _isCurrentLocationLoading = true;
    notifyListeners();
    try {
      // Check location services
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _isLocationServiceDisabled = true;
        _errorMessage = 'Location services are disabled.';
        notifyListeners(); // Notify before showing dialog
        final shouldContinue = await _showLocationServiceDialog(context);
        if (!shouldContinue) {
          _isCurrentLocationLoading = false;
          notifyListeners();
          return;
        }
        // After dialog, check services again
        final serviceEnabledAgain = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabledAgain) {
          _isLocationServiceDisabled = true;
          _errorMessage = 'Location services are still disabled.';
          _isCurrentLocationLoading = false;
          notifyListeners();
          return;
        }
        _isLocationServiceDisabled = false; // Services were enabled
      } else {
        _isLocationServiceDisabled = false; // Ensure flag is reset if services are enabled
      }

      // Check permissions
      final hasPermission = await _checkLocationPermission(context);
      if (!hasPermission) {
        _isCurrentLocationLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      _errorMessage = null; // Clear any previous errors
    } catch (e) {
      _errorMessage = 'Failed to get location: $e';
      debugPrint('Location error: $e');
    } finally {
      _isCurrentLocationLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _checkLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isPermissionDenied = true;
        _errorMessage = 'Location permission denied';
        notifyListeners();

        final shouldRequestAgain = await _showPermissionDialog(context);
        if (shouldRequestAgain == true) {
          return _checkLocationPermission(context);
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isPermissionDenied = true;
      _errorMessage = 'Location permissions are permanently denied';
      notifyListeners();

      final openSettings = await showDialog<bool>(
        context: context,
        builder: (context) => _LocationPromptDialog(
          title: 'Permission Required',
          message: 'Enable location permissions in app settings',
          actionLabel: "Open Settings",
          onAction: () async {
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 200));
            await Geolocator.openAppSettings();
          },
        ),
      );
      // if (openSettings == true) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) async {
      //     await Geolocator.openAppSettings();
      //   });
      // }
      return false;
    }
    _isPermissionDenied = false;
    return true;
  }


  Future<bool> _showLocationServiceDialog(BuildContext context) async {
    _isLocationDialogOpen = true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LocationPromptDialog(
        title: 'Activate Location',
        message: 'Enable location services in your phone settings',
        actionLabel: "Enable",
        onAction: () async {
          Navigator.pop(context);
          await Geolocator.openLocationSettings();
        },
      ),
    );
    _isLocationDialogOpen = false;
    return result ?? false;
  }

  Future<bool?> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: const Text('This app needs location permission to work properly'),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context, false),
          //   child: const Text('Deny'),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }


}

/// Location prompt: animation, title, message and one primary action.
class _LocationPromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _LocationPromptDialog({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/Location.json',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, textAlign: TextAlign.center, style: AppText.pageTitle),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center, style: AppText.bodySecondary),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }
}
