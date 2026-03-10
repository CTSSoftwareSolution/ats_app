


import '../../Data/model/response_model/lane_list_model.dart';

class LaneListEntity {
  bool? success;
  String? message;
  List<LaneListData>? data;
  LaneListEntity({this.success, this.message, this.data});
}