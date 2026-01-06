import 'package:ats_app/Domain/entities/profile_details_entity.dart';
import 'package:ats_app/Domain/usecases/profile_details_usecases.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Data/model/request_model/profile_details_req_model.dart';
import '../../widgets/custom_loader.dart';

class ProfileDetailsProvider extends ChangeNotifier{
  ProfileDetailsUseCases profileDetailsUseCases;

  ProfileDetailsProvider({required this.profileDetailsUseCases});

  bool switchValue = true;
  bool isLoading = true;
  String appVersion = "Unknown";

  ProfileDetailsEntity? profileDetailsEntity;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final carNameController = TextEditingController();
  final carBrandController = TextEditingController();
  final carModelController = TextEditingController();
   String? imageUrl;
  Future<ProfileDetailsEntity?> profileDetailsApi(BuildContext context)async{
    isLoading = true;
    try {
      ProfileDetailsReqModel profileDetailsReqModel = ProfileDetailsReqModel(
          userId: Preferences.getUserId()
      );
      profileDetailsEntity = await profileDetailsUseCases.execute(profileDetailsReqModel);
      showProfileDetails();
      return profileDetailsEntity;
    } catch (e) {
      profileDetailsEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  void showProfileDetails() {
    final userData = profileDetailsEntity?.data![0];

    if (userData != null) {
      nameController.text = userData.name.toString();
     mobileController.text = userData.mobile.toString();
      emailController.text = userData.email.toString();
      addressController.text = userData.address.toString();
      carNameController.text = userData.carName.toString();
      carBrandController.text = userData.carBrand.toString();
      carModelController.text = userData.carModel.toString();
      imageUrl = userData.profileImage.toString();
    }
  }



  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      appVersion = 'Version: ${packageInfo.version}';

    } catch (e) {

      appVersion = 'Error';
    }
    notifyListeners();
  }
}