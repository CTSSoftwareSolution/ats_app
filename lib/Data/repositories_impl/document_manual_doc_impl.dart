import 'package:ats_app/Presentation/screens/manual_inspection_images/DocumentManualDocModels.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/DocumentManualDocResModels.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../../Domain/entities/document_manual_doc_entity.dart';
import '../../Domain/repositories/manual_doc_inspection_upload_repository.dart';

class DocumentManualDocImpl implements DocumentManualDocRepository {

  @override
  Future<DocumentManualDocEntity> uploadDocuments({
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,

  }) async {

    try {

      final response = await ApiService.manualDocMultipartUpload(
        appointmentId: appointmentId,
        createdBy: createdBy,
        vehicleId: vehicleId,
        documents: documents,
        apiUrl: uploadImage,
      );

      final model = DocumentManualDocResModels.fromJson(response);

      return DocumentManualDocEntity(
        status: model.status,
        message: model.message,
        field: model.field,
        data: model.data,
      );

    } catch (e) {
      throw Exception(e);
    }
  }

}