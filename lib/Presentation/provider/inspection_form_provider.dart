import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ats_app/Data/model/response_model/pre_inspection_details_model.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Data/model/response_model/inspection_que_model.dart';
import '../../../Domain/entities/inspection_que_entity.dart';
import '../../../Domain/usecases/inspection_que_usecases.dart';
import '../../Core/network/services.dart';
import '../screens/pre_inspection_form/answer_models.dart';

/// Answer State
enum AnswerState { unanswered, Pass, Fail }

/// Filter State
enum QuestionFilter { all, answered, unanswered, no }

class QuestionAnswer {
  final CarData carData;
  AnswerState answer;
  File? imagePath;
  String? uploadedImageUrl;
  String? existingEvidenceUrl;
  String? remark;

  QuestionAnswer({required this.carData, this.answer = AnswerState.unanswered});
}

class CategoryState {
  final String title;
  final List<QuestionAnswer> questions;
  bool isExpanded;

  CategoryState({
    required this.title,
    required this.questions,
    this.isExpanded = true,
  });

  int get answeredCount =>
      questions.where((q) => q.answer != AnswerState.unanswered).length;
  int get totalCount => questions.length;
  double get progress => totalCount == 0 ? 0.0 : answeredCount / totalCount;
  bool get allPassed =>
      questions.every((q) => q.answer == AnswerState.Pass) &&
          answeredCount == totalCount;
  bool get hasFailed => questions.any((q) => q.answer == AnswerState.Fail);
  bool get isComplete => answeredCount == totalCount;
}

class SectionState {
  final String label;
  final String subtitle;
  final Color color;
  final IconData icon;
  final List<CategoryState> categories;

  SectionState({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.categories,
  });

  int get totalAnswered =>
      categories.fold(0, (sum, c) => sum + c.answeredCount);
  int get totalQuestions =>
      categories.fold(0, (sum, c) => sum + c.totalCount);
  double get overallProgress =>
      totalQuestions == 0 ? 0.0 : totalAnswered / totalQuestions;
  bool get isComplete => totalAnswered == totalQuestions;
}

///  PROVIDER
class InspectionFormProvider extends ChangeNotifier {
  InspectionQueUseCases inspectionQueUseCases;
  InspectionFormProvider({required this.inspectionQueUseCases});

  // static const String _editApiUrl =
  //     'https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev/getPreInspectionDetailsByVehicleID';

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

  int get grandTotalAnswered => _sections.fold(0, (sum, s) => sum + s.totalAnswered);
  int get grandTotalQuestions => _sections.fold(0, (sum, s) => sum + s.totalQuestions);
  bool get isFullyComplete => grandTotalQuestions > 0 && grandTotalAnswered == grandTotalQuestions;
  int get grandTotalNo => _sections.fold(
      0, (sum, s) =>
  sum + s.categories.fold(0, (cSum, c) => cSum + c.questions.where((q) => q.answer == AnswerState.Fail).length));

  //  Auto Scroll
  void registerQuestionKey(int sec, int cat, int que, GlobalKey key) {
    _questionKeys['$sec-$cat-$que'] = key;
  }

  GlobalKey? nextUnansweredKey(int sec, int cat, int que) {
    final section = _sections[sec];

    final sameCategory = section.categories[cat];
    for (int q = que + 1; q < sameCategory.questions.length; q++) {
      if (sameCategory.questions[q].answer == AnswerState.unanswered) {
        return _questionKeys['$sec-$cat-$q'];
      }
    }
    for (int c = cat + 1; c < section.categories.length; c++) {
      final nextCat = section.categories[c];
      for (int q = 0; q < nextCat.questions.length; q++) {
        if (nextCat.questions[q].answer == AnswerState.unanswered) {
          if (!nextCat.isExpanded) {
            nextCat.isExpanded = true;
          }
          return _questionKeys['$sec-$c-$q'];
        }
      }
    }

    return null;
  }

 // Filter
  void setFilter(QuestionFilter f) {
    _filter = f;
    notifyListeners();
  }

  List<SectionState> get filteredSections {
    if (_filter == QuestionFilter.all) return _sections;

    return _sections.map((section) {
      final filteredCats = section.categories.map((cat) {
        final filteredQs = cat.questions.where((q) {
          switch (_filter) {
            case QuestionFilter.answered:
              return q.answer != AnswerState.unanswered;
            case QuestionFilter.unanswered:
              return q.answer == AnswerState.unanswered;
            case QuestionFilter.no:
              return q.answer == AnswerState.Fail;
            case QuestionFilter.all:
              return true;
          }
        }).toList();

        return CategoryState(
          title: cat.title,
          questions: filteredQs,
          isExpanded: cat.isExpanded,
        );
      }).where((cat) => cat.questions.isNotEmpty).toList();

      return SectionState(
        label: section.label,
        subtitle: section.subtitle,
        color: section.color,
        icon: section.icon,
        categories: filteredCats,
      );
    }).toList();
  }

  Future<void> fetchInspectionData() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _isEditMode = false;
    _filter = QuestionFilter.all;
    _sections = [];
    _questionKeys.clear();
    notifyListeners();

    try {
      debugPrint('→ Fetching inspection data from usecase');
      final response = await inspectionQueUseCases.execute();

      _model = response;

      if (_model?.status == true && _model?.data != null) {
        _buildSections(_model!.data!);
        debugPrint('→ Sections built: ${_sections.length}');
      } else {
        _setError(
            'API Error: ${_model?.message ?? 'status=false or data=null'}');
      }
    } on TimeoutException {
      _setError('Request timed out. Check internet connection.');
    } on SocketException catch (e) {
      _setError('No internet connection: ${e.message}');
    } on FormatException catch (e) {
      _setError('Data parse error: ${e.message}');
    } catch (e, stack) {
      debugPrint('→ ERROR: $e\n$stack');
      _setError('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAndPrefill({required String vehicleNo, required String appointmentID}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _isEditMode = true;
    _filter = QuestionFilter.all;
    _sections = [];
    _questionKeys.clear();
    notifyListeners();

    try {
      debugPrint('→ [EditMode] Fetching for vehicle: $vehicleNo $appointmentID');

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${Preferences.getToken()}',
      };

      final response = await http.post(
        Uri.parse(preInspectionDetails),
        headers: headers,
        body: jsonEncode({
          'vehicle_id': vehicleNo,
          'appointment_id': appointmentID,
        }),
      ).timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        alice.onHttpResponse(
            response,  body: jsonEncode({
          'vehicle_id': vehicleNo,
          'appointment_id': appointmentID,
        }));
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final editModel = PreInspectionDetailsModels.fromJson(decoded);

        if (editModel.status == true && editModel.data != null) {
          _buildSectionsFromDetailsModel(editModel.data!);
          debugPrint('→ [EditMode] Sections built: ${_sections.length}');
        } else {
          _setError(editModel.message ?? 'status=false or data=null');
        }
      } else {
        _setError('HTTP Error ${response.statusCode}');
      }
    } on TimeoutException {
      _setError('Request timed out. Check internet connection.');
    } on SocketException catch (e) {
      _setError('No internet connection: ${e.message}');
    } on FormatException catch (e) {
      _setError('Data parse error: ${e.message}');
    } catch (e, stack) {
      debugPrint('→ [EditMode] ERROR: $e\n$stack');
      _setError('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _buildSections(InspectorData data) {
    _sections = [
      SectionState(
        label: 'Pre-Inspection',
        subtitle: 'Before vehicle enters',
        color: const Color(0xFF0D7377),
        icon: Icons.assignment_turned_in_outlined,
        categories: _buildFromPreInspection(data.preInspection ?? []),
      ),
      SectionState(
        label: 'Inspection',
        subtitle: 'Main vehicle check',
        color: const Color(0xFF1A3C6E),
        icon: Icons.directions_car_outlined,
        categories: _buildFromInspection(data.inspection ?? []),
      ),
      SectionState(
        label: 'Post-Inspection',
        subtitle: 'After vehicle exits',
        color: const Color(0xFF7B2D8B),
        icon: Icons.task_alt_outlined,
        categories: _buildFromPostInspection(data.postInspection ?? []),
      ),
    ];
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

  List<CategoryState> _buildFromPreInspection(List<PreInspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? []).map((q) => QuestionAnswer(carData: q)).toList(),
      )).toList();

  List<CategoryState> _buildFromInspection(List<Inspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? []).map((q) => QuestionAnswer(carData: q)).toList(),
      )).toList();

  List<CategoryState> _buildFromPostInspection(List<PostInspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? []).map((q) => QuestionAnswer(carData: q)).toList(),
      )).toList();

  void answerQuestion({
    required int sectionIndex,
    required int categoryIndex,
    required int questionIndex,
    required AnswerState answer,
  }) {
    final q = _sections[sectionIndex].categories[categoryIndex].questions[questionIndex];
    q.answer = q.answer == answer ? AnswerState.unanswered : answer;
    if (q.answer != AnswerState.Fail) q.imagePath = null;
    notifyListeners();
  }

  void setQuestionImage({
    required int sectionIndex,
    required int categoryIndex,
    required int questionIndex,
    required File? image,
    required String? uploadedUrl,
  }) {
    _sections[sectionIndex].categories[categoryIndex].questions[questionIndex].imagePath = image;
    _sections[sectionIndex].categories[categoryIndex].questions[questionIndex].uploadedImageUrl = uploadedUrl;
    notifyListeners();
  }

  void setQuestionRemark({
    required int sectionIndex,
    required int categoryIndex,
    required int questionIndex,
    required String remark,
  }) {
    _sections[sectionIndex].categories[categoryIndex].questions[questionIndex].remark = remark;
    notifyListeners();
  }

  void removeQuestionImage({
    required int sectionIndex,
    required int categoryIndex,
    required int questionIndex,
  }) {
    final q = _sections[sectionIndex].categories[categoryIndex].questions[questionIndex];
    q.imagePath = null;
    q.uploadedImageUrl = null;
    q.existingEvidenceUrl = null;
    notifyListeners();
  }

  void toggleCategory(int sectionIndex, int categoryIndex) {
    _sections[sectionIndex].categories[categoryIndex].isExpanded =
    !_sections[sectionIndex].categories[categoryIndex].isExpanded;
    notifyListeners();
  }

  void resetAll() {
    for (final s in _sections) {
      for (final c in s.categories) {
        for (final q in c.questions) {
          q.answer = AnswerState.unanswered;
          q.imagePath = null;
        }
        c.isExpanded = false;
      }
    }
    _filter = QuestionFilter.all;
    _questionKeys.clear();
    notifyListeners();
  }

  int originalSectionIndex(int filteredSectionIdx) {
    final filteredSection = filteredSections[filteredSectionIdx];
    return _sections.indexWhere((s) => s.label == filteredSection.label);
  }

  int originalCategoryIndex(int filteredSectionIdx, int filteredCatIdx) {
    final filteredSection = filteredSections[filteredSectionIdx];
    final filteredCat = filteredSection.categories[filteredCatIdx];
    final origSectionIdx = originalSectionIndex(filteredSectionIdx);
    return _sections[origSectionIdx].categories.indexWhere((c) => c.title == filteredCat.title);
  }

  int originalQuestionIndex(int filteredSectionIdx, int filteredCatIdx, int filteredQueIdx) {
    final filteredSection = filteredSections[filteredSectionIdx];
    final filteredCat = filteredSection.categories[filteredCatIdx];
    final filteredQ = filteredCat.questions[filteredQueIdx];
    final origSectionIdx = originalSectionIndex(filteredSectionIdx);
    final origCatIdx = originalCategoryIndex(filteredSectionIdx, filteredCatIdx);
    return _sections[origSectionIdx].categories[origCatIdx].questions
        .indexWhere((q) => q.carData.questionId == filteredQ.carData.questionId);
  }

  List<QuestionAnswerModel> collectAnswers() {
    final result = <QuestionAnswerModel>[];
    for (final section in _sections) {
      for (final cat in section.categories) {
        for (final q in cat.questions) {
          if (q.answer != AnswerState.unanswered) {
            result.add(QuestionAnswerModel(
              questionId: q.carData.questionId?.toString() ?? '',
              questionText: q.carData.questionText ?? '',
              answer: q.answer.name,
              imagePath: q.uploadedImageUrl ?? q.existingEvidenceUrl ?? '',
              remark: q.remark ?? '',
            ));
          }
        }
      }
    }
    return result;
  }

  void loadFromDetailsModel(PreInspectionDetailsData data) {
    _isEditMode = true;
    _sections = [];
    _questionKeys.clear();

    _buildSectionsFromDetailsModel(data);

    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    debugPrint('→ PROVIDER ERROR: $message');
  }
}