import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Domain/entities/slider_entity.dart';
import 'package:ats_app/Domain/repositories/slider_repository.dart';


import '../../Core/network/api_services.dart';

import '../model/response_model/slider_res_model.dart';

class SliderRepoImpl implements SliderRepository{
  @override
  Future<SliderEntity> sliderApi() async{
   // final baseUrl = context.read<IpAddressProvider>().baseUrl;
    try{
      final response = await ApiService.post("", sliderUrl);
      final model = SliderResModel.fromJson(response);
      return SliderEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}