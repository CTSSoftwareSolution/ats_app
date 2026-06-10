
import 'package:ats_app/new_manual_flow/new_model/vehicle_photos_model.dart';

import 'inspection_model.dart';

enum InspectionStatus { pending, photosOnly, inProgress, completed }

class VehicleEntry {
  final String id;
  final String appointmentId;
  final String bookingId;
  String regNo;
  String vehicleClass;
  String make;
  String model;
  String fuelType;
  String engineNo;
  String chassisNo;
  String emissionNorms;
  String atsName;
  String rtoDistrict;
  String testNo;
  String testDate;
  // From API
  String customerName;
  String customerContact;
  String laneName;
  String laneTypeCode;
  String statusName;
  String fitnessExpiry;
  dynamic finalResult;

  final DateTime createdAt;
  final Map<VehiclePhotoAngle, VehiclePhoto> photos;
  final List<InspectionSection> sections;

  // Phase tracking
  bool preInspectionStarted;
  DateTime? preInspectionStartedAt;
  bool preInspectionComplete;
  DateTime? preInspectionCompletedAt;
  bool postInspectionStarted;
  DateTime? postInspectionStartedAt;
  bool postInspectionComplete;
  DateTime? postInspectionCompletedAt;

  VehicleEntry({
    required this.id,
    this.appointmentId = '',
    this.bookingId = '',
    this.regNo = '',
    this.vehicleClass = '',
    this.make = '',
    this.model = '',
    this.fuelType = '',
    this.engineNo = '',
    this.chassisNo = '',
    this.emissionNorms = '',
    this.atsName = '',
    this.rtoDistrict = '',
    this.testNo = '',
    this.testDate = '',
    this.customerName = '',
    this.customerContact = '',
    this.laneName = '',
    this.laneTypeCode = '',
    this.statusName = 'Scheduled',
    this.fitnessExpiry = '',
    this.finalResult,
    DateTime? createdAt,
    Map<VehiclePhotoAngle, VehiclePhoto>? photos,
    required this.sections,
    this.preInspectionStarted = false,
    this.preInspectionStartedAt,
    this.preInspectionComplete = false,
    this.preInspectionCompletedAt,
    this.postInspectionStarted = false,
    this.postInspectionStartedAt,
    this.postInspectionComplete = false,
    this.postInspectionCompletedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        photos = photos ?? {};

  String get displayName =>
      regNo.isNotEmpty ? regNo.toUpperCase() : 'Vehicle ${id.substring(0, 6)}';

  int get photoCount => photos.length;
  bool get photosComplete => photos.length == VehiclePhotoAngle.values.length;

  InspectionStatus get status {
    final total = sections.fold(0, (s, sec) => s + sec.items.length);
    final done = sections.fold(0, (s, sec) => s + sec.doneCount);
    if (done == 0 && photos.isEmpty) return InspectionStatus.pending;
    if (done == 0) return InspectionStatus.photosOnly;
    if (done < total) return InspectionStatus.inProgress;
    return InspectionStatus.completed;
  }

  String get overallResult {
    final total = sections.fold(0, (s, sec) => s + sec.items.length);
    final done = sections.fold(0, (s, sec) => s + sec.doneCount);
    if (done < total) return 'PENDING';
    if (sections.any((s) => s.hasFailure)) return 'UNFIT';
    return 'FIT';
  }

  int get totalItems    => sections.fold(0, (s, sec) => s + sec.items.length);
  int get passCount     => sections.fold(0, (s, sec) => s + sec.passCount);
  int get failCount     => sections.fold(0, (s, sec) => s + sec.failCount);
  int get naCount       => sections.fold(0, (s, sec) => s + sec.naCount);
  int get doneCount     => sections.fold(0, (s, sec) => s + sec.doneCount);
  int get pendingCount  => totalItems - doneCount;

  // Pre sections only
  List<InspectionSection> get preSections =>
      sections.where((s) => s.phase.name == 'pre').toList();

  // Post sections only
  List<InspectionSection> get postSections =>
      sections.where((s) => s.phase.name == 'post').toList();

  int get preDoneCount =>
      preSections.fold(0, (s, sec) => s + sec.doneCount);
  int get preTotalItems =>
      preSections.fold(0, (s, sec) => s + sec.items.length);
  bool get preAllDone => preDoneCount == preTotalItems && preTotalItems > 0;

  int get postDoneCount =>
      postSections.fold(0, (s, sec) => s + sec.doneCount);
  int get postTotalItems =>
      postSections.fold(0, (s, sec) => s + sec.items.length);
  bool get postAllDone => postDoneCount == postTotalItems && postTotalItems > 0;
}
