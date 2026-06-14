import 'package:flutter/foundation.dart';
import 'new_model/auth_model.dart';
import 'new_model/inspection_data.dart';
import 'new_model/inspection_model.dart';
import 'new_model/vehicle_entry.dart';
import 'new_model/vehicle_photos_model.dart';
import 'new_services/geo_media_service.dart';
import 'new_services/inspection_api_service.dart';
import 'new_services/vehicle_api_service.dart';
import 'new_services/vehicle_photo_service.dart';


class AppProvider extends ChangeNotifier {
  AppConfig _config = AppConfig();
  AppConfig get config => _config;

  final List<VehicleEntry> vehicles = [];
  bool _loadingVehicles = false;
  bool get loadingVehicles => _loadingVehicles;
  String? _vehicleError;
  String? get vehicleError => _vehicleError;

  bool _capturing = false;
  bool get capturing => _capturing;

  void setConfig(AppConfig cfg) {
    _config = cfg;
    notifyListeners();
  }

  // Cached sections loaded from API
  List<InspectionSection> _cachedSections = [];

  // ── Load inspection sections from API ────────────────────────────────────────
  Future<void> loadSections() async {
    //debugPrint('[Sections] START url=' + _config.fullApiBase);
    try {
      final sections = await InspectionApiService.fetchSections(_config);
      debugPrint('[Sections] API returned ' + sections.length.toString());
      if (sections.isNotEmpty) {
        _cachedSections = sections;
        // Log first item flags to confirm data is correct
        final firstItem = sections.first.items.isNotEmpty ? sections.first.items.first : null;
        // if (firstItem != null) {
        //   debugPrint('[Sections] First item: ref=' + firstItem.ref +
        //       ' qid=' + firstItem.questionId.toString() +
        //       ' flag=' + firstItem.photoVideoFlag.toString() +
        //       ' name=' + firstItem.name.substring(0, 20));
        // }
      } else {
        _cachedSections = InspectionData.buildSections();
        debugPrint('[Sections] FALLBACK — API returned empty');
      }
    } catch (e) {
      _cachedSections = InspectionData.buildSections();
      debugPrint('[Sections] FALLBACK — error: ' + e.toString());
    }
  }
  List<InspectionSection> _buildSectionsForVehicle() {
    if (_cachedSections.isNotEmpty) {
      // Deep copy so each vehicle gets its own independent state
      return _cachedSections.map((s) => InspectionSection(
        id:    s.id,
        title: s.title,
        icon:  s.icon,
        phase: s.phase,
        items: s.items.map((i) => InspectionItem(
          ref:            i.ref,
          questionId:     i.questionId,
          name:           i.name,
          params:         List.from(i.params),
          ruleRef:        i.ruleRef,
          complexity:     i.complexity,
          photoVideoFlag: i.photoVideoFlag,
          allowMultiple:  i.allowMultiple,
        )).toList(),
      )).toList();
    }
    return InspectionData.buildSections();
  }

  // ── Load vehicles from API ────────────────────────────────────────────────
  Future<void> loadVehicles() async {
    _loadingVehicles = true;
    _vehicleError = null;
    notifyListeners();
    try {
      final list = await VehicleApiService.fetchVehicles(config: _config, sections: _cachedSections.isNotEmpty ? _cachedSections : null);
      vehicles.clear();
      vehicles.addAll(list);
      if (list.isEmpty) {
        _vehicleError = 'No appointments found for today';
      }
    } catch (e) {
      _vehicleError = 'Failed to load vehicles: $e';
    } finally {
      _loadingVehicles = false;
      notifyListeners();
    }
  }

  // ── Vehicle info update ───────────────────────────────────────────────────
  void updateVehicleInfo(VehicleEntry v, {
    String? regNo, String? vehicleClass, String? make, String? model,
    String? fuelType, String? engineNo, String? chassisNo,
    String? emissionNorms, String? atsName, String? rtoDistrict,
    String? testNo, String? testDate,
  }) {
    if (regNo != null)          v.regNo = regNo;
    if (vehicleClass != null)   v.vehicleClass = vehicleClass;
    if (make != null)           v.make = make;
    if (model != null)          v.model = model;
    if (fuelType != null)       v.fuelType = fuelType;
    if (engineNo != null)       v.engineNo = engineNo;
    if (chassisNo != null)      v.chassisNo = chassisNo;
    if (emissionNorms != null)  v.emissionNorms = emissionNorms;
    if (atsName != null)        v.atsName = atsName;
    if (rtoDistrict != null)    v.rtoDistrict = rtoDistrict;
    if (testNo != null)         v.testNo = testNo;
    if (testDate != null)       v.testDate = testDate;
    notifyListeners();
  }

  // ── Vehicle photo capture ─────────────────────────────────────────────────
  Future<void> captureVehiclePhoto(VehicleEntry v, VehiclePhotoAngle angle) async {
    _capturing = true;
    notifyListeners();
    try {
      final photo = await VehiclePhotoService.capture(angle,
          config: _config, vehicleReg: v.regNo);
      if (photo != null) v.photos[angle] = photo;
    } finally {
      _capturing = false;
      notifyListeners();
    }
  }

  void retakeVehiclePhoto(VehicleEntry v, VehiclePhotoAngle angle) {
    v.photos.remove(angle);
    notifyListeners();
  }

  // ── Inspection ────────────────────────────────────────────────────────────
  void setResult(VehicleEntry v, InspectionSection section,
      InspectionItem item, InspectionResult result) {
    item.result = result;
    notifyListeners();
    // Results are submitted in bulk on Save Pre/Post Inspection button
  }

  void setObservation(InspectionItem item, String obs) {
    item.observation = obs;
  }

  Future<void> captureEvidencePhoto(VehicleEntry v, InspectionItem item) async {
    // No notifyListeners here — MediaPickerSection manages its own setState
    final media = await GeoMediaService.capturePhoto(
        config: _config, vehicleReg: v.regNo, itemRef: item.ref);
    if (media != null) item.media.add(media);
  }

  Future<void> captureEvidenceVideo(VehicleEntry v, InspectionItem item) async {
    final media = await GeoMediaService.captureVideo(
        config: _config, vehicleReg: v.regNo, itemRef: item.ref);
    if (media != null) item.media.add(media);
  }

  void removeMedia(InspectionItem item, String mediaId) {
    item.media.removeWhere((m) => m.id == mediaId);
    notifyListeners();
  }

  void markAllPass(VehicleEntry v, InspectionSection section) {
    for (final item in section.items) item.result = InspectionResult.pass;
    notifyListeners();
  }

  void clearSection(VehicleEntry v, InspectionSection section) {
    for (final item in section.items) {
      item.result = InspectionResult.none;
      item.observation = '';
      item.media.clear();
    }
    notifyListeners();
  }
}
