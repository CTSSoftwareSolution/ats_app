

import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';

class ValidationError {
  final String itemRef;
  final String itemName;
  final String message;
  const ValidationError({
    required this.itemRef,
    required this.itemName,
    required this.message,
  });
}

class InspectionValidator {
  /// Validates all items in sections against config rules.
  /// Returns list of errors — empty means valid.
  static List<ValidationError> validate(
      List<InspectionSection> sections, AppConfig config) {
    final errors = <ValidationError>[];

    for (final section in sections) {
      for (final item in section.items) {
        // Skip unanswered items
        if (item.result == InspectionResult.none) continue;

        final hasMedia = item.media.isNotEmpty;
        final hasComment = item.observation.trim().isNotEmpty;

        // Rule: any result needs media
        if (config.requireMediaOnAnyResult && !hasMedia) {
          errors.add(ValidationError(
            itemRef:  item.ref,
            itemName: item.name,
            message:  'Requires at least one photo or video',
          ));
          continue;
        }

        if (item.result == InspectionResult.pass) {
          // Rule: pass needs media
          if (config.requireMediaForPass && !hasMedia) {
            errors.add(ValidationError(
              itemRef:  item.ref,
              itemName: item.name,
              message:  'Pass result requires at least one photo or video',
            ));
          }
        }

        if (item.result == InspectionResult.fail) {
          // Rule: fail needs media
          if (config.requireMediaForFail && !hasMedia) {
            errors.add(ValidationError(
              itemRef:  item.ref,
              itemName: item.name,
              message:  'Fail result requires at least one photo or video',
            ));
          }
          // Rule: fail needs comment
          if (config.requireCommentForFail && !hasComment) {
            errors.add(ValidationError(
              itemRef:  item.ref,
              itemName: item.name,
              message:  'Fail result requires an observation comment',
            ));
          }
        }
      }
    }

    return errors;
  }

  /// Check unanswered items
  static List<InspectionItem> unanswered(List<InspectionSection> sections) {
    return sections
        .expand((s) => s.items)
        .where((i) => i.result == InspectionResult.none)
        .toList();
  }
}
