

import '../../Presentation/screens/manual_inspection_images/DocumentManualDocModels.dart';
import '../entities/document_manual_doc_entity.dart';
import '../repositories/manual_doc_inspection_upload_repository.dart';

class DocumentManualDocUseCase {

  final DocumentManualDocRepository repository;

  DocumentManualDocUseCase({required this.repository});

  Future<DocumentManualDocEntity> execute({
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,
  }) {

    return repository.uploadDocuments(
      appointmentId: appointmentId,
      createdBy: createdBy,
      vehicleId: vehicleId,
      documents: documents,
    );
  }
}