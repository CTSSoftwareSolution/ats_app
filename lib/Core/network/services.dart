import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

import '../../utilities/preferences.dart';





const baseUrl = "https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev";

String get apiBaseUrl {
  final ip = Preferences.getIpAddress();
  if(ip != null && ip.isNotEmpty) return "http://$ip";
  return baseUrl;
}


Map<String, String> authHeader = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
};

final navigatorKey = GlobalKey< NavigatorState>();
final alice = Alice(
    navigatorKey: navigatorKey,
    showNotification: true,
    showInspectorOnShake: true);

String get loginUrl => "$apiBaseUrl/login";
String get vehicleTypeUrl => "$apiBaseUrl/getVehicleTypes";
String get vehicleClassUrl => "$apiBaseUrl/getVehicleClass";
String get vehiclePartsUrl => "$apiBaseUrl/getVehicleParts";
String get sliderUrl => "$apiBaseUrl/getSlider";
String get profileDetailsUrl => "$apiBaseUrl/getProfile";
String get inspectionQueUrl => "$apiBaseUrl/getPreInspectionQuestions";
String get savePreInspectionResultsUrl => "$apiBaseUrl/savePreInspectionResults";
String get getInspectionTypeUrl => "$apiBaseUrl/getInspectionType";
String get getPreInspectionDetailsUrl => "$apiBaseUrl/getPreInspectionDetailsByVehicleID";
String get checkManualInsStatusUrl => "$apiBaseUrl/checkManualInspectionStatus";
