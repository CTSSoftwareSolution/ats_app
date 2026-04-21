import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

import '../../../Domain/usecases/document_manual_doc_usecase.dart';
import 'DocumentManualDocModels.dart';


class ManualInsImageProvider extends ChangeNotifier {
  final DocumentManualDocUseCase useCase;

  ManualInsImageProvider({required this.useCase});

  Future<void> uploadDocuments({
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,
  }) async {
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      await useCase.execute(
        appointmentId: appointmentId,
        createdBy: createdBy,
        vehicleId: vehicleId,
        documents: documents,
      );
    } catch (e) {
      CustomLoader.closeLoader();
    }
    CustomLoader.closeLoader();
    notifyListeners();
  }
}
