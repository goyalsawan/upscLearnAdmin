// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubjectImpl _$$SubjectImplFromJson(Map<String, dynamic> json) =>
    _$SubjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      units: (json['units'] as List<dynamic>)
          .map((e) => Unit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SubjectImplToJson(_$SubjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconName': instance.iconName,
      'units': instance.units,
    };

_$UnitImpl _$$UnitImplFromJson(Map<String, dynamic> json) => _$UnitImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  modules: (json['modules'] as List<dynamic>)
      .map((e) => Module.fromJson(e as Map<String, dynamic>))
      .toList(),
  revision: RevisionData.fromJson(json['revision'] as Map<String, dynamic>),
  quiz: QuizData.fromJson(json['quiz'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UnitImplToJson(_$UnitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'modules': instance.modules,
      'revision': instance.revision,
      'quiz': instance.quiz,
    };

_$ModuleImpl _$$ModuleImplFromJson(Map<String, dynamic> json) => _$ModuleImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
  revision: RevisionData.fromJson(json['revision'] as Map<String, dynamic>),
  quiz: QuizData.fromJson(json['quiz'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ModuleImplToJson(_$ModuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lessons': instance.lessons,
      'revision': instance.revision,
      'quiz': instance.quiz,
    };

_$LessonCardImpl _$$LessonCardImplFromJson(Map<String, dynamic> json) =>
    _$LessonCardImpl(
      heading: json['heading'] as String,
      body: json['body'] as String,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$$LessonCardImplToJson(_$LessonCardImpl instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'body': instance.body,
      'tip': instance.tip,
    };

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  readingTimeMinutes: (json['readingTimeMinutes'] as num).toInt(),
  cards:
      (json['cards'] as List<dynamic>?)
          ?.map((e) => LessonCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'readingTimeMinutes': instance.readingTimeMinutes,
      'cards': instance.cards,
    };
