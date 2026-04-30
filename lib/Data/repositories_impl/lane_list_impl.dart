import 'package:ats_app/Data/model/response_model/lane_list_model.dart';
import 'package:ats_app/Domain/entities/lane_list_entity.dart';
import 'package:ats_app/Domain/repositories/lane_list_repository.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';

class LaneListImpl implements LaneListRepository{

  @override
  Future<LaneListEntity> laneListApi() async{
    try{
      final response = await ApiService.post("", laneList);
      final model = LaneListModel.fromJson(response);
      return LaneListEntity(message: model.message, success: model.success, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}