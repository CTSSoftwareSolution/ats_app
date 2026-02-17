import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

import '../../utilities/preferences.dart';



Map<String, String> authHeader = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
};

final navigatorKey = GlobalKey< NavigatorState>();
final alice = Alice(
    navigatorKey: navigatorKey,
    showNotification: true,
    showInspectorOnShake: true);

String get baseUrl {
  final savedIp = Preferences.getIPAddress();
  if (savedIp.isNotEmpty) {
    return savedIp;
  }
  return "https://";
}




String get loginUrl => "$baseUrl/login";
 String get vehicleTypeUrl => "$baseUrl/getVehicleTypes";
 String get vehicleClassUrl => "$baseUrl/getVehicleClass";
 String get vehiclePartsUrl => "$baseUrl/getVehicleParts";
 String get sliderUrl => "$baseUrl/getSlider";
 String get profileDetailsUrl => "$baseUrl/getProfile";
 String get inspectionQueUrl => "$baseUrl/getPreInspectionQuestions";
 String get savePreInspectionResultsUrl => "$baseUrl/savePreInspectionResults";
 String get getInspectionTypeUrl => "$baseUrl/getInspectionType";
 String get getPreInspectionDetailsUrl => "$baseUrl/getPreInspectionDetailsByVehicleID";
 String get checkManualInsStatusUrl => "$baseUrl/checkManualInspectionStatus";
