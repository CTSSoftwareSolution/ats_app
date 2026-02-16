import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';




const baseUrl = "https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev";

Map<String, String> authHeader = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
};

final navigatorKey = GlobalKey< NavigatorState>();
final alice = Alice(
    navigatorKey: navigatorKey,
    showNotification: true,
    showInspectorOnShake: true);

const loginUrl = "$baseUrl/login";
const vehicleTypeUrl = "$baseUrl/getVehicleTypes";
const vehicleClassUrl = "$baseUrl/getVehicleClass";
const vehiclePartsUrl = "$baseUrl/getVehicleParts";
const sliderUrl = "$baseUrl/getSlider";
const profileDetailsUrl = "$baseUrl/getProfile";
const inspectionQueUrl = "$baseUrl/getPreInspectionQuestions";
const savePreInspectionResultsUrl = "$baseUrl/savePreInspectionResults";
const getInspectionTypeUrl = "$baseUrl/getInspectionType";
const getPreInspectionDetailsUrl = "$baseUrl/getPreInspectionDetailsByVehicleID";
const checkManualInsStatusUrl = "$baseUrl/checkManualInspectionStatus";
