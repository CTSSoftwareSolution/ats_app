class PreInsManualStatusReqModel {
  PreInsManualStatusReqModel({
      String? vehicleNo,}){
    _vehicleNo = vehicleNo;
}

  PreInsManualStatusReqModel.fromJson(dynamic json) {
    _vehicleNo = json['vehicle_no'];
  }
  String? _vehicleNo;
PreInsManualStatusReqModel copyWith({  String? vehicleNo,
}) => PreInsManualStatusReqModel(  vehicleNo: vehicleNo ?? _vehicleNo,
);
  String? get vehicleNo => _vehicleNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_no'] = _vehicleNo;
    return map;
  }

}