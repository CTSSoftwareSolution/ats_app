class AwsRequest {
  AwsRequest({
    String? contentType,
    String? filePath,

  }) {
    _contentType = contentType;
    _filePath = filePath;

  }

  AwsRequest.fromJson(dynamic json) {
    _contentType = json['contentType'];
    _filePath = json['filePath'];

  }
  String? _contentType;
  String? _filePath;

  AwsRequest copyWith({
    String? contentType,
    String? filePath,
    String? clientId,
  }) =>
      AwsRequest(
        contentType: contentType ?? _contentType,
        filePath: filePath ?? _filePath,

      );
  String? get contentType => _contentType;
  String? get filePath => _filePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contentType'] = _contentType;
    map['filePath'] = _filePath;

    return map;
  }
}
