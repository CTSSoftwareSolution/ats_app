import '../../Presentation/screens/manual_inspection_images/document_manual_doc_models.dart';
import '../entities/document_manual_doc_entity.dart';



abstract class DocumentManualDocRepository {

  Future<DocumentManualDocEntity> uploadDocuments({
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,

  });

}