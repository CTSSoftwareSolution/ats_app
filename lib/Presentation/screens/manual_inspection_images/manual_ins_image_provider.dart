import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

import '../../../Domain/usecases/document_manual_doc_usecase.dart';
import 'DocumentManualDocModels.dart';
import 'package:provider/provider.dart';
import 'package:ats_app/Core/network/InternetCheck/network_status.dart';

class ManualInsImageProvider extends ChangeNotifier {
  final DocumentManualDocUseCase useCase;

  ManualInsImageProvider({required this.useCase});

  Future<void> uploadDocuments({
    required BuildContext context,
    required String appointmentId,
    required String createdBy,
    required String vehicleId,
    required List<DocumentManualDocModels> documents,
  }) async {
    final network = context.read<NetworkStatus>();
    if (!network.isConnected) {
      CustomLoader.internetMessage(
        msg: "No Internet Connection",
        context: context,
      );
      return;
    }
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
