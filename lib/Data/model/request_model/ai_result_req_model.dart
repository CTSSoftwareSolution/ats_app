class AiResultReqModel {
  AiResultReqModel({
      String? vehicleId, 
      String? appointmentId, 
      String? documentId,}){
    _vehicleId = vehicleId;
    _appointmentId = appointmentId;
    _documentId = documentId;
}

  AiResultReqModel.fromJson(dynamic json) {
    _vehicleId = json['vehicle_id'];
    _appointmentId = json['appointment_id'];
    _documentId = json['document_id'];
  }
  String? _vehicleId;
  String? _appointmentId;
  String? _documentId;
AiResultReqModel copyWith({  String? vehicleId,
  String? appointmentId,
  String? documentId,
}) => AiResultReqModel(  vehicleId: vehicleId ?? _vehicleId,
  appointmentId: appointmentId ?? _appointmentId,
  documentId: documentId ?? _documentId,
);
  String? get vehicleId => _vehicleId;
  String? get appointmentId => _appointmentId;
  String? get documentId => _documentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_id'] = _vehicleId;
    map['appointment_id'] = _appointmentId;
    map['document_id'] = _documentId;
    return map;
  }

}