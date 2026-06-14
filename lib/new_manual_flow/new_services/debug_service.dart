import 'package:flutter/material.dart';

class DebugService {
  static bool _enabled = false;
  static final List<DebugEntry> entries = [];
  static const int _maxEntries = 500;

  static bool get isEnabled => _enabled;

  static void setEnabled(bool v) {
    _enabled = v;
    if (v) _add('SYS', 'Debug mode enabled');
  }

  static void _add(String tag, String message) {
    entries.add(DebugEntry(tag: tag, message: message, time: DateTime.now()));
    if (entries.length > _maxEntries) entries.removeAt(0);
    debugPrint('[CTS][$tag] $message');
  }

  static void log(String tag, String message) {
    if (!_enabled) return;
    _add(tag, message);
  }

  static void apiRequest(String method, String url,
      {String? authToken, Map<String, String>? fields}) {
    if (!_enabled) return;
    _add('REQ', '$method  $url');
    if (authToken != null && authToken.isNotEmpty) {
      final preview = authToken.length > 25
          ? authToken.substring(0, 25) + '...' : authToken;
      _add('AUTH', 'Bearer $preview');
    }
    if (fields != null && fields.isNotEmpty) {
      _add('FIELDS', fields.entries
          .where((e) => e.key != 'file')
          .map((e) => '${e.key}=${e.value}')
          .join('  '));
    }
  }

  static void apiResponse(int statusCode, String body) {
    if (!_enabled) return;
    final preview = body.length > 400
        ? body.substring(0, 400) + '...' : body;
    _add(statusCode >= 200 && statusCode < 300 ? 'RES✓' : 'RES✗',
        '$statusCode  $preview');
  }

  static void uploadFile(String filename, {int? sizeBytes, bool ok = true,
    String? error}) {
    if (!_enabled) return;
    final size = sizeBytes != null
        ? ' (${(sizeBytes / 1024).toStringAsFixed(1)} KB)' : '';
    if (ok) {
      _add('UP✓', '$filename$size');
    } else {
      _add('UP✗', '$filename  ${error ?? 'failed'}');
    }
  }

  static void clear() => entries.clear();
}

class DebugEntry {
  final String tag;
  final String message;
  final DateTime time;

  DebugEntry({required this.tag, required this.message, required this.time});

  String get timeStr {
    final t = time;
    return '${t.hour.toString().padLeft(2,'0')}:'
        '${t.minute.toString().padLeft(2,'0')}:'
        '${t.second.toString().padLeft(2,'0')}';
  }

  Color get color {
    if (tag.contains('✓')) return const Color(0xFF4ADE80);
    if (tag.contains('✗') || tag.contains('ERR')) return const Color(0xFFFF6B6B);
    if (tag == 'REQ') return const Color(0xFF60A5FA);
    if (tag == 'AUTH') return const Color(0xFFFBBF24);
    if (tag == 'SYS') return const Color(0xFF94A3B8);
    if (tag == 'FIELDS') return const Color(0xFFD8B4FE);
    return const Color(0xFFCBD5E1);
  }
}
