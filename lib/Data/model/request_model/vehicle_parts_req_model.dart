class VehiclePartsReqModel {
  VehiclePartsReqModel({
      String? vehicleClass,}){
    _vehicleClass = vehicleClass;
}

  VehiclePartsReqModel.fromJson(dynamic json) {
    _vehicleClass = json['vehicle_class'];
  }
  String? _vehicleClass;
VehiclePartsReqModel copyWith({  String? vehicleClass,
}) => VehiclePartsReqModel(  vehicleClass: vehicleClass ?? _vehicleClass,
);
  String? get vehicleClass => _vehicleClass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicle_class'] = _vehicleClass;
    return map;
  }

}