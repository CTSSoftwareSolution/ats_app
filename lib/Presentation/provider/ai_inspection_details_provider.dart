import 'package:ats_app/Domain/usecases/ai_inspection_details_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/model/request_model/pre_inspection_details_req_model.dart';
import '../../Data/model/response_model/inspection_que_model.dart';
import '../../Data/model/response_model/pre_inspection_details_model.dart';
import '../../Domain/entities/inspection_que_entity.dart';
import '../../Domain/entities/pre_inspection_details_entity.dart';
import '../../widgets/custom_loader.dart';
import 'inspection_form_provider.dart';

class AiInspectionDetailsProvider extends ChangeNotifier{
  AIInspectionDetailsUseCases aiInspectionDetailsUseCases;

  AiInspectionDetailsProvider({required this.aiInspectionDetailsUseCases});

  PreInspectionDetailsEntity? aiDetailsEntity;

  // bool isLoading = false;

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  InspectionQueEntity? _model;
  List<SectionState> _sections = [];
  bool _isEditMode = false;
  QuestionFilter _filter = QuestionFilter.all;

  // ── Auto-scroll: GlobalKey registry ──────────
  final Map<String, GlobalKey> _questionKeys = {};

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  InspectionQueEntity? get model => _model;
  List<SectionState> get sections => _sections;
  bool get isEditMode => _isEditMode;
  QuestionFilter get filter => _filter;


  Future<PreInspectionDetailsEntity?> aiInspectionDetails(BuildContext context) async{


    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    try {
      PreInspectionDetailsReqModel detailsReqModel = PreInspectionDetailsReqModel(
          vehicleId: classProvider.selectedClass?.registrationNo,
        appointmentId:  classProvider.selectedClass?.appointmentId
      );
      aiDetailsEntity = await aiInspectionDetailsUseCases.execute(detailsReqModel);
      notifyListeners();
      return aiDetailsEntity;
    } catch (e) {
      aiDetailsEntity = null;
    } finally {
      CustomLoader.closeLoader();

      notifyListeners();
    }
    return null;
  }

  Future<void> fetchAiInspectionDetails(BuildContext context) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _isEditMode = false;
    _filter = QuestionFilter.all;
    _sections = [];
    _questionKeys.clear();
    notifyListeners();

    try {
      final classProvider =
      Provider.of<VehicleClassProvider>(context, listen: false);

      debugPrint('→ [AI Mode] Fetching AI inspection details');

      final req = PreInspectionDetailsReqModel(
        vehicleId: classProvider.selectedClass?.registrationNo,
        appointmentId: classProvider.selectedClass?.appointmentId,
      );

      final aiUsecase = Provider.of<AiInspectionDetailsProvider>(
          context, listen: false);

      final result = await aiUsecase.aiInspectionDetails(context);

      if (result != null && result.data != null) {
        // 🔥 SAME BUILDER USED
        _buildSectionsFromDetailsModel(result.data!);
        debugPrint('→ [AI Mode] Sections built: ${_sections.length}');
      } else {
        _setError('AI data is null');
      }
    } catch (e, stack) {
      debugPrint('→ [AI Mode] ERROR: $e\n$stack');
      _setError('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _buildSectionsFromDetailsModel(PreInspectionDetailsData data) {
    AnswerState parseAnswer(String? r) {
      if (r == 'Pass') return AnswerState.Pass;
      if (r == 'Fail') return AnswerState.Fail;
      return AnswerState.unanswered;
    }

    QuestionAnswer fromCarDataDetails(CarDataDetails q) {
      final cd = CarData(
        questionId: q.questionId?.toInt(),
        questionText: q.questionText,
      );
      final qa = QuestionAnswer(
        carData: cd,
        answer: parseAnswer(q.inspectionResult),
      );
      qa.existingEvidenceUrl = q.evidenceFileViewUrl;
      return qa;
    }

    _sections = [
      SectionState(
        label: 'Pre-Inspection',
        subtitle: 'Before vehicle enters',
        color: const Color(0xFF0D7377),
        icon: Icons.assignment_turned_in_outlined,
        categories: (data.preInspection ?? [])
            .map((cat) => CategoryState(
          title: cat.title ?? 'Unknown',
          questions: (cat.carData ?? []).map(fromCarDataDetails).toList(),
        ))
            .toList(),
      ),
      SectionState(
        label: 'Inspection',
        subtitle: 'Main vehicle check',
        color: const Color(0xFF1A3C6E),
        icon: Icons.directions_car_outlined,
        categories: (data.inspection ?? [])
            .map((cat) => CategoryState(
          title: cat.title ?? 'Unknown',
          questions: (cat.carData ?? []).map(fromCarDataDetails).toList(),
        ))
            .toList(),
      ),
      SectionState(
        label: 'Post-Inspection',
        subtitle: 'After vehicle exits',
        color: const Color(0xFF7B2D8B),
        icon: Icons.task_alt_outlined,
        categories: (data.postInspection ?? [])
            .map((cat) => CategoryState(
          title: cat.title ?? 'Unknown',
          questions: (cat.carData ?? []).map(fromCarDataDetails).toList(),
        ))
            .toList(),
      ),
    ];

  }