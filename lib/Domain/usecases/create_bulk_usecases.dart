import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Domain/entities/create_bulk_entity.dart';
import 'package:ats_app/Domain/repositories/create_bulk_repository.dart';

class CreateBulkUseCases {
  final CreateBulkRepository repository;

  CreateBulkUseCases({required this.repository});

  Future<CreateBulkEntity> execute({
    required String registrationNumber,
    required String applicationNumber,
    required String createdBy,
    required List<CreateBulkReqModel> questions,
  }) {
    return repository.aiMediaUpload(
      registrationNumber: registrationNumber,
      applicationNumber: applicationNumber,
      createdBy: createdBy,
      questions: questions,
    );
  }
}
