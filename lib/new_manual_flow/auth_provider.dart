import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'new_model/auth_model.dart';
import 'new_services/config_storage.dart';
import 'new_services/debug_service.dart';
import 'new_services/label_service.dart';
import 'new_services/session_service.dart';

class AuthProvider extends ChangeNotifier {
  AppUser?   _currentUser;
  AppConfig  _config = AppConfig();
  String?    _loginError;
  bool       _loading = false;
  bool       _sessionRestored = false;

  AppUser?   get currentUser      => _currentUser;
  AppConfig  get config           => _config;
  String?    get loginError       => _loginError;
  bool       get loading          => _loading;
  bool       get isLoggedIn       => _currentUser != null;
  bool       get isAdmin          => _currentUser?.role == UserRole.admin;
  bool       get isOperator       => _currentUser?.role == UserRole.operator;
  bool       get sessionRestored  => _sessionRestored;

  // ── Restore session on app start ──────────────────────────────────────────
  Future<bool> tryRestoreSession() async {
    try {
      final session = await SessionService.restoreSession();
      if (session != null) {
        _currentUser = session.user;
        _config          = session.config;
        _config.apiKey   = session.user.accessToken;
        _config.createdBy = session.user.id;
        DebugService.setEnabled(_config.debugMode);
        DebugService.log('SYS', 'Session restored: ${session.user.username}');
        unawaited(LabelService.loadLabels(_config));
        _sessionRestored = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('[Auth] Session restore failed: $e');
    }
    _sessionRestored = true;
    notifyListeners();
    return false;
  }

  // ── Set config values without notifying (used at startup) ───────────────────
  void updateConfigSilent({String? serverUrl, String? apiBasePath}) {
    if (serverUrl != null)    _config.serverUrl   = serverUrl;
    if (apiBasePath != null)  _config.apiBasePath = apiBasePath;
  }

  // ── Login via Cerisetech API ──────────────────────────────────────────────
  // Local admin credentials — bypasses API, used for first-time config
  static const _localAdminUser = 'admin';
  static const _localAdminPass = 'admin@2026';

  Future<bool> login(String username, String password) async {
    _loading = true;
    _loginError = null;
    notifyListeners();

    // ── Local admin bypass — no API call ─────────────────────────────
    if (username.trim() == _localAdminUser && password == _localAdminPass) {
      _currentUser = AppUser(
        id:          'local-admin',
        username:    _localAdminUser,
        displayName: 'Local Admin',
        role:        UserRole.admin,
        accessToken: '',
        location:    'Local Configuration',
        roles:       ['ADMIN'],
      );
      // Don't overwrite the API key — keep whatever was saved
      DebugService.log('SYS', 'Local admin login — bypassing API');
      await SessionService.saveSession(_currentUser!, _config);
      _loading = false;
      notifyListeners();
      return true;
    }

    try {
      final uri = Uri.parse(_config.loginUrl);
      DebugService.log('SYS', 'LOGIN  url=' + uri.toString());
      DebugService.apiRequest('POST', uri.toString(),
          authToken: null,
          fields: {'username': username});

      final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username.trim(), 'password': password}),
      ).timeout(Duration(seconds: _config.apiTimeoutSeconds));

      DebugService.apiResponse(response.statusCode, response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['Success'] == true) {
          final data      = json['Data'] as Map<String, dynamic>;
          final token     = data['access_token'] as String;
          final fullName  = data['user_full_name'] as String? ?? username;
          final userId    = data['user_id'] as String? ?? '';
          final location  = data['location'] as String? ?? '';
          final rolesList = (data['roles'] as List<dynamic>?)
              ?.map((r) => r.toString()).toList() ?? [];
          final isAdmin   = rolesList.any((r) => r.toUpperCase() == 'ADMIN');

          _currentUser = AppUser(
            id: userId, username: username.trim(),
            displayName: fullName,
            role: isAdmin ? UserRole.admin : UserRole.operator,
            accessToken: token, location: location, roles: rolesList,
          );
          _config.apiKey    = token;
          _config.createdBy = userId;  // Guid for created_by field

          // Sync debug and save session
          DebugService.setEnabled(_config.debugMode);
          await ConfigStorage.save(
              serverUrl: _config.serverUrl,
              apiBasePath: _config.apiBasePath);
          await SessionService.saveSession(_currentUser!, _config);
          DebugService.log('SYS', 'Login OK: $username  role=${rolesList.join(',')}');
          // Load inspection labels from server
          unawaited(LabelService.loadLabels(_config));

          _loginError = null;
          _loading = false;
          notifyListeners();
          return true;
        }
        _loginError = json['Message'] as String? ?? 'Invalid credentials';
      } else if (response.statusCode == 401) {
        _loginError = 'Invalid username or password';
      } else {
        _loginError = 'Server error (${response.statusCode})';
      }
    } on http.ClientException {
      _loginError = 'Cannot reach server: ${_config.serverUrl}';
    } catch (e) {
      _loginError = 'Login failed: $e';
    }

    _loading = false;
    notifyListeners();
    return false;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    DebugService.log('SYS', 'Logout: ${_currentUser?.username}');
    DebugService.clear();
    LabelService.clear();
    _currentUser = null;
    _config.apiKey = '';
    await SessionService.clearSession();
    notifyListeners();
  }

  // ── Config update ─────────────────────────────────────────────────────────
  void updateConfig({
    String? serverUrl, String? apiBasePath, String? apiKey,
    int? apiTimeoutSeconds, String? photoSavePath, String? videoSavePath,
    String? reportSavePath, bool? autoUploadOnCapture,
    bool? uploadPhotosToServer, bool? uploadVideosToServer,
    bool? uploadReportsToServer, String? photoFormat, int? photoQuality,
    bool? stampGpsOnPhoto, int? maxVideoMinutes, bool? requireAllPhotos,
    bool? requireObservationOnFail, bool? allowRetakePhotos, bool? debugMode,
    bool? requireMediaForPass, bool? requireMediaForFail,
    bool? requireCommentForFail, bool? requireMediaOnAnyResult,
    bool? enforceStepOrder, bool? requirePhotosForPre, bool? requirePreForPost,
  }) {
    if (serverUrl != null)                _config.serverUrl = serverUrl;
    if (apiBasePath != null)              _config.apiBasePath = apiBasePath;
    if (apiKey != null)                   _config.apiKey = apiKey;
    if (apiTimeoutSeconds != null)        _config.apiTimeoutSeconds = apiTimeoutSeconds;
    if (photoSavePath != null)            _config.photoSavePath = photoSavePath;
    if (videoSavePath != null)            _config.videoSavePath = videoSavePath;
    if (reportSavePath != null)           _config.reportSavePath = reportSavePath;
    if (autoUploadOnCapture != null)      _config.autoUploadOnCapture = autoUploadOnCapture;
    if (uploadPhotosToServer != null)     _config.uploadPhotosToServer = uploadPhotosToServer;
    if (uploadVideosToServer != null)     _config.uploadVideosToServer = uploadVideosToServer;
    if (uploadReportsToServer != null)    _config.uploadReportsToServer = uploadReportsToServer;
    if (photoFormat != null)              _config.photoFormat = photoFormat;
    if (photoQuality != null)             _config.photoQuality = photoQuality;
    if (stampGpsOnPhoto != null)          _config.stampGpsOnPhoto = stampGpsOnPhoto;
    if (maxVideoMinutes != null)          _config.maxVideoMinutes = maxVideoMinutes;
    if (requireAllPhotos != null)         _config.requireAllPhotos = requireAllPhotos;
    if (requireObservationOnFail != null) _config.requireObservationOnFail = requireObservationOnFail;
    if (allowRetakePhotos != null)        _config.allowRetakePhotos = allowRetakePhotos;
    if (debugMode != null) {
      _config.debugMode = debugMode;
      DebugService.setEnabled(debugMode);
    }
    if (requireMediaForPass != null)     _config.requireMediaForPass     = requireMediaForPass;
    if (requireMediaForFail != null)     _config.requireMediaForFail     = requireMediaForFail;
    if (requireCommentForFail != null)   _config.requireCommentForFail   = requireCommentForFail;
    if (requireMediaOnAnyResult != null) _config.requireMediaOnAnyResult = requireMediaOnAnyResult;
    if (enforceStepOrder != null)        _config.enforceStepOrder        = enforceStepOrder;
    if (requirePhotosForPre != null) _config.requirePhotosForPre = requirePhotosForPre;
    if (requirePreForPost != null)   _config.requirePreForPost   = requirePreForPost;
    // Persist server URL independently (survives logout)
    ConfigStorage.save(serverUrl: _config.serverUrl, apiBasePath: _config.apiBasePath);
    // Persist full config in session
    SessionService.saveConfig(_config);
    notifyListeners();
  }
}
