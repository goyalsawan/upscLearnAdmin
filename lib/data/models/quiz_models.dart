import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_models.freezed.dart';
part 'quiz_models.g.dart';

@freezed
class QuizData with _$QuizData {
  const factory QuizData({
    required String id,
    required String title,
    required List<QuizQuestion> questions,
  }) = _QuizData;

  factory QuizData.fromJson(Map<String, dynamic> json) => _$QuizDataFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const QuizQuestion._();

  const factory QuizQuestion({
    required String id,
    required String questionText,
    required List<String> options,
    required int correctOptionIndex,
    required String explanation,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

  Map<String, dynamic> toMap(String parentId, String parentType) {
    return {
      'id': id,
      'parent_id': parentId,
      'parent_type': parentType,
      'question_text': questionText,
      'options': options.join('|'),
      'correct_option_index': correctOptionIndex,
      'explanation': explanation,
    };
  }
}

@freezed
class RevisionCard with _$RevisionCard {
  const factory RevisionCard({
    required String heading,
    required String body,
    String? tip,
  }) = _RevisionCard;

  factory RevisionCard.fromJson(Map<String, dynamic> json) => _$RevisionCardFromJson(json);
}

@freezed
class RevisionData with _$RevisionData {
  const factory RevisionData({
    required List<RevisionCard> cards,
    required List<QuizQuestion> recapQuestions,
  }) = _RevisionData;

  factory RevisionData.fromJson(Map<String, dynamic> json) => _$RevisionDataFromJson(json);
}
