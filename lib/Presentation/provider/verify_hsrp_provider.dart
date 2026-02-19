
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../Core/network/api_services.dart';
import '../screens/vehicle_number_plate/vehicle_number_plate_models.dart';

class VerifyHRSPProvider extends ChangeNotifier {

  bool _isLoading = false;
  VehicleNumberPlateModels? _vehicleResponse;
  String? _error;

  bool get isLoading => _isLoading;
  VehicleNumberPlateModels? get vehicleResponse => _vehicleResponse;
  String? get error => _error;

  Future<void> verifyPlate({
    required File imageFile,
    required String expectedPlate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await ApiService.multipart(
        {
          "expected_plate": expectedPlate,
          "save_debug": "True",
        },
        imageFile,
        "http://43.205.221.6/hsrp/verify-hsrp",
      );
      _vehicleResponse = VehicleNumberPlateModels.fromJson(result);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

}