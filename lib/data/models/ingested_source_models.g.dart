// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingested_source_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngestedSourceImpl _$$IngestedSourceImplFromJson(Map<String, dynamic> json) =>
    _$IngestedSourceImpl(
      id: json['id'] as String,
      type: $enumDecode(_$IngestedSourceTypeEnumMap, json['type']),
      name: json['name'] as String,
      content: json['content'] as String,
      status: $enumDecode(_$IngestionStatusEnumMap, json['status']),
      draftedLesson: json['draftedLesson'] == null
          ? null
          : Lesson.fromJson(json['draftedLesson'] as Map<String, dynamic>),
      draftedQuestions:
          (json['draftedQuestions'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      draftedRevisionCards:
          (json['draftedRevisionCards'] as List<dynamic>?)
              ?.map((e) => RevisionCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$IngestedSourceImplToJson(
  _$IngestedSourceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$IngestedSourceTypeEnumMap[instance.type]!,
  'name': instance.name,
  'content': instance.content,
  'status': _$IngestionStatusEnumMap[instance.status]!,
  'draftedLesson': instance.draftedLesson,
  'draftedQuestions': instance.draftedQuestions,
  'draftedRevisionCards': instance.draftedRevisionCards,
};

const _$IngestedSourceTypeEnumMap = {
  IngestedSourceType.file: 'file',
  IngestedSourceType.url: 'url',
};

const _$IngestionStatusEnumMap = {
  IngestionStatus.pending: 'pending',
  IngestionStatus.approved: 'approved',
  IngestionStatus.rejected: 'rejected',
};
