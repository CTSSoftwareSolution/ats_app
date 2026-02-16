class PreInsDetailsReqModel {
  PreInsDetailsReqModel({
      String? vehicleNo,}){
    _vehicleNo = vehicleNo;
}

  PreInsDetailsReqModel.fromJson(dynamic json) {
    _vehicleNo = json['vehicle_no'];
  }
  String? _vehicleNo;
  PreInsDetailsReqModel copyWith({  String? vehicleNo,
}) => PreInsDetailsReqModel(  vehicleNo: vehicleNo ?? _vehicleNo,
);
  String? get vehicleNo => _vehicleNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_no'] = _vehicleNo;
    return map;
  }

}