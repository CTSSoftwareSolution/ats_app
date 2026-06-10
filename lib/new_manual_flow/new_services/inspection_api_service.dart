import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import 'debug_service.dart';

class InspectionApiService {

  // GET /api/inspection/inspection-questions-list-new
  static Future<List<InspectionSection>> fetchSections(AppConfig config) async {
    final url = '${config.fullApiBase}/inspection/inspection-questions-list-new';

    DebugService.log('SYS', 'fetchSections → $url');
    DebugService.log('SYS', 'apiKey=${config.apiKey.isEmpty ? "EMPTY!" : config.apiKey.substring(0, 20) + "..."}');

    try {
      final uri = Uri.parse(url);
      DebugService.apiRequest('POST', url, authToken: config.apiKey);

      final response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: '{}',
      ).timeout(Duration(seconds: config.apiTimeoutSeconds));

      DebugService.apiResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['status'] == true) {
          final data = json['data'] as Map<String, dynamic>;
          final preList  = data['pre_inspection']  as List<dynamic>? ?? [];
          final postList = data['post_inspection'] as List<dynamic>? ?? [];

          DebugService.log('SYS',
              'Questions loaded: pre=${preList.length} post=${postList.length}');

          final sections = <InspectionSection>[];
          for (final s in preList)  sections.add(_parseSection(s, InspectionPhase.pre));
          for (final s in postList) sections.add(_parseSection(s, InspectionPhase.post));

          DebugService.log('SYS', 'Total sections: ${sections.length}');
          return sections;
        } else {
          DebugService.log('RES✗',
              'status=false  message=${json['message']}');
        }
      } else {
        DebugService.log('RES✗',
            'HTTP ${response.statusCode}  body=${response.body.length > 100 ? response.body.substring(0, 100) : response.body}');
      }
    } catch (e) {
      DebugService.log('RES✗', 'fetchSections exception: $e');
      debugPrint('[InspectionAPI] Exception: $e');
    }

    DebugService.log('SYS', 'Using fallback hardcoded sections');
    return [];
  }

  static InspectionSection _parseSection(
      Map<String, dynamic> s, InspectionPhase phase) {
    final title   = s['title']   as String? ?? '';
    final area    = s['area']    as String? ?? '';
    final carData = s['carData'] as List<dynamic>? ?? [];
    final items   = carData.map((q) => _parseItem(q)).toList();

    return InspectionSection(
      id:    '${phase.name}_${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}',
      title: title,
      icon:  _areaIcon(area),
      phase: phase,
      items: items,
    );
  }

  static InspectionItem _parseItem(Map<String, dynamic> q) {
    final questionId    = q['question_id']    as int?    ?? 0;
    final questionText  = q['question_text']  as String? ?? '';
    final complexity    = q['complexity']     as String? ?? 'Medium';
    final photoVideoFlag = q['photo_video']   as int?    ?? 3;
    final allowMultiple  = (q['allow_multiple'] as int?  ?? 1) == 1;
    final itemsList     = q['items']          as List<dynamic>? ?? [];
    final rulesList     = q['rules']          as List<dynamic>? ?? [];

    final params = itemsList
        .map((i) => (i['item_text'] as String? ?? ''))
        .where((t) => t.isNotEmpty)
        .toList();

    final ruleRef = rulesList
        .map((r) => r['rule_ref'] as String? ?? '')
        .where((r) => r.isNotEmpty)
        .join(', ');

    return InspectionItem(
      ref:           questionId.toString(),
      questionId:    questionId,
      name:          questionText,
      params:        params,
      ruleRef:       ruleRef,
      complexity:    complexity,
      photoVideoFlag: photoVideoFlag,
      allowMultiple:  allowMultiple,
    );
  }

  static String _areaIcon(String area) {
    switch (area.toLowerCase()) {
      case 'lighting':   return '💡';
      case 'safety':     return '🛡️';
      case 'body':       return '🚗';
      case 'emission':   return '💨';
      case 'brakes':     return '⚙️';
      case 'protection': return '🔆';
      case 'electric':   return '⚡';
      default:           return '📋';
    }
  }
}
