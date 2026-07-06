import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_models.dart';
import 'quiz_models.dart';

part 'ingested_source_models.freezed.dart';
part 'ingested_source_models.g.dart';

enum IngestedSourceType { file, url }
enum IngestionStatus { pending, approved, rejected }

@freezed
class IngestedSource with _$IngestedSource {
  const factory IngestedSource({
    required String id,
    required IngestedSourceType type,
    required String name,
    required String content,
    required IngestionStatus status,
    Lesson? draftedLesson,
    @Default([]) List<QuizQuestion> draftedQuestions,
    @Default([]) List<RevisionCard> draftedRevisionCards,
  }) = _IngestedSource;

  factory IngestedSource.fromJson(Map<String, dynamic> json) => _$IngestedSourceFromJson(json);
}
