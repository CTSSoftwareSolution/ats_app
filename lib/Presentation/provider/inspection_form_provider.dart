import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/usecases/inspection_que_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

class InspectionFormProvider extends ChangeNotifier{
  InspectionQueUseCases inspectionQueUseCases;

  InspectionFormProvider({required this.inspectionQueUseCases});

  bool isLoading = true;

  InspectionQueEntity? inspectionQueEntity;

  Map<int, String> answers = {};
  Map<int, String> savedAnswers = {};

  bool showValidationError = false;




  Future<InspectionQueEntity?> questionListApi()async{

    isLoading = true;

    try {
      inspectionQueEntity = await inspectionQueUseCases.execute();
      return inspectionQueEntity;
    } catch (e) {
      inspectionQueEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  void setAnswer(int questionId, String value) {
    answers[questionId] = value;
    notifyListeners();
  }

  void clearAnswer(){
    answers.clear();
    notifyListeners();
  }

  void loadPreviousAnswers(Map<int, String> previousAnswers) {
    answers = Map.from(previousAnswers);
    notifyListeners();
  }

  // bool areAllQuestionsAnswered() {
  //   if (inspectionQueEntity?.data == null) return false;
  //
  //   for (var section in inspectionQueEntity!.data!) {
  //     for (var question in section.carData!) {
  //       int qId = int.parse(question.questionId.toString());
  //       if (!answers.containsKey(qId) || answers[qId] == null) {
  //         return false;
  //       }
  //     }
  //   }
  //   return true;
  // }


}