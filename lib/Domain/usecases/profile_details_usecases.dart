import 'package:ats_app/Data/model/request_model/profile_details_req_model.dart';
import 'package:ats_app/Domain/entities/profile_details_entity.dart';
import 'package:ats_app/Domain/repositories/profile_details_repository.dart';


class ProfileDetailsUseCases {
  ProfileDetailsRepository profileDetailsRepository;

  ProfileDetailsUseCases({required this.profileDetailsRepository});

  Future<ProfileDetailsEntity> execute(ProfileDetailsReqModel profileDetailsReqModel){
    return profileDetailsRepository.profileDetailsApi(profileDetailsReqModel);
  }
}