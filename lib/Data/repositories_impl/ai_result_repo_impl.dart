// import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
// import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
// import 'package:ats_app/Domain/entities/ai_result_entity.dart';
// import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
// import 'package:ats_app/Domain/repositories/ai_result_repository.dart';
// import 'package:ats_app/Domain/repositories/inspection_new_que_repository.dart';
// import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';
// import '../../Core/network/api_services.dart';
// import '../../Core/network/services.dart';
// import '../../Domain/entities/inspection_new_que_entity.dart';
// import '../model/response_model/inspection_new_que_model.dart';
//
//
// class AiResultRepoImpl implements AiResultRepository{
//
//   @override
//   Future<InspectionNewQueEntity> aiResultDetails() async{
//     try{
//       final response = await ApiService.post("", newInspectionQuestionsList);
//       final model = InspectionNewQueModel.fromJson(response);
//       return InspectionNewQueEntity(message: model.message, status: model.status, data: model.data);
//     }catch (e){
//       throw Exception(e);
//     }
//   }
//
//   @override
//   Future<AiResultEntity> aiResultDetails(AiResultReqModel requestModel) {
//     // TODO: implement aiResultDetails
//     throw UnimplementedError();
//   }
//
// }