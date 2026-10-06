import '../../../provider/inspection_form_provider.dart';

/// Display-only rules for the inspection screen. They read the provider's
/// state and never change it.

/// Whether [q] is shown under the selected question filter. Same rules as
/// `InspectionFormProvider.filteredSections`; applied while rendering so the
/// visible/original index mapping used for answering stays untouched.
bool matchesQuestionFilter(QuestionAnswer q, QuestionFilter filter) {
  switch (filter) {
    case QuestionFilter.answered:
      return q.answer != AnswerState.unanswered;
    case QuestionFilter.unanswered:
      return q.answer == AnswerState.unanswered;
    case QuestionFilter.no:
      return q.answer == AnswerState.Fail;
    case QuestionFilter.all:
      return true;
  }
}

/// Severity shown next to an answer. Mirrors the value sent on save
/// (`ConfirmationDialog`: Fail → "High", otherwise "Low"); only "High" is
/// surfaced in the UI because it is the one that needs attention.
String? severityLabel(AnswerState answer) =>
    answer == AnswerState.Fail ? 'High severity' : null;
