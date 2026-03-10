import 'dart:io';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import '../../app_config/app_config.dart';

String get baseUrl => appConfig.baseUrl;
String get newBaseUrl => appConfig.baseUrl;

// Map<String, String> authHeader = {
//   HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
// };

Map<String, String> authHeader = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
  HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
};

final navigatorKey = GlobalKey<NavigatorState>();
final alice = Alice(
    navigatorKey: navigatorKey,
    showNotification: true,
    showInspectorOnShake: true);



/// OLD Node.js
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


/// New API
String get newLoginUrl                    => "${newBaseUrl}login/auth";
String get uploadImage                    => "${newBaseUrl}Inspection/upload";
String get inspectionQuestionsList        => "${newBaseUrl}Inspection/inspection-questions-list";
String get preInspectionAppointmentList   => "${newBaseUrl}Appointment/pre-inspection-appointment-list";
String get preInspectionDetails           => "${newBaseUrl}Inspection/preinspection-details";
String get savePreInspection           => "${newBaseUrl}Inspection/save-pre-inspection";


const String awsSignedUrl = "https://erpapi.sgbregistration.in/v1/File_upload/getsignedurlsgb";
const awsImagePathUrl = 'https://s3.ap-south-1.amazonaws.com/sgberp.in/inspectorApp/';

