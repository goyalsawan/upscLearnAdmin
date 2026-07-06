// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingested_source_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IngestedSource _$IngestedSourceFromJson(Map<String, dynamic> json) {
  return _IngestedSource.fromJson(json);
}

/// @nodoc
mixin _$IngestedSource {
  String get id => throw _privateConstructorUsedError;
  IngestedSourceType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  IngestionStatus get status => throw _privateConstructorUsedError;
  Lesson? get draftedLesson => throw _privateConstructorUsedError;
  List<QuizQuestion> get draftedQuestions => throw _privateConstructorUsedError;
  List<RevisionCard> get draftedRevisionCards =>
      throw _privateConstructorUsedError;

  /// Serializes this IngestedSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngestedSourceCopyWith<IngestedSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngestedSourceCopyWith<$Res> {
  factory $IngestedSourceCopyWith(
    IngestedSource value,
    $Res Function(IngestedSource) then,
  ) = _$IngestedSourceCopyWithImpl<$Res, IngestedSource>;
  @useResult
  $Res call({
    String id,
    IngestedSourceType type,
    String name,
    String content,
    IngestionStatus status,
    Lesson? draftedLesson,
    List<QuizQuestion> draftedQuestions,
    List<RevisionCard> draftedRevisionCards,
  });

  $LessonCopyWith<$Res>? get draftedLesson;
}

/// @nodoc
class _$IngestedSourceCopyWithImpl<$Res, $Val extends IngestedSource>
    implements $IngestedSourceCopyWith<$Res> {
  _$IngestedSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? content = null,
    Object? status = null,
    Object? draftedLesson = freezed,
    Object? draftedQuestions = null,
    Object? draftedRevisionCards = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as IngestedSourceType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as IngestionStatus,
            draftedLesson: freezed == draftedLesson
                ? _value.draftedLesson
                : draftedLesson // ignore: cast_nullable_to_non_nullable
                      as Lesson?,
            draftedQuestions: null == draftedQuestions
                ? _value.draftedQuestions
                : draftedQuestions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>,
            draftedRevisionCards: null == draftedRevisionCards
                ? _value.draftedRevisionCards
                : draftedRevisionCards // ignore: cast_nullable_to_non_nullable
                      as List<RevisionCard>,
          )
          as $Val,
    );
  }

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LessonCopyWith<$Res>? get draftedLesson {
    if (_value.draftedLesson == null) {
      return null;
    }

    return $LessonCopyWith<$Res>(_value.draftedLesson!, (value) {
      return _then(_value.copyWith(draftedLesson: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IngestedSourceImplCopyWith<$Res>
    implements $IngestedSourceCopyWith<$Res> {
  factory _$$IngestedSourceImplCopyWith(
    _$IngestedSourceImpl value,
    $Res Function(_$IngestedSourceImpl) then,
  ) = __$$IngestedSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    IngestedSourceType type,
    String name,
    String content,
    IngestionStatus status,
    Lesson? draftedLesson,
    List<QuizQuestion> draftedQuestions,
    List<RevisionCard> draftedRevisionCards,
  });

  @override
  $LessonCopyWith<$Res>? get draftedLesson;
}

/// @nodoc
class __$$IngestedSourceImplCopyWithImpl<$Res>
    extends _$IngestedSourceCopyWithImpl<$Res, _$IngestedSourceImpl>
    implements _$$IngestedSourceImplCopyWith<$Res> {
  __$$IngestedSourceImplCopyWithImpl(
    _$IngestedSourceImpl _value,
    $Res Function(_$IngestedSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? content = null,
    Object? status = null,
    Object? draftedLesson = freezed,
    Object? draftedQuestions = null,
    Object? draftedRevisionCards = null,
  }) {
    return _then(
      _$IngestedSourceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as IngestedSourceType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as IngestionStatus,
        draftedLesson: freezed == draftedLesson
            ? _value.draftedLesson
            : draftedLesson // ignore: cast_nullable_to_non_nullable
                  as Lesson?,
        draftedQuestions: null == draftedQuestions
            ? _value._draftedQuestions
            : draftedQuestions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>,
        draftedRevisionCards: null == draftedRevisionCards
            ? _value._draftedRevisionCards
            : draftedRevisionCards // ignore: cast_nullable_to_non_nullable
                  as List<RevisionCard>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IngestedSourceImpl implements _IngestedSource {
  const _$IngestedSourceImpl({
    required this.id,
    required this.type,
    required this.name,
    required this.content,
    required this.status,
    this.draftedLesson,
    final List<QuizQuestion> draftedQuestions = const [],
    final List<RevisionCard> draftedRevisionCards = const [],
  }) : _draftedQuestions = draftedQuestions,
       _draftedRevisionCards = draftedRevisionCards;

  factory _$IngestedSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngestedSourceImplFromJson(json);

  @override
  final String id;
  @override
  final IngestedSourceType type;
  @override
  final String name;
  @override
  final String content;
  @override
  final IngestionStatus status;
  @override
  final Lesson? draftedLesson;
  final List<QuizQuestion> _draftedQuestions;
  @override
  @JsonKey()
  List<QuizQuestion> get draftedQuestions {
    if (_draftedQuestions is EqualUnmodifiableListView)
      return _draftedQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_draftedQuestions);
  }

  final List<RevisionCard> _draftedRevisionCards;
  @override
  @JsonKey()
  List<RevisionCard> get draftedRevisionCards {
    if (_draftedRevisionCards is EqualUnmodifiableListView)
      return _draftedRevisionCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_draftedRevisionCards);
  }

  @override
  String toString() {
    return 'IngestedSource(id: $id, type: $type, name: $name, content: $content, status: $status, draftedLesson: $draftedLesson, draftedQuestions: $draftedQuestions, draftedRevisionCards: $draftedRevisionCards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngestedSourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.draftedLesson, draftedLesson) ||
                other.draftedLesson == draftedLesson) &&
            const DeepCollectionEquality().equals(
              other._draftedQuestions,
              _draftedQuestions,
            ) &&
            const DeepCollectionEquality().equals(
              other._draftedRevisionCards,
              _draftedRevisionCards,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    name,
    content,
    status,
    draftedLesson,
    const DeepCollectionEquality().hash(_draftedQuestions),
    const DeepCollectionEquality().hash(_draftedRevisionCards),
  );

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngestedSourceImplCopyWith<_$IngestedSourceImpl> get copyWith =>
      __$$IngestedSourceImplCopyWithImpl<_$IngestedSourceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IngestedSourceImplToJson(this);
  }
}

abstract class _IngestedSource implements IngestedSource {
  const factory _IngestedSource({
    required final String id,
    required final IngestedSourceType type,
    required final String name,
    required final String content,
    required final IngestionStatus status,
    final Lesson? draftedLesson,
    final List<QuizQuestion> draftedQuestions,
    final List<RevisionCard> draftedRevisionCards,
  }) = _$IngestedSourceImpl;

  factory _IngestedSource.fromJson(Map<String, dynamic> json) =
      _$IngestedSourceImpl.fromJson;

  @override
  String get id;
  @override
  IngestedSourceType get type;
  @override
  String get name;
  @override
  String get content;
  @override
  IngestionStatus get status;
  @override
  Lesson? get draftedLesson;
  @override
  List<QuizQuestion> get draftedQuestions;
  @override
  List<RevisionCard> get draftedRevisionCards;

  /// Create a copy of IngestedSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngestedSourceImplCopyWith<_$IngestedSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
