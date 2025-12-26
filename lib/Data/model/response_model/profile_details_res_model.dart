import 'package:ats_app/Domain/entities/profile_details_entity.dart';

class ProfileDetailsResModel extends  ProfileDetailsEntity{
  ProfileDetailsResModel({
      bool? status, 
      String? message, 
      List<DetailsDataModel>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ProfileDetailsResModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DetailsDataModel.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<DetailsDataModel>? _data;
ProfileDetailsResModel copyWith({  bool? status,
  String? message,
  List<DetailsDataModel>? data,
}) => ProfileDetailsResModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<DetailsDataModel>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class DetailsDataModel {
  DetailsDataModel({
      num? userId, 
      String? name, 
      String? email, 
      String? address, 
      String? mobile, 
      String? carName, 
      String? carBrand, 
      String? carModel, 
      String? profileImage,}){
    _userId = userId;
    _name = name;
    _email = email;
    _address = address;
    _mobile = mobile;
    _carName = carName;
    _carBrand = carBrand;
    _carModel = carModel;
    _profileImage = profileImage;
}

  DetailsDataModel.fromJson(dynamic json) {
    _userId = json['user_id'];
    _name = json['name'];
    _email = json['email'];
    _address = json['address'];
    _mobile = json['mobile'];
    _carName = json['car_name'];
    _carBrand = json['car_brand'];
    _carModel = json['car_model'];
    _profileImage = json['profile_image'];
  }
  num? _userId;
  String? _name;
  String? _email;
  String? _address;
  String? _mobile;
  String? _carName;
  String? _carBrand;
  String? _carModel;
  String? _profileImage;
  DetailsDataModel copyWith({  num? userId,
  String? name,
  String? email,
  String? address,
  String? mobile,
  String? carName,
  String? carBrand,
  String? carModel,
  String? profileImage,
}) => DetailsDataModel(  userId: userId ?? _userId,
  name: name ?? _name,
  email: email ?? _email,
  address: address ?? _address,
  mobile: mobile ?? _mobile,
  carName: carName ?? _carName,
  carBrand: carBrand ?? _carBrand,
  carModel: carModel ?? _carModel,
  profileImage: profileImage ?? _profileImage,
);
  num? get userId => _userId;
  String? get name => _name;
  String? get email => _email;
  String? get address => _address;
  String? get mobile => _mobile;
  String? get carName => _carName;
  String? get carBrand => _carBrand;
  String? get carModel => _carModel;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['email'] = _email;
    map['address'] = _address;
    map['mobile'] = _mobile;
    map['car_name'] = _carName;
    map['car_brand'] = _carBrand;
    map['car_model'] = _carModel;
    map['profile_image'] = _profileImage;
    return map;
  }

}