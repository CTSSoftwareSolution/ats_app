class PreInspectionDetailsReqModel {
  PreInspectionDetailsReqModel({
      num? appointmentId, 
      String? vehicleId,}){
    _appointmentId = appointmentId;
    _vehicleId = vehicleId;
}

  PreInspectionDetailsReqModel.fromJson(dynamic json) {
    _appointmentId = json['appointment_id'];
    _vehicleId = json['vehicle_id'];
  }
  num? _appointmentId;
  String? _vehicleId;
PreInspectionDetailsReqModel copyWith({  num? appointmentId,
  String? vehicleId,
}) => PreInspectionDetailsReqModel(  appointmentId: appointmentId ?? _appointmentId,
  vehicleId: vehicleId ?? _vehicleId,
);
  num? get appointmentId => _appointmentId;
  String? get vehicleId => _vehicleId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appointment_id'] = _appointmentId;
    map['vehicle_id'] = _vehicleId;
    return map;
  }

}