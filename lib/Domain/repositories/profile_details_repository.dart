import 'package:ats_app/Data/model/request_model/profile_details_req_model.dart';
import 'package:ats_app/Domain/entities/profile_details_entity.dart';


abstract class ProfileDetailsRepository {
  Future<ProfileDetailsEntity> profileDetailsApi(ProfileDetailsReqModel profileDetailsReqModel);
}