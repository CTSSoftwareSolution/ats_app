import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Core/network/services.dart';
import '../../utilities/preferences.dart';
import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import 'debug_service.dart';

class InspectionApiService {

  // GET /api/inspection/inspection-questions-list-new
  static Future<List<InspectionSection>> fetchSections(AppConfig config) async {
    //final url = '${config.fullApiBase}/inspection/inspection-questions-list-new';
    final url = 'http://65.2.53.173/Api/api/inspection/inspection-questions-list-new';
    DebugService.log('SYS', 'fetchSections -> ' + url);
    debugPrint('SYS fetchSections -> $url');

    config.apiKey = Preferences.getToken();
    try {
      final uri = Uri.parse(url);
      DebugService.apiRequest('POST', url, authToken: config.apiKey);

      debugPrint('API Request: POST, $url, ${config.apiKey}');
      debugPrint('Token ${config.apiKey}');

      final response = await http.post(uri,
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: '{}',
      );

      if (kDebugMode) {
        alice.onHttpResponse(
          response,
          body: response.body,
        );
      }

      debugPrint('API Response: ${response.body}');

      DebugService.apiResponse(response.statusCode, response.body);

       debugPrint('API Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['status'] == true) {
          final data     = json['data'] as Map<String, dynamic>;
          final preList  = data['pre_inspection']  as List<dynamic>? ?? [];
          final postList = data['post_inspection'] as List<dynamic>? ?? [];

          DebugService.log('SYS',
              'Questions: pre=' + preList.length.toString() +
                  ' post=' + postList.length.toString());
          debugPrint('SYS  Questions: pre= ${preList.length.toString()} post= ${ postList.length.toString()}');

          // Group by area -> one tab per area (Lighting, Safety, Body...)
          final sections = <InspectionSection>[];
          sections.addAll(_groupByArea(preList,  InspectionPhase.pre));
          sections.addAll(_groupByArea(postList, InspectionPhase.post));

          DebugService.log('SYS', 'Sections: ' + sections.length.toString());
          debugPrint('SYS Sections: ${sections.length.toString()}');
          return sections;
        }
        DebugService.log('RES\u2717', 'status=false');
        debugPrint('RES\u2717 status=false');
      }
    } catch (e) {
      DebugService.log('RES\u2717', 'fetchSections: ' + e.toString());
      debugPrint('RES\u2717 fetchSections:  ${ e.toString()}');
    }
    DebugService.log('SYS', 'Using fallback sections');
    debugPrint('SYS  Using fallback sections');
    return [];
  }

  // Group flat list by area -> one InspectionSection per area
  static List<InspectionSection> _groupByArea(
      List<dynamic> list, InspectionPhase phase) {
    final areaMap = <String, List<InspectionItem>>{};
    for (final q in list) {
      final area = (q['area'] as String? ?? 'General');
      areaMap.putIfAbsent(area, () => []);
      areaMap[area]!.add(_parseItem(q));
    }
    return areaMap.entries.map((e) => InspectionSection(
      id:    phase.name + '_' + e.key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
      title: e.key,
      icon:  _areaIcon(e.key),
      phase: phase,
      items: e.value,
    )).toList();
  }


  static int _toInt(dynamic v, int fallback) {
    if (v == null) return fallback;
    if (v is int)  return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
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
    // photo_video: 1=photo only, 2=video only, 3=both
    // allow_multiple: 1=multiple allowed, 0=single only
    final photoVideoFlag = _toInt(q['photo_video'], 3);
    final allowMultiple  = _toInt(q['allow_multiple'], 1) == 1;

    DebugService.log('SYS',
        'Q' + questionId.toString() +
            ' photo_video=' + (q['photo_video']?.toString() ?? 'null') +
            ' allow_multiple=' + (q['allow_multiple']?.toString() ?? 'null') +
            ' => flag=' + photoVideoFlag.toString() +
            ' multi=' + allowMultiple.toString());
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
