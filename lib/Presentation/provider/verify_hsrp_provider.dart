
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../Core/network/api_services.dart';
import '../screens/vehicle_number_plate/vehicle_number_plate_models.dart';





class VerifyHRSPProvider extends ChangeNotifier {

  bool _isLoading = false;

   VehicleNumberPlateModels? _vehicleResponse;

   List<VehicleNumberPlateModels> response = [];

  String? _error;

  bool get isLoading => _isLoading;
   VehicleNumberPlateModels? get vehicleResponse => _vehicleResponse;
   String? get error => _error;

   List<VehicleNumberPlateModels>? get totalResponse => response;



  Future<void> verifyPlate({
    required File imageFile,
    required String expectedPlate,
    required BuildContext context
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

      totalResponse?.add(_vehicleResponse!);

    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _vehicleResponse = null;
    response.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

}