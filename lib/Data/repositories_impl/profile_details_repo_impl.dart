import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/profile_details_req_model.dart';
import 'package:ats_app/Domain/entities/profile_details_entity.dart';
import 'package:ats_app/Domain/repositories/profile_details_repository.dart';
import '../../Core/network/api_services.dart';
import '../model/response_model/profile_details_res_model.dart';

class ProfileDetailsRepoImpl implements ProfileDetailsRepository{
  @override
  Future<ProfileDetailsEntity> profileDetailsApi(ProfileDetailsReqModel profileDetailsReqModel) async {
    try{
      final response = await ApiService.post(profileDetailsReqModel, profileDetailsUrl);
      final model = ProfileDetailsResModel.fromJson(response);
      return ProfileDetailsEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }

}