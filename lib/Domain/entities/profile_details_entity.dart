import '../../Data/model/response_model/profile_details_res_model.dart';

class ProfileDetailsEntity {
  bool? status;
  String? message;
  List<DetailsDataModel>? data;

  ProfileDetailsEntity({this.data, this.status, this.message});
}