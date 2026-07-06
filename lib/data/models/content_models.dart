import 'package:freezed_annotation/freezed_annotation.dart';
import 'quiz_models.dart';

part 'content_models.freezed.dart';
part 'content_models.g.dart';

@freezed
class Subject with _$Subject {
  const factory Subject({
    required String id,
    required String name,
    required String description,
    required String iconName,
    required List<Unit> units,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
}

@freezed
class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String name,
    required String description,
    required List<Module> modules,
    required RevisionData revision,
    required QuizData quiz,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}

@freezed
class Module with _$Module {
  const factory Module({
    required String id,
    required String name,
    required String description,
    required List<Lesson> lessons,
    required RevisionData revision,
    required QuizData quiz,
  }) = _Module;

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
}

@freezed
class LessonCard with _$LessonCard {
  const factory LessonCard({
    required String heading,
    required String body,
    String? tip,
  }) = _LessonCard;

  factory LessonCard.fromJson(Map<String, dynamic> json) => _$LessonCardFromJson(json);
}

@freezed
class Lesson with _$Lesson {
  const Lesson._();

  const factory Lesson({
    required String id,
    required String name,
    required String description,
    required int readingTimeMinutes,
    @Default([]) List<LessonCard> cards,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  String get content {
    final buffer = StringBuffer();
    for (final card in cards) {
      buffer.writeln('## ${card.heading}');
      buffer.writeln(card.body);
      if (card.tip != null) {
        buffer.writeln('\n> ${card.tip}\n');
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  Map<String, dynamic> toMap(String moduleId) {
    return {
      'id': id,
      'module_id': moduleId,
      'name': name,
      'description': description,
      'reading_time_minutes': readingTimeMinutes,
    };
  }
}
