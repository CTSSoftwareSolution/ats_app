import '../../Data/model/response_model/slider_res_model.dart';

class SliderEntity {
  bool? status;
  String? message;
  List<SliderData>? data;

  SliderEntity({this.data, this.status, this.message});
}