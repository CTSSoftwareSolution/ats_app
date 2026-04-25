import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Domain/usecases/create_bulk_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

class CreateBulkProvider extends ChangeNotifier {
  final CreateBulkUseCases useCases;

  CreateBulkProvider({required this.useCases});

  Future<void> uploadAIImage({
    required String registrationNumber,
    required String applicationNumber,
    required String createdBy,
    required String appointmentId,
    required List<CreateBulkReqModel> questions,
  }) async {
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try{
      await useCases.execute(registrationNumber: registrationNumber, applicationNumber: applicationNumber, createdBy: createdBy, questions: questions, appointmentId: appointmentId);
    } catch (e) {
      CustomLoader.closeLoader();
    }
    CustomLoader.closeLoader();
    notifyListeners();
  }
}
