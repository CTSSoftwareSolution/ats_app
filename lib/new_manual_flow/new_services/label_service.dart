import 'dart:convert';

import 'package:http/http.dart' as http;

import '../new_model/auth_model.dart';
import 'debug_service.dart';

class InspectionLabel {
  final int id;
  final String labelName;
  const InspectionLabel({required this.id, required this.labelName});
}

class LabelService {
  // Cached labels — loaded once after login
  static final List<InspectionLabel> _labels = [];
  static bool _loaded = false;

  static List<InspectionLabel> get labels => List.unmodifiable(_labels);
  static bool get isLoaded => _loaded;

  // GET {serverUrl}/{apiBasePath}/inspection/inspection-label-list
  static Future<void> loadLabels(AppConfig config) async {
    try {
      final uri = Uri.parse(
          '${config.fullApiBase}/inspection/inspection-label-list');
      DebugService.apiRequest('GET', uri.toString(), authToken: config.apiKey);

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${config.apiKey}',
        'Accept': 'application/json',
      }).timeout(Duration(seconds: config.apiTimeoutSeconds));

      DebugService.apiResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['status'] == true) {
          final data = json['data'] as List<dynamic>;
          _labels.clear();
          for (final item in data) {
            _labels.add(InspectionLabel(
              id:        item['id'] as int,
              labelName: item['label_name'] as String,
            ));
          }
          _loaded = true;
          DebugService.log('SYS', 'Labels loaded: ${_labels.length}');
        }
      }
    } catch (e) {
      DebugService.log('SYS', 'Label load failed: $e — using fallback');
      _useFallback();
    }
  }

  // Fallback hardcoded from the API response you shared
  static void _useFallback() {
    _labels
      ..clear()
      ..addAll([
        const InspectionLabel(id: 1, labelName: 'Front photo'),
        const InspectionLabel(id: 2, labelName: 'Rear photo'),
        const InspectionLabel(id: 3, labelName: 'Engine photo'),
        const InspectionLabel(id: 4, labelName: 'Left photo'),
        const InspectionLabel(id: 5, labelName: 'Right photo'),
        const InspectionLabel(id: 6, labelName: 'Chasis number photo'),
        const InspectionLabel(id: 7, labelName: 'Dashboard photo'),
        const InspectionLabel(id: 8, labelName: 'Bottom photo'),
      ]);
    _loaded = true;
  }

  // Fixed order: angles map to label positions 1→8 sequentially
  // Matches server label list order:
  //   1=Front, 2=Rear, 3=Engine, 4=Left, 5=Right, 6=Chassis, 7=Dashboard, 8=Bottom
  static const _angleOrder = [
    'front',      // label position 1
    'rear',       // label position 2
    'engine',     // label position 3
    'leftSide',   // label position 4
    'rightSide',  // label position 5
    'chassis',    // label position 6
    'dashboard',  // label position 7
    'odometer',   // label position 8
  ];

  /// Returns label_id by sequential position (1-based) matching server order.
  /// If labels loaded from API: uses server's actual id at that position.
  /// Falls back to position index (1–8) if not loaded.
  static int getLabelId(String angleName) {
    if (!_loaded) _useFallback();

    final index = _angleOrder.indexOf(angleName);
    if (index < 0) return 0;  // unknown angle

    // Use server label at that position if available
    if (index < _labels.length) {
      return _labels[index].id;
    }

    // Fallback: position + 1 (1-based)
    return index + 1;
  }

  /// Returns label_id by 0-based index directly (for batch upload ordered loop)
  static int getLabelIdByIndex(int index) {
    if (!_loaded) _useFallback();
    if (index >= 0 && index < _labels.length) {
      return _labels[index].id;
    }
    return index + 1;
  }

  static void clear() {
    _labels.clear();
    _loaded = false;
  }
}
