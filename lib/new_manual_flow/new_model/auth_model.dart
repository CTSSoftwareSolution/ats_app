enum UserRole { admin, operator }

class AppUser {
  final String id;
  final String username;
  final String displayName;
  final UserRole role;
  final String accessToken;
  final String location;
  final List<String> roles;

  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.accessToken,
    required this.location,
    this.roles = const [],
  });

  String? get operatorId => role == UserRole.operator ? id.substring(0, 8).toUpperCase() : null;
  String? get station => location;
}

class AppConfig {
  // API — Cerisetech LMS
  String serverUrl;          // http://192.168.1.5
  String apiBasePath;        // /API/api
  String apiKey;             // populated from JWT after login
  int apiTimeoutSeconds;

  // Storage paths
  String photoSavePath;
  String videoSavePath;
  String reportSavePath;

  // Upload settings
  bool autoUploadOnCapture;
  bool uploadPhotosToServer;
  bool uploadVideosToServer;
  bool uploadReportsToServer;
  String photoFormat;
  int photoQuality;
  bool stampGpsOnPhoto;
  int maxVideoMinutes;

  // Inspection settings
  bool requireAllPhotos;
  bool requireObservationOnFail;
  bool allowRetakePhotos;

  // Inspection validation rules
  bool requireMediaForPass;       // pass needs at least 1 photo/video
  bool requireMediaForFail;       // fail needs at least 1 photo/video
  bool requireCommentForFail;     // fail needs observation text
  bool requireMediaOnAnyResult;   // any result (pass/fail) needs media

  // Step validation
  bool enforceStepOrder;      // if true: photos → pre → post must be in order
  bool requirePhotosForPre;   // photos must be complete before pre-inspection
  bool requirePreForPost;     // pre-inspection must be complete before post

  // Upload identity
  String createdBy;  // user_id Guid from JWT — sent as created_by

  // Debug
  bool debugMode;

  AppConfig({
    this.serverUrl            = 'http://192.168.1.5',
    this.apiBasePath          = '/api',
    this.apiKey               = '',
    this.apiTimeoutSeconds    = 30,
    this.photoSavePath        = '/storage/AVIS/photos',
    this.videoSavePath        = '/storage/AVIS/videos',
    this.reportSavePath       = '/storage/AVIS/reports',
    this.autoUploadOnCapture  = false,
    this.uploadPhotosToServer = true,
    this.uploadVideosToServer = false,
    this.uploadReportsToServer= true,
    this.photoFormat          = 'jpg',
    this.photoQuality         = 90,
    this.stampGpsOnPhoto      = true,
    this.maxVideoMinutes      = 3,
    this.requireAllPhotos     = true,
    this.requireObservationOnFail = false,
    this.allowRetakePhotos    = true,
    this.requireMediaForPass      = false,
    this.requireMediaForFail      = true,
    this.requireCommentForFail    = true,
    this.requireMediaOnAnyResult  = false,
    this.enforceStepOrder         = true,
    this.requirePhotosForPre  = true,
    this.requirePreForPost    = true,
    this.createdBy            = '',
    this.debugMode            = false,
  });

  /// Full base URL e.g. http://192.168.1.5/API/api
  String get fullApiBase =>
      '${serverUrl.trimRight()}${apiBasePath.startsWith('/') ? '' : '/'}$apiBasePath';

  /// Login endpoint
  String get loginUrl => '$fullApiBase/login/auth';

  /// Media upload endpoint
  String get mediaUploadUrl => '$fullApiBase/media';
}
