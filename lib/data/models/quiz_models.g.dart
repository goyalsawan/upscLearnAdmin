// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizDataImpl _$$QuizDataImplFromJson(Map<String, dynamic> json) =>
    _$QuizDataImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizDataImplToJson(_$QuizDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions,
    };

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctOptionIndex: (json['correctOptionIndex'] as num).toInt(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionText': instance.questionText,
      'options': instance.options,
      'correctOptionIndex': instance.correctOptionIndex,
      'explanation': instance.explanation,
    };

_$RevisionCardImpl _$$RevisionCardImplFromJson(Map<String, dynamic> json) =>
    _$RevisionCardImpl(
      heading: json['heading'] as String,
      body: json['body'] as String,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$$RevisionCardImplToJson(_$RevisionCardImpl instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'body': instance.body,
      'tip': instance.tip,
    };

_$RevisionDataImpl _$$RevisionDataImplFromJson(Map<String, dynamic> json) =>
    _$RevisionDataImpl(
      cards: (json['cards'] as List<dynamic>)
          .map((e) => RevisionCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      recapQuestions: (json['recapQuestions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RevisionDataImplToJson(_$RevisionDataImpl instance) =>
    <String, dynamic>{
      'cards': instance.cards,
      'recapQuestions': instance.recapQuestions,
    };
