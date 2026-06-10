import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../new_model/auth_model.dart';
import '../new_model/inspection_data.dart';
import '../new_model/vehicle_entry.dart';

class VehicleApiService {
  static const _uuid = Uuid();

  // POST /API/api/vehicle/list-with-appointment
  // Body: { "page_no": 1, "page_size": 10, "status": 0 }
  static Future<List<VehicleEntry>> fetchVehicles({
    required AppConfig config,
    int pageNo = 1,
    int pageSize = 50,
    int status = 0,  // 0 = Scheduled
  }) async {
    try {
      final uri = Uri.parse('${config.fullApiBase}/vehicle/list-with-appointment');
      debugPrint('[VehicleAPI] POST $uri');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'page_no': pageNo,
          'page_size': pageSize,
          'status': status,
        }),
      ).timeout(Duration(seconds: config.apiTimeoutSeconds));

      debugPrint('[VehicleAPI] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['Success'] == true) {
          final data = json['Data'] as Map<String, dynamic>;
          final rows = data['rows'] as List<dynamic>? ?? [];
          debugPrint('[VehicleAPI] Loaded ${rows.length} vehicles');
          return rows.map((r) => _mapRow(r as Map<String, dynamic>)).toList();
        }
        debugPrint('[VehicleAPI] API error: ${json['Message']}');
      }
    } catch (e) {
      debugPrint('[VehicleAPI] Error: $e');
      rethrow;
    }
    return [];
  }

  static VehicleEntry _mapRow(Map<String, dynamic> r) {
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2,'0')}-'
        '${now.month.toString().padLeft(2,'0')}-${now.year}';

    return VehicleEntry(
      id:              _uuid.v4(),
      appointmentId:   r['appointment_id']?.toString() ?? '',
      bookingId:       r['booking_id']?.toString() ?? '',
      regNo:           r['registration_no'] ?? '',
      vehicleClass:    r['category_name'] ?? '',
      make:            r['make'] ?? '',
      model:           r['model'] ?? '',
      fuelType:        r['fuel_type_name'] ?? '',
      emissionNorms:   '',
      engineNo:        '',
      chassisNo:       '',
      customerName:    r['customer_name'] ?? '',
      customerContact: r['customer_contact'] ?? '',
      laneName:        r['lane_name'] ?? '',
      laneTypeCode:    r['lane_type_code'] ?? '',
      statusName:      r['status_name'] ?? 'Scheduled',
      fitnessExpiry:   r['fitness_expiry'] ?? '',
      finalResult:     r['final_result'],
      atsName:         '',
      rtoDistrict:     '',
      testDate:        dateStr,
      testNo:          r['booking_id']?.toString() ?? '',
      sections:        InspectionData.buildSections(),
    );
  }
}
