import 'package:drift/drift.dart';
import 'connection/connection_stub.dart'
    if (dart.library.io) 'connection/native.dart'
    if (dart.library.html) 'connection/web.dart';

part 'database.g.dart';

@DataClassName('SubjectEntry')
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get iconName => text().nullable().named('icon_name')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UnitEntry')
class Units extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().named('subject_id')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ModuleEntry')
class Modules extends Table {
  TextColumn get id => text()();
  TextColumn get unitId => text().named('unit_id')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonEntry')
class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text().named('module_id')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get readingTimeMinutes => integer().named('reading_time_minutes')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonCardEntry')
class LessonCards extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text().named('lesson_id').references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get heading => text()();
  TextColumn get body => text()();
  TextColumn get tip => text().nullable()();
  IntColumn get sortOrder => integer().named('sort_order')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RevisionEntry')
class Revisions extends Table {
  TextColumn get parentId => text().named('parent_id')();
  TextColumn get parentType => text().named('parent_type')();
  TextColumn get keypoints => text()(); // JSON encoded list of strings

  @override
  Set<Column> get primaryKey => {parentId};
}

@DataClassName('QuestionEntry')
class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().named('parent_id')();
  TextColumn get parentType => text().named('parent_type')();
  TextColumn get questionText => text().named('question_text')();
  TextColumn get options => text()(); // JSON encoded list of strings
  IntColumn get correctOptionIndex => integer().named('correct_option_index')();
  TextColumn get explanation => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CurrentAffairsEntry')
class CurrentAffairs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get date => text()();
  TextColumn get category => text()();
  TextColumn get content => text()();
  TextColumn get imageUrl => text().nullable().named('image_url')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonProgressEntry')
class LessonProgress extends Table {
  TextColumn get lessonId => text().named('lesson_id').references(Lessons, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false)).named('is_completed')();
  TextColumn get completedAt => text().nullable().named('completed_at')();
  TextColumn get lastReadAt => text().nullable().named('last_read_at')();

  @override
  Set<Column> get primaryKey => {lessonId};
}

@DataClassName('QuizAttemptEntry')
class QuizAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get quizId => text().named('quiz_id')();
  IntColumn get score => integer()();
  IntColumn get totalQuestions => integer().named('total_questions')();
  TextColumn get attemptedAt => text().named('attempted_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BookmarkEntry')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().named('item_id')();
  TextColumn get itemType => text().named('item_type')();
  TextColumn get bookmarkedAt => text().named('bookmarked_at')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CardReviewEntry')
class CardReviews extends Table {
  TextColumn get cardId => text().named('card_id').references(LessonCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get lessonId => text().named('lesson_id').references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  TextColumn get lastReviewedAt => text().nullable().named('last_reviewed_at')();
  TextColumn get nextReviewAt => text().nullable().named('next_review_at')();

  @override
  Set<Column> get primaryKey => {cardId};
}

@DriftDatabase(tables: [
  Subjects,
  Units,
  Modules,
  Lessons,
  LessonCards,
  Revisions,
  Questions,
  CurrentAffairs,
  LessonProgress,
  QuizAttempts,
  Bookmarks,
  CardReviews,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  AppDatabase.executor(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Re-create all tables or run specific schema migration steps safely
          }
        },
      );
}
