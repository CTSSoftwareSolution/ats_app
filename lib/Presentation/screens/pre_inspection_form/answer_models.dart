class QuestionAnswerModel {
  QuestionAnswerModel({
    String? questionId,
    String? questionText,
    String? answer,
    String? imagePath,
  }) {
    _questionId = questionId;
    _questionText = questionText;
    _answer = answer;
    _imagePath = imagePath;
  }

  QuestionAnswerModel.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _questionText = json['question_text'];
    _answer = json['answer'];
    _imagePath = json['image_path'];
  }

  String? _questionId;
  String? _questionText;
  String? _answer;
  String? _imagePath;

  QuestionAnswerModel copyWith({
    String? questionId,
    String? questionText,
    String? answer,
    String? imagePath,
  }) =>
      QuestionAnswerModel(
        questionId: questionId ?? _questionId,
        questionText: questionText ?? _questionText,
        answer: answer ?? _answer,
        imagePath: imagePath ?? _imagePath,
      );

  String? get questionId => _questionId;
  String? get questionText => _questionText;
  String? get answer => _answer;
  String? get imagePath => _imagePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    map['answer'] = _answer;
    map['image_path'] = _imagePath;
    return map;
  }

  @override
  String toString() {
    return 'QuestionAnswerModel(questionId: $_questionId, questionText: $_questionText, answer: $_answer, imagePath: $_imagePath)';
  }
}