// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizData _$QuizDataFromJson(Map<String, dynamic> json) {
  return _QuizData.fromJson(json);
}

/// @nodoc
mixin _$QuizData {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;

  /// Serializes this QuizData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizDataCopyWith<QuizData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizDataCopyWith<$Res> {
  factory $QuizDataCopyWith(QuizData value, $Res Function(QuizData) then) =
      _$QuizDataCopyWithImpl<$Res, QuizData>;
  @useResult
  $Res call({String id, String title, List<QuizQuestion> questions});
}

/// @nodoc
class _$QuizDataCopyWithImpl<$Res, $Val extends QuizData>
    implements $QuizDataCopyWith<$Res> {
  _$QuizDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizDataImplCopyWith<$Res>
    implements $QuizDataCopyWith<$Res> {
  factory _$$QuizDataImplCopyWith(
    _$QuizDataImpl value,
    $Res Function(_$QuizDataImpl) then,
  ) = __$$QuizDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<QuizQuestion> questions});
}

/// @nodoc
class __$$QuizDataImplCopyWithImpl<$Res>
    extends _$QuizDataCopyWithImpl<$Res, _$QuizDataImpl>
    implements _$$QuizDataImplCopyWith<$Res> {
  __$$QuizDataImplCopyWithImpl(
    _$QuizDataImpl _value,
    $Res Function(_$QuizDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
  }) {
    return _then(
      _$QuizDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizDataImpl implements _QuizData {
  const _$QuizDataImpl({
    required this.id,
    required this.title,
    required final List<QuizQuestion> questions,
  }) : _questions = questions;

  factory _$QuizDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizDataImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<QuizQuestion> _questions;
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'QuizData(id: $id, title: $title, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_questions),
  );

  /// Create a copy of QuizData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizDataImplCopyWith<_$QuizDataImpl> get copyWith =>
      __$$QuizDataImplCopyWithImpl<_$QuizDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizDataImplToJson(this);
  }
}

abstract class _QuizData implements QuizData {
  const factory _QuizData({
    required final String id,
    required final String title,
    required final List<QuizQuestion> questions,
  }) = _$QuizDataImpl;

  factory _QuizData.fromJson(Map<String, dynamic> json) =
      _$QuizDataImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<QuizQuestion> get questions;

  /// Create a copy of QuizData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizDataImplCopyWith<_$QuizDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  int get correctOptionIndex => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
    QuizQuestion value,
    $Res Function(QuizQuestion) then,
  ) = _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({
    String id,
    String questionText,
    List<String> options,
    int correctOptionIndex,
    String explanation,
  });
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionText = null,
    Object? options = null,
    Object? correctOptionIndex = null,
    Object? explanation = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctOptionIndex: null == correctOptionIndex
                ? _value.correctOptionIndex
                : correctOptionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
    _$QuizQuestionImpl value,
    $Res Function(_$QuizQuestionImpl) then,
  ) = __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String questionText,
    List<String> options,
    int correctOptionIndex,
    String explanation,
  });
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
    _$QuizQuestionImpl _value,
    $Res Function(_$QuizQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionText = null,
    Object? options = null,
    Object? correctOptionIndex = null,
    Object? explanation = null,
  }) {
    return _then(
      _$QuizQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctOptionIndex: null == correctOptionIndex
            ? _value.correctOptionIndex
            : correctOptionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl extends _QuizQuestion {
  const _$QuizQuestionImpl({
    required this.id,
    required this.questionText,
    required final List<String> options,
    required this.correctOptionIndex,
    required this.explanation,
  }) : _options = options,
       super._();

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String questionText;
  final List<String> _options;
  @override
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final int correctOptionIndex;
  @override
  final String explanation;

  @override
  String toString() {
    return 'QuizQuestion(id: $id, questionText: $questionText, options: $options, correctOptionIndex: $correctOptionIndex, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctOptionIndex, correctOptionIndex) ||
                other.correctOptionIndex == correctOptionIndex) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    questionText,
    const DeepCollectionEquality().hash(_options),
    correctOptionIndex,
    explanation,
  );

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(this);
  }
}

abstract class _QuizQuestion extends QuizQuestion {
  const factory _QuizQuestion({
    required final String id,
    required final String questionText,
    required final List<String> options,
    required final int correctOptionIndex,
    required final String explanation,
  }) = _$QuizQuestionImpl;
  const _QuizQuestion._() : super._();

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  String get questionText;
  @override
  List<String> get options;
  @override
  int get correctOptionIndex;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevisionCard _$RevisionCardFromJson(Map<String, dynamic> json) {
  return _RevisionCard.fromJson(json);
}

/// @nodoc
mixin _$RevisionCard {
  String get heading => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get tip => throw _privateConstructorUsedError;

  /// Serializes this RevisionCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevisionCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevisionCardCopyWith<RevisionCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevisionCardCopyWith<$Res> {
  factory $RevisionCardCopyWith(
    RevisionCard value,
    $Res Function(RevisionCard) then,
  ) = _$RevisionCardCopyWithImpl<$Res, RevisionCard>;
  @useResult
  $Res call({String heading, String body, String? tip});
}

/// @nodoc
class _$RevisionCardCopyWithImpl<$Res, $Val extends RevisionCard>
    implements $RevisionCardCopyWith<$Res> {
  _$RevisionCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevisionCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heading = null,
    Object? body = null,
    Object? tip = freezed,
  }) {
    return _then(
      _value.copyWith(
            heading: null == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            tip: freezed == tip
                ? _value.tip
                : tip // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevisionCardImplCopyWith<$Res>
    implements $RevisionCardCopyWith<$Res> {
  factory _$$RevisionCardImplCopyWith(
    _$RevisionCardImpl value,
    $Res Function(_$RevisionCardImpl) then,
  ) = __$$RevisionCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String heading, String body, String? tip});
}

/// @nodoc
class __$$RevisionCardImplCopyWithImpl<$Res>
    extends _$RevisionCardCopyWithImpl<$Res, _$RevisionCardImpl>
    implements _$$RevisionCardImplCopyWith<$Res> {
  __$$RevisionCardImplCopyWithImpl(
    _$RevisionCardImpl _value,
    $Res Function(_$RevisionCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevisionCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heading = null,
    Object? body = null,
    Object? tip = freezed,
  }) {
    return _then(
      _$RevisionCardImpl(
        heading: null == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        tip: freezed == tip
            ? _value.tip
            : tip // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RevisionCardImpl implements _RevisionCard {
  const _$RevisionCardImpl({
    required this.heading,
    required this.body,
    this.tip,
  });

  factory _$RevisionCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevisionCardImplFromJson(json);

  @override
  final String heading;
  @override
  final String body;
  @override
  final String? tip;

  @override
  String toString() {
    return 'RevisionCard(heading: $heading, body: $body, tip: $tip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevisionCardImpl &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.tip, tip) || other.tip == tip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heading, body, tip);

  /// Create a copy of RevisionCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevisionCardImplCopyWith<_$RevisionCardImpl> get copyWith =>
      __$$RevisionCardImplCopyWithImpl<_$RevisionCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevisionCardImplToJson(this);
  }
}

abstract class _RevisionCard implements RevisionCard {
  const factory _RevisionCard({
    required final String heading,
    required final String body,
    final String? tip,
  }) = _$RevisionCardImpl;

  factory _RevisionCard.fromJson(Map<String, dynamic> json) =
      _$RevisionCardImpl.fromJson;

  @override
  String get heading;
  @override
  String get body;
  @override
  String? get tip;

  /// Create a copy of RevisionCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevisionCardImplCopyWith<_$RevisionCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RevisionData _$RevisionDataFromJson(Map<String, dynamic> json) {
  return _RevisionData.fromJson(json);
}

/// @nodoc
mixin _$RevisionData {
  List<RevisionCard> get cards => throw _privateConstructorUsedError;
  List<QuizQuestion> get recapQuestions => throw _privateConstructorUsedError;

  /// Serializes this RevisionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevisionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevisionDataCopyWith<RevisionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevisionDataCopyWith<$Res> {
  factory $RevisionDataCopyWith(
    RevisionData value,
    $Res Function(RevisionData) then,
  ) = _$RevisionDataCopyWithImpl<$Res, RevisionData>;
  @useResult
  $Res call({List<RevisionCard> cards, List<QuizQuestion> recapQuestions});
}

/// @nodoc
class _$RevisionDataCopyWithImpl<$Res, $Val extends RevisionData>
    implements $RevisionDataCopyWith<$Res> {
  _$RevisionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevisionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cards = null, Object? recapQuestions = null}) {
    return _then(
      _value.copyWith(
            cards: null == cards
                ? _value.cards
                : cards // ignore: cast_nullable_to_non_nullable
                      as List<RevisionCard>,
            recapQuestions: null == recapQuestions
                ? _value.recapQuestions
                : recapQuestions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevisionDataImplCopyWith<$Res>
    implements $RevisionDataCopyWith<$Res> {
  factory _$$RevisionDataImplCopyWith(
    _$RevisionDataImpl value,
    $Res Function(_$RevisionDataImpl) then,
  ) = __$$RevisionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RevisionCard> cards, List<QuizQuestion> recapQuestions});
}

/// @nodoc
class __$$RevisionDataImplCopyWithImpl<$Res>
    extends _$RevisionDataCopyWithImpl<$Res, _$RevisionDataImpl>
    implements _$$RevisionDataImplCopyWith<$Res> {
  __$$RevisionDataImplCopyWithImpl(
    _$RevisionDataImpl _value,
    $Res Function(_$RevisionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevisionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cards = null, Object? recapQuestions = null}) {
    return _then(
      _$RevisionDataImpl(
        cards: null == cards
            ? _value._cards
            : cards // ignore: cast_nullable_to_non_nullable
                  as List<RevisionCard>,
        recapQuestions: null == recapQuestions
            ? _value._recapQuestions
            : recapQuestions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RevisionDataImpl implements _RevisionData {
  const _$RevisionDataImpl({
    required final List<RevisionCard> cards,
    required final List<QuizQuestion> recapQuestions,
  }) : _cards = cards,
       _recapQuestions = recapQuestions;

  factory _$RevisionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevisionDataImplFromJson(json);

  final List<RevisionCard> _cards;
  @override
  List<RevisionCard> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  final List<QuizQuestion> _recapQuestions;
  @override
  List<QuizQuestion> get recapQuestions {
    if (_recapQuestions is EqualUnmodifiableListView) return _recapQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recapQuestions);
  }

  @override
  String toString() {
    return 'RevisionData(cards: $cards, recapQuestions: $recapQuestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevisionDataImpl &&
            const DeepCollectionEquality().equals(other._cards, _cards) &&
            const DeepCollectionEquality().equals(
              other._recapQuestions,
              _recapQuestions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_cards),
    const DeepCollectionEquality().hash(_recapQuestions),
  );

  /// Create a copy of RevisionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevisionDataImplCopyWith<_$RevisionDataImpl> get copyWith =>
      __$$RevisionDataImplCopyWithImpl<_$RevisionDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevisionDataImplToJson(this);
  }
}

abstract class _RevisionData implements RevisionData {
  const factory _RevisionData({
    required final List<RevisionCard> cards,
    required final List<QuizQuestion> recapQuestions,
  }) = _$RevisionDataImpl;

  factory _RevisionData.fromJson(Map<String, dynamic> json) =
      _$RevisionDataImpl.fromJson;

  @override
  List<RevisionCard> get cards;
  @override
  List<QuizQuestion> get recapQuestions;

  /// Create a copy of RevisionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevisionDataImplCopyWith<_$RevisionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
