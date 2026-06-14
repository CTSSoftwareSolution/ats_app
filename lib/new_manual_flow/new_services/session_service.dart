import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../new_model/auth_model.dart';

class SessionService {
  static const _keyUser     = 'session_user';
  static const _keyConfig   = 'session_config';
  static const _keyLoggedIn = 'session_logged_in';

  // ── Save session after login ──────────────────────────────────────────────
  static Future<void> saveSession(AppUser user, AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyUser, jsonEncode({
      'id':           user.id,
      'username':     user.username,
      'displayName':  user.displayName,
      'role':         user.role.name,
      'accessToken':  user.accessToken,
      'location':     user.location,
      'roles':        user.roles,
    }));
    await prefs.setString(_keyConfig, jsonEncode({
      'serverUrl':             config.serverUrl,
      'apiBasePath':           config.apiBasePath,
      'apiKey':                config.apiKey,
      'apiTimeoutSeconds':     config.apiTimeoutSeconds,
      'photoSavePath':         config.photoSavePath,
      'videoSavePath':         config.videoSavePath,
      'reportSavePath':        config.reportSavePath,
      'autoUploadOnCapture':   config.autoUploadOnCapture,
      'uploadPhotosToServer':  config.uploadPhotosToServer,
      'uploadVideosToServer':  config.uploadVideosToServer,
      'uploadReportsToServer': config.uploadReportsToServer,
      'photoFormat':           config.photoFormat,
      'photoQuality':          config.photoQuality,
      'stampGpsOnPhoto':       config.stampGpsOnPhoto,
      'maxVideoMinutes':       config.maxVideoMinutes,
      'requireAllPhotos':      config.requireAllPhotos,
      'requireObservationOnFail': config.requireObservationOnFail,
      'allowRetakePhotos':     config.allowRetakePhotos,
      'debugMode':             config.debugMode,
      'createdBy':             config.createdBy,
      'requireMediaForPass':     config.requireMediaForPass,
      'requireMediaForFail':     config.requireMediaForFail,
      'requireCommentForFail':   config.requireCommentForFail,
      'requireMediaOnAnyResult': config.requireMediaOnAnyResult,
      'enforceStepOrder':        config.enforceStepOrder,
      'requirePhotosForPre':   config.requirePhotosForPre,
      'requirePreForPost':     config.requirePreForPost,
    }));
  }

  // ── Restore session on app start ──────────────────────────────────────────
  static Future<SessionData?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!loggedIn) return null;

    final userJson   = prefs.getString(_keyUser);
    final configJson = prefs.getString(_keyConfig);
    if (userJson == null || configJson == null) return null;

    try {
      final u = jsonDecode(userJson) as Map<String, dynamic>;
      final c = jsonDecode(configJson) as Map<String, dynamic>;

      final user = AppUser(
        id:           u['id'] ?? '',
        username:     u['username'] ?? '',
        displayName:  u['displayName'] ?? '',
        role:         u['role'] == 'admin' ? UserRole.admin : UserRole.operator,
        accessToken:  u['accessToken'] ?? '',
        location:     u['location'] ?? '',
        roles:        (u['roles'] as List<dynamic>?)
            ?.map((r) => r.toString()).toList() ?? [],
      );

      final config = AppConfig(
        serverUrl:               c['serverUrl'] ?? 'http://192.168.1.5',
        apiBasePath:             c['apiBasePath'] ?? '/api',
        apiKey:                  c['apiKey'] ?? '',
        apiTimeoutSeconds:       c['apiTimeoutSeconds'] ?? 30,
        photoSavePath:           c['photoSavePath'] ?? '/storage/AVIS/photos',
        videoSavePath:           c['videoSavePath'] ?? '/storage/AVIS/videos',
        reportSavePath:          c['reportSavePath'] ?? '/storage/AVIS/reports',
        autoUploadOnCapture:     c['autoUploadOnCapture'] ?? false,
        uploadPhotosToServer:    c['uploadPhotosToServer'] ?? true,
        uploadVideosToServer:    c['uploadVideosToServer'] ?? false,
        uploadReportsToServer:   c['uploadReportsToServer'] ?? true,
        photoFormat:             c['photoFormat'] ?? 'jpg',
        photoQuality:            c['photoQuality'] ?? 90,
        stampGpsOnPhoto:         c['stampGpsOnPhoto'] ?? true,
        maxVideoMinutes:         c['maxVideoMinutes'] ?? 3,
        requireAllPhotos:        c['requireAllPhotos'] ?? true,
        requireObservationOnFail: c['requireObservationOnFail'] ?? false,
        allowRetakePhotos:       c['allowRetakePhotos'] ?? true,
        debugMode:               c['debugMode'] ?? false,
        createdBy:               c['createdBy'] ?? '',
        requireMediaForPass:      c['requireMediaForPass']     ?? false,
        requireMediaForFail:      c['requireMediaForFail']     ?? true,
        requireCommentForFail:    c['requireCommentForFail']   ?? true,
        requireMediaOnAnyResult:  c['requireMediaOnAnyResult'] ?? false,
        enforceStepOrder:         c['enforceStepOrder']        ?? true,
        requirePhotosForPre:     c['requirePhotosForPre'] ?? true,
        requirePreForPost:       c['requirePreForPost']   ?? true,
      );

      return SessionData(user: user, config: config);
    } catch (e) {
      await clearSession();
      return null;
    }
  }

  // ── Clear session on logout ───────────────────────────────────────────────
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyConfig);
  }

  // ── Save config only (when admin updates settings) ────────────────────────
  static Future<void> saveConfig(AppConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!loggedIn) return;
    // Re-save full session to update config
    final userJson = prefs.getString(_keyUser);
    if (userJson == null) return;
    final u = jsonDecode(userJson) as Map<String, dynamic>;
    final user = AppUser(
      id: u['id'] ?? '', username: u['username'] ?? '',
      displayName: u['displayName'] ?? '',
      role: u['role'] == 'admin' ? UserRole.admin : UserRole.operator,
      accessToken: config.apiKey, location: u['location'] ?? '',
      roles: (u['roles'] as List?)?.map((r) => r.toString()).toList() ?? [],
    );
    await saveSession(user, config);
  }
}

class SessionData {
  final AppUser user;
  final AppConfig config;
  const SessionData({required this.user, required this.config});
}
