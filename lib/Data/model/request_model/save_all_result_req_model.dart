class SaveAllResultReqModel {
  SaveAllResultReqModel({
      String? vehicleId, 
      String? appointmentId,}){
    _vehicleId = vehicleId;
    _appointmentId = appointmentId;
}

  SaveAllResultReqModel.fromJson(dynamic json) {
    _vehicleId = json['vehicle_id'];
    _appointmentId = json['appointment_id'];
  }
  String? _vehicleId;
  String? _appointmentId;
SaveAllResultReqModel copyWith({  String? vehicleId,
  String? appointmentId,
}) => SaveAllResultReqModel(  vehicleId: vehicleId ?? _vehicleId,
  appointmentId: appointmentId ?? _appointmentId,
);
  String? get vehicleId => _vehicleId;
  String? get appointmentId => _appointmentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_id'] = _vehicleId;
    map['appointment_id'] = _appointmentId;
    return map;
  }

}