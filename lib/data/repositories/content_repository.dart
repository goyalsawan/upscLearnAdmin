import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import '../database_helper.dart';
import '../database.dart';
import '../models.dart';
import 'package:drift/drift.dart';
import '../utils/markdown_parser.dart';

/// Content repository inside upsc_admin_dashboard to handle querying and writing
/// syllabus content in the SQLite database file. Includes runtime browser simulation logic.
class ContentRepository {
  final DatabaseHelper _dbHelper;
  List<Subject>? _webCache; // In-memory cache when running in Web browser mode
  final Map<String, List<LessonCard>> _lessonCardsMap = {};

  ContentRepository(this._dbHelper);

  /// Loads all subjects from SQLite (Native) or returns Web in-memory simulated cache.
  Future<List<Subject>> getAllSubjects() async {
    await _loadLessonCardsIfNeeded();

    if (kIsWeb) {
      if (_webCache != null) return _webCache!;

      // Load initial Polity static database layout from JSON asset
      final String jsonString = await rootBundle.loadString('assets/polity_content.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> subjectsData = data['subjects'] ?? [];

      final List<Subject> subjects = [];
      for (final sMap in subjectsData) {
        final subjectId = sMap['id'] as String;
        final List<dynamic> unitsData = sMap['units'] ?? [];
        final List<Unit> units = [];

        for (final uMap in unitsData) {
          final List<dynamic> modulesData = uMap['modules'] ?? [];
          final List<Module> modules = [];

          for (final mMap in modulesData) {
            final List<dynamic> lessonsData = mMap['lessons'] ?? [];
            final List<Lesson> lessons = lessonsData.map((lMap) {
              final lessonId = lMap['id'] as String;
              return Lesson(
                id: lessonId,
                name: lMap['name'] as String,
                description: lMap['description'] as String,
                readingTimeMinutes: lMap['readingTimeMinutes'] as int,
                cards: _lessonCardsMap[lessonId] ?? const [],
              );
            }).toList();

            final moduleRevision = mMap['revision'];
            final List<dynamic> moduleRecapQs = moduleRevision?['recapQuestions'] ?? [];
            final List<dynamic> moduleRawCards = moduleRevision?['cards'] ?? moduleRevision?['keypoints'] ?? [];
            final moduleRevisionData = RevisionData(
              cards: moduleRawCards.map((c) {
                if (c is String) {
                  return RevisionCard(heading: 'Key Point', body: c, tip: null);
                }
                return RevisionCard.fromJson(c as Map<String, dynamic>);
              }).toList(),
              recapQuestions: moduleRecapQs.map((q) {
                return QuizQuestion(
                  id: q['id'] as String,
                  questionText: q['questionText'] as String,
                  options: (q['options'] ?? []).cast<String>(),
                  correctOptionIndex: q['correctOptionIndex'] as int,
                  explanation: q['explanation'] as String,
                );
              }).toList(),
            );

            final moduleQuiz = mMap['quiz'];
            final List<dynamic> moduleQuizQs = moduleQuiz?['questions'] ?? [];
            final moduleQuizData = QuizData(
              id: moduleQuiz?['id'] ?? '${mMap['id']}_quiz',
              title: moduleQuiz?['title'] ?? 'Practice Quiz',
              questions: moduleQuizQs.map((q) {
                return QuizQuestion(
                  id: q['id'] as String,
                  questionText: q['questionText'] as String,
                  options: (q['options'] ?? []).cast<String>(),
                  correctOptionIndex: q['correctOptionIndex'] as int,
                  explanation: q['explanation'] as String,
                );
              }).toList(),
            );

            modules.add(Module(
              id: mMap['id'] as String,
              name: mMap['name'] as String,
              description: mMap['description'] as String,
              lessons: lessons,
              revision: moduleRevisionData,
              quiz: moduleQuizData,
            ));
          }

          final unitRevision = uMap['revision'];
          final List<dynamic> unitRecapQs = unitRevision?['recapQuestions'] ?? [];
          final List<dynamic> unitRawCards = unitRevision?['cards'] ?? unitRevision?['keypoints'] ?? [];
          final unitRevisionData = RevisionData(
            cards: unitRawCards.map((c) {
              if (c is String) {
                return RevisionCard(heading: 'Key Point', body: c, tip: null);
              }
              return RevisionCard.fromJson(c as Map<String, dynamic>);
            }).toList(),
            recapQuestions: unitRecapQs.map((q) {
              return QuizQuestion(
                id: q['id'] as String,
                questionText: q['questionText'] as String,
                options: (q['options'] ?? []).cast<String>(),
                correctOptionIndex: q['correctOptionIndex'] as int,
                explanation: q['explanation'] as String,
              );
            }).toList(),
          );

          final unitQuiz = uMap['quiz'];
          final List<dynamic> unitQuizQs = unitQuiz?['questions'] ?? [];
          final unitQuizData = QuizData(
            id: unitQuiz?['id'] ?? '${uMap['id']}_quiz',
            title: unitQuiz?['title'] ?? 'Unit Comprehensive Test',
            questions: unitQuizQs.map((q) {
              return QuizQuestion(
                id: q['id'] as String,
                questionText: q['questionText'] as String,
                options: (q['options'] ?? []).cast<String>(),
                correctOptionIndex: q['correctOptionIndex'] as int,
                explanation: q['explanation'] as String,
              );
            }).toList(),
          );

          units.add(Unit(
            id: uMap['id'] as String,
            name: uMap['name'] as String,
            description: uMap['description'] as String,
            modules: modules,
            revision: unitRevisionData,
            quiz: unitQuizData,
          ));
        }

        subjects.add(Subject(
          id: subjectId,
          name: sMap['name'] as String,
          description: sMap['description'] as String,
          iconName: sMap['iconName'] as String,
          units: units,
        ));
      }
      _webCache = subjects;
      return _webCache!;
    }

    // Native implementation (using Drift database)
    final db = await _dbHelper.database;
    if (db == null) return [];

    final subjectRows = await db.select(db.subjects).get();

    final List<Subject> subjects = [];
    for (final sMap in subjectRows) {
      final subjectId = sMap.id;
      final units = await _getUnitsForSubject(db, subjectId);

      subjects.add(Subject(
        id: subjectId,
        name: sMap.name,
        description: sMap.description ?? '',
        iconName: sMap.iconName ?? '',
        units: units,
      ));
    }
    return subjects;
  }

  Future<List<Unit>> _getUnitsForSubject(AppDatabase db, String subjectId) async {
    final unitRows = await (db.select(db.units)..where((u) => u.subjectId.equals(subjectId))).get();

    final List<Unit> units = [];
    for (final uMap in unitRows) {
      final unitId = uMap.id;
      final modules = await _getModulesForUnit(db, unitId);
      final revision = await _getRevisionData(db, unitId, 'unit');
      final quiz = await _getQuizData(db, unitId, 'unit');

      units.add(Unit(
        id: unitId,
        name: uMap.name,
        description: uMap.description ?? '',
        modules: modules,
        revision: revision,
        quiz: quiz,
      ));
    }
    return units;
  }

  Future<List<Module>> _getModulesForUnit(AppDatabase db, String unitId) async {
    final moduleRows = await (db.select(db.modules)..where((m) => m.unitId.equals(unitId))).get();

    final List<Module> modules = [];
    for (final mMap in moduleRows) {
      final moduleId = mMap.id;
      final lessons = await _getLessonsForModule(db, moduleId);
      final revision = await _getRevisionData(db, moduleId, 'module');
      final quiz = await _getQuizData(db, moduleId, 'module');

      modules.add(Module(
        id: moduleId,
        name: mMap.name,
        description: mMap.description ?? '',
        lessons: lessons,
        revision: revision,
        quiz: quiz,
      ));
    }
    return modules;
  }

  Future<List<Lesson>> _getLessonsForModule(AppDatabase db, String moduleId) async {
    final lessonRows = await (db.select(db.lessons)..where((l) => l.moduleId.equals(moduleId))).get();

    final List<Lesson> lessons = [];
    for (final lMap in lessonRows) {
      final lessonId = lMap.id;

      // Query cards for this lesson from database
      final cardRows = await (db.select(db.lessonCards)
            ..where((c) => c.lessonId.equals(lessonId))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.asc)]))
          .get();

      final List<LessonCard> cards = cardRows.map((cMap) {
        return LessonCard(
          heading: cMap.heading,
          body: cMap.body,
          tip: cMap.tip,
        );
      }).toList();

      lessons.add(Lesson(
        id: lessonId,
        name: lMap.name,
        description: lMap.description ?? '',
        readingTimeMinutes: lMap.readingTimeMinutes,
        cards: cards,
      ));
    }
    return lessons;
  }

  Future<RevisionData> _getRevisionData(AppDatabase db, String parentId, String parentType) async {
    final revisionRow = await (db.select(db.revisions)
          ..where((r) => r.parentId.equals(parentId) & r.parentType.equals(parentType)))
        .getSingleOrNull();

    if (revisionRow == null) {
      return const RevisionData(cards: [], recapQuestions: []);
    }

    final List<dynamic> decodedCards = jsonDecode(revisionRow.keypoints);
    final List<RevisionCard> cards = decodedCards.map((c) {
      if (c is String) {
        return RevisionCard(heading: 'Key Point', body: c, tip: null);
      }
      return RevisionCard.fromJson(c as Map<String, dynamic>);
    }).toList();

    final questionRows = await (db.select(db.questions)
          ..where((q) => q.parentId.equals(parentId) & q.parentType.equals('revision')))
        .get();

    final recapQuestions = questionRows.map((qMap) {
      final String rawOptions = qMap.options;
      List<String> options = [];
      try {
        final decoded = jsonDecode(rawOptions);
        options = (decoded as List).cast<String>();
      } catch (_) {
        options = rawOptions.split('|');
      }

      return QuizQuestion(
        id: qMap.id,
        questionText: qMap.questionText,
        options: options,
        correctOptionIndex: qMap.correctOptionIndex,
        explanation: qMap.explanation ?? '',
      );
    }).toList();

    return RevisionData(
      cards: cards,
      recapQuestions: recapQuestions,
    );
  }

  Future<QuizData> _getQuizData(AppDatabase db, String parentId, String parentType) async {
    final questionRows = await (db.select(db.questions)
          ..where((q) => q.parentId.equals(parentId) & q.parentType.equals(parentType)))
        .get();

    final questions = questionRows.map((qMap) {
      final String rawOptions = qMap.options;
      List<String> options = [];
      try {
        final decoded = jsonDecode(rawOptions);
        options = (decoded as List).cast<String>();
      } catch (_) {
        options = rawOptions.split('|');
      }

      return QuizQuestion(
        id: qMap.id,
        questionText: qMap.questionText,
        options: options,
        correctOptionIndex: qMap.correctOptionIndex,
        explanation: qMap.explanation ?? '',
      );
    }).toList();

    return QuizData(
      id: '${parentId}_quiz',
      title: parentType == 'unit' ? 'Unit Comprehensive Test' : 'Module Practice Quiz',
      questions: questions,
    );
  }

  /// Commits a new lesson, revision cards, and practice MCQs into the database file.
  Future<void> insertApprovedContent({
    required String moduleId,
    required Lesson lesson,
    required List<QuizQuestion> questions,
    required List<RevisionCard> revisionCards,
  }) async {
    if (kIsWeb) {
      // Simulate database write in the browser memory cache
      final cache = _webCache;
      if (cache != null) {
        for (var subject in cache) {
          for (var unit in subject.units) {
            for (var i = 0; i < unit.modules.length; i++) {
              final mod = unit.modules[i];
              if (mod.id == moduleId) {
                // 1. Update/Replace Lesson in cache (prevent duplicates on edits)
                final updatedLessons = List<Lesson>.from(mod.lessons);
                final lessonIndex = updatedLessons.indexWhere((l) => l.id == lesson.id);
                if (lessonIndex != -1) {
                  updatedLessons[lessonIndex] = lesson;
                } else {
                  updatedLessons.add(lesson);
                }

                // 2. Update/Replace Questions in cache (prevent duplicates on edits)
                final updatedQuizQuestions = List<QuizQuestion>.from(mod.quiz.questions);
                for (final q in questions) {
                  final qIndex = updatedQuizQuestions.indexWhere((eq) => eq.id == q.id);
                  if (qIndex != -1) {
                    updatedQuizQuestions[qIndex] = q;
                  } else {
                    updatedQuizQuestions.add(q);
                  }
                }

                // 3. Update revision cards in cache
                final updatedCards = List<RevisionCard>.from(mod.revision.cards);
                for (final card in revisionCards) {
                  if (!updatedCards.any((c) => c.heading == card.heading)) {
                    updatedCards.add(card);
                  }
                }

                unit.modules[i] = mod.copyWith(
                  lessons: updatedLessons,
                  quiz: QuizData(
                    id: mod.quiz.id,
                    title: mod.quiz.title,
                    questions: updatedQuizQuestions,
                  ),
                  revision: RevisionData(
                    cards: updatedCards,
                    recapQuestions: mod.revision.recapQuestions,
                  ),
                );
              }
            }
          }
        }
      }
      return;
    }

    final db = await _dbHelper.database;
    if (db == null) return;

    await db.transaction(() async {
      // 1. Insert Lesson
      await db.into(db.lessons).insert(
        LessonsCompanion.insert(
          id: lesson.id,
          moduleId: moduleId,
          name: lesson.name,
          description: Value(lesson.description),
          readingTimeMinutes: lesson.readingTimeMinutes,
        ),
        mode: InsertMode.insertOrReplace,
      );

      // 1b. Insert Lesson Cards
      await (db.delete(db.lessonCards)..where((c) => c.lessonId.equals(lesson.id))).go();
      for (int i = 0; i < lesson.cards.length; i++) {
        final card = lesson.cards[i];
        await db.into(db.lessonCards).insert(
          LessonCardsCompanion.insert(
            id: '${lesson.id}_$i',
            lessonId: lesson.id,
            heading: card.heading,
            body: card.body,
            tip: Value(card.tip),
            sortOrder: i,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 2. Insert Quiz Questions
      for (final q in questions) {
        await db.into(db.questions).insert(
          QuestionsCompanion.insert(
            id: q.id,
            parentId: moduleId,
            parentType: 'module',
            questionText: q.questionText,
            options: jsonEncode(q.options),
            correctOptionIndex: q.correctOptionIndex,
            explanation: Value(q.explanation),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 3. Update/Insert Revision Cards
      final existingRev = await (db.select(db.revisions)
            ..where((r) => r.parentId.equals(moduleId) & r.parentType.equals('module')))
          .getSingleOrNull();

      List<RevisionCard> activeCards = List.from(revisionCards);
      if (existingRev != null) {
        final decoded = jsonDecode(existingRev.keypoints) as List;
        final existingCards = decoded
            .map((c) => RevisionCard.fromJson(c as Map<String, dynamic>))
            .toList();
        for (final ec in existingCards) {
          if (!activeCards.any((ac) => ac.heading == ec.heading)) {
            activeCards.add(ec);
          }
        }
      }

      await db.into(db.revisions).insert(
        RevisionsCompanion.insert(
          parentId: moduleId,
          parentType: 'module',
          keypoints: jsonEncode(activeCards.map((c) => c.toJson()).toList()),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> _loadLessonCardsIfNeeded() async {
    if (_lessonCardsMap.isNotEmpty) return;
    try {
      final String jsonString = await rootBundle.loadString('assets/polity_content.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> subjectsData = data['subjects'] ?? [];
      for (final sMap in subjectsData) {
        final List<dynamic> unitsData = sMap['units'] ?? [];
        for (final uMap in unitsData) {
          final List<dynamic> modulesData = uMap['modules'] ?? [];
          for (final mMap in modulesData) {
            final List<dynamic> lessonsData = mMap['lessons'] ?? [];
            for (final lMap in lessonsData) {
              final lessonId = lMap['id'] as String;
              final content = lMap['content'] as String? ?? '';
              List<Map<String, String>> generated = [];
              if (content.trim().isNotEmpty) {
                generated = MarkdownCardParser.parseMarkdownToCards(content, lMap['name'] as String? ?? 'Intro');
              }

              List<LessonCard> cards;
              if (generated.isNotEmpty) {
                cards = generated.map((c) => LessonCard(
                  heading: c['heading']!,
                  body: c['body']!,
                )).toList();
              } else {
                final List<dynamic> cardsData = lMap['cards'] ?? [];
                cards = cardsData
                    .map((c) => LessonCard.fromJson(c as Map<String, dynamic>))
                    .toList();
              }
              _lessonCardsMap[lessonId] = cards;
            }
          }
        }
      }
    } catch (_) {}
  }
}
