import 'dart:typed_data';

enum InspectionResult { none, pass, fail, na }
enum MediaType { photo, video }
enum InspectionPhase { pre, post }

class GeoTag {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime capturedAt;

  const GeoTag({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.capturedAt,
  });

  String get coordString =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  String get formattedDate {
    final d = capturedAt;
    return '${d.day.toString().padLeft(2,'0')}-'
        '${d.month.toString().padLeft(2,'0')}-'
        '${d.year}  '
        '${d.hour.toString().padLeft(2,'0')}:'
        '${d.minute.toString().padLeft(2,'0')}:'
        '${d.second.toString().padLeft(2,'0')}';
  }
}

class MediaFile {
  final String id;
  final String path;
  final Uint8List? bytes;
  final MediaType type;
  final GeoTag geoTag;
  final bool savedToServer;
  final String? storageNote;

  MediaFile({
    required this.id,
    required this.path,
    this.bytes,
    required this.type,
    required this.geoTag,
    this.savedToServer = false,
    this.storageNote,
  });
}

class InspectionItem {
  final String ref;         // display ref e.g. '02', '03-a'
  final int    questionId;  // DB question_id from lms.pre_inspection_questions_new
  final String name;
  final List<String> params;
  final String ruleRef;
  final String complexity;

  // Media flags from API
  final int  photoVideoFlag;   // 1=photo only, 2=video only, 3=both
  final bool allowMultiple;    // true = allow multiple captures
  InspectionResult result;
  String observation;
  List<MediaFile> media;

  InspectionItem({
    required this.ref,
    this.questionId = 0,
    required this.name,
    required this.params,
    this.ruleRef = '',
    this.complexity      = 'Medium',
    this.photoVideoFlag  = 3,    // default: both photo and video allowed
    this.allowMultiple   = true, // default: multiple captures allowed
    this.result = InspectionResult.none,
    this.observation = '',
    List<MediaFile>? media,
  }) : media = media ?? [];

  bool get isDone => result != InspectionResult.none;

  String get resultLabel {
    switch (result) {
      case InspectionResult.pass: return 'Pass';
      case InspectionResult.fail: return 'Fail';
      case InspectionResult.na:   return 'N/A';
      case InspectionResult.none: return '—';
    }
  }
}

class InspectionSection {
  final String id;
  final String title;
  final String icon;
  final InspectionPhase phase;
  final List<InspectionItem> items;

  InspectionSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.phase,
    required this.items,
  });

  int get passCount   => items.where((i) => i.result == InspectionResult.pass).length;
  int get failCount   => items.where((i) => i.result == InspectionResult.fail).length;
  int get naCount     => items.where((i) => i.result == InspectionResult.na).length;
  int get doneCount   => items.where((i) => i.isDone).length;
  bool get hasFailure => items.any((i) => i.result == InspectionResult.fail);
  bool get allDone    => items.every((i) => i.isDone);
  int get totalMedia  => items.fold(0, (s, i) => s + i.media.length);
}

class VehicleInfo {
  String regNo, vehicleClass, make, model;
  String fuelType, engineNo, chassisNo, emissionNorms;
  String testDate, atsName, rtoDistrict, testNo;

  VehicleInfo({
    this.regNo = '', this.vehicleClass = '', this.make = '', this.model = '',
    this.fuelType = '', this.engineNo = '', this.chassisNo = '',
    this.emissionNorms = '', this.testDate = '', this.atsName = '',
    this.rtoDistrict = '', this.testNo = '',
  });
}
