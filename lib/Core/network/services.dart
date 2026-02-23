import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import '../../app_config/app_config.dart';

String get baseUrl => appConfig.baseUrl;

Map<String, String> authHeader = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
};

final navigatorKey = GlobalKey<NavigatorState>();
final alice = Alice(
    navigatorKey: navigatorKey,
    showNotification: true,
    showInspectorOnShake: true);

String get loginUrl                    => "$baseUrl/login";
String get vehicleTypeUrl              => "$baseUrl/getVehicleTypes";
String get vehicleClassUrl             => "$baseUrl/getVehicleClass";
String get vehiclePartsUrl             => "$baseUrl/getVehicleParts";
String get sliderUrl                   => "$baseUrl/getSlider";
String get profileDetailsUrl           => "$baseUrl/getProfile";
String get inspectionQueUrl            => "$baseUrl/getPreInspectionQuestions";
String get savePreInspectionResultsUrl => "$baseUrl/savePreInspectionResults";
String get getInspectionTypeUrl        => "$baseUrl/getInspectionType";
String get getPreInspectionDetailsUrl  => "$baseUrl/getPreInspectionDetailsByVehicleID";
String get checkManualInsStatusUrl     => "$baseUrl/checkManualInspectionStatus";


const String awsSignedUrl = "https://erpapi.sgbregistration.in/v1/File_upload/getsignedurlsgb";
const awsImagePathUrl = 'https://s3.ap-south-1.amazonaws.com/sgberp.in/inspectorApp/';

