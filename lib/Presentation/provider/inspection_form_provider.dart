
// ─────────────────────────────────────────────
//  FILE: lib/inspection_provider.dart
// ─────────────────────────────────────────────

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Data/model/response_model/inspection_que_model.dart';
import '../../../Domain/entities/inspection_que_entity.dart';
import '../../../Domain/usecases/inspection_que_usecases.dart';
import '../../../widgets/custom_loader.dart';
import '../screens/pre_inspection_form/answer_models.dart';

// ─── Answer State ────────────────────────────

enum AnswerState { unanswered, Pass, Fail }

class QuestionAnswer {
  final CarData carData;
  AnswerState answer;
  File? imagePath;

  QuestionAnswer({required this.carData, this.answer = AnswerState.unanswered});
}

class CategoryState {
  final String title;
  final List<QuestionAnswer> questions;
  bool isExpanded;

  CategoryState({
    required this.title,
    required this.questions,
    this.isExpanded = false,
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

// ─────────────────────────────────────────────
//  PROVIDER
// ─────────────────────────────────────────────

class InspectionFormProvider extends ChangeNotifier {
  InspectionQueUseCases inspectionQueUseCases;

  InspectionFormProvider({required this.inspectionQueUseCases});

  static const String _apiUrl =
      'https://3l4vre4apl.execute-api.ap-south-1.amazonaws.com/dev/getPreInspectionQuestions';

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  InspectionQueEntity? _model;
  List<SectionState> _sections = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  InspectionQueEntity?  get model => _model;
  List<SectionState> get sections => _sections;

  int get grandTotalAnswered => _sections.fold(0, (sum, s) => sum + s.totalAnswered);
  int get grandTotalQuestions => _sections.fold(0, (sum, s) => sum + s.totalQuestions);
  bool get isFullyComplete => grandTotalQuestions > 0 && grandTotalAnswered == grandTotalQuestions;

  // ── Fetch API ─────────────────────────────

  Future<void> fetchInspectionData() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _sections = [];
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
          'API Error: ${_model?.message ?? 'status=false or data=null'}',
        );
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


  // ── Build Sections ────────────────────────

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

  List<CategoryState> _buildFromPreInspection(List<PreInspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? [])
            .map((q) => QuestionAnswer(carData: q))
            .toList(),
      )).toList();

  List<CategoryState> _buildFromInspection(List<Inspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? [])
            .map((q) => QuestionAnswer(carData: q))
            .toList(),
      )).toList();

  List<CategoryState> _buildFromPostInspection(List<PostInspection> raw) =>
      raw.map((cat) => CategoryState(
        title: cat.title ?? 'Unknown',
        questions: (cat.carData ?? [])
            .map((q) => QuestionAnswer(carData: q))
            .toList(),
      )).toList();

  // ── Answer ────────────────────────────────

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
  }) {
    _sections[sectionIndex].categories[categoryIndex]
        .questions[questionIndex].imagePath = image;
    notifyListeners();
  }

  void removeQuestionImage({
    required int sectionIndex,
    required int categoryIndex,
    required int questionIndex,
  }) {
    _sections[sectionIndex].categories[categoryIndex]
        .questions[questionIndex].imagePath = null;
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
    notifyListeners();
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
              imagePath: q.imagePath?.path ?? '',
            ));
          }
        }
      }
    }
    return result;
  }


  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    debugPrint('→ PROVIDER ERROR: $message');
  }
}