import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:drift/drift.dart';
import 'database.dart';

/// Seeds the initial content records into the admin Drift database on creation.
class DatabaseSeeder {
  DatabaseSeeder._();

  /// Loads polity_content.json from assets and seeds all data tables in [db].
  static Future<void> seedInitial(AppDatabase db) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/polity_content.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> subjects = data['subjects'] ?? [];

      await db.batch((batch) {
        for (final subjectData in subjects) {
          final subjectId = subjectData['id'] as String;

          // Insert Subject
          batch.insert(
            db.subjects,
            SubjectsCompanion.insert(
              id: subjectId,
              name: subjectData['name'] as String,
              description: Value(subjectData['description'] as String?),
              iconName: Value(subjectData['iconName'] as String?),
            ),
          );

          final List<dynamic> units = subjectData['units'] ?? [];
          for (final unitData in units) {
            final unitId = unitData['id'] as String;

            // Insert Unit
            batch.insert(
              db.units,
              UnitsCompanion.insert(
                id: unitId,
                subjectId: subjectId,
                name: unitData['name'] as String,
                description: Value(unitData['description'] as String?),
              ),
            );

            // Insert Unit Revision data
            _insertRevisionBatch(batch, db, unitId, 'unit', unitData['revision']);
            // Insert Unit Quiz questions
            _insertQuizQuestionsBatch(batch, db, unitId, 'unit', unitData['quiz']);

            final List<dynamic> modules = unitData['modules'] ?? [];
            for (final moduleData in modules) {
              final moduleId = moduleData['id'] as String;

              // Insert Module
              batch.insert(
                db.modules,
                ModulesCompanion.insert(
                  id: moduleId,
                  unitId: unitId,
                  name: moduleData['name'] as String,
                  description: Value(moduleData['description'] as String?),
                ),
              );

              // Insert Module Revision data
              _insertRevisionBatch(batch, db, moduleId, 'module', moduleData['revision']);
              // Insert Module Quiz questions
              _insertQuizQuestionsBatch(batch, db, moduleId, 'module', moduleData['quiz']);

              // Insert Lessons
              final List<dynamic> lessons = moduleData['lessons'] ?? [];
              for (final lessonData in lessons) {
                final lessonId = lessonData['id'] as String;
                batch.insert(
                  db.lessons,
                  LessonsCompanion.insert(
                    id: lessonId,
                    moduleId: moduleId,
                    name: lessonData['name'] as String,
                    description: Value(lessonData['description'] as String?),
                    readingTimeMinutes: lessonData['readingTimeMinutes'] as int,
                  ),
                );

                // Seed lesson cards - Prioritize generating cards from deep-dive markdown content
                final content = lessonData['content'] as String? ?? '';
                List<Map<String, String>> generated = [];
                if (content.trim().isNotEmpty) {
                  generated = _generateCardsFromMarkdown(content, lessonData['name'] as String? ?? 'Intro');
                }

                if (generated.isNotEmpty) {
                  for (int i = 0; i < generated.length; i++) {
                    final card = generated[i];
                    batch.insert(
                      db.lessonCards,
                      LessonCardsCompanion.insert(
                        id: '${lessonId}_$i',
                        lessonId: lessonId,
                        heading: card['heading']!,
                        body: card['body']!,
                        tip: const Value(null),
                        sortOrder: i,
                      ),
                    );
                  }
                } else {
                  // Fallback to pre-defined summary cards if no content is found
                  final List<dynamic> cardsData = lessonData['cards'] ?? [];
                  for (int i = 0; i < cardsData.length; i++) {
                    final card = cardsData[i];
                    batch.insert(
                      db.lessonCards,
                      LessonCardsCompanion.insert(
                        id: '${lessonId}_$i',
                        lessonId: lessonId,
                        heading: card['heading'] as String,
                        body: card['body'] as String,
                        tip: Value(card['tip'] as String?),
                        sortOrder: i,
                      ),
                    );
                  }
                }
              }
            }
          }
        }
      });
    } catch (e) {
      // Ignore or log error
    }
  }

  static List<Map<String, String>> _generateCardsFromMarkdown(String markdown, String defaultTitle) {
    final List<Map<String, String>> cards = [];
    final List<String> lines = markdown.split('\n');

    String currentHeading = defaultTitle;
    final StringBuffer currentBody = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('## ')) {
        if (currentBody.toString().trim().isNotEmpty) {
          cards.add({
            'heading': currentHeading,
            'body': currentBody.toString().trim(),
          });
        }
        currentHeading = trimmed.substring(3).trim();
        currentBody.clear();
      } else if (trimmed.startsWith('# ')) {
        currentHeading = trimmed.substring(2).trim();
      } else {
        currentBody.writeln(line);
      }
    }

    if (currentBody.toString().trim().isNotEmpty || cards.isEmpty) {
      cards.add({
        'heading': currentHeading,
        'body': currentBody.toString().trim(),
      });
    }

    return cards;
  }

  static void _insertRevisionBatch(
    Batch batch,
    AppDatabase db,
    String parentId,
    String parentType,
    Map<String, dynamic>? revision,
  ) {
    if (revision == null) return;

    batch.insert(
      db.revisions,
      RevisionsCompanion.insert(
        parentId: parentId,
        parentType: parentType,
        keypoints: jsonEncode(revision['cards'] ?? revision['keypoints'] ?? []),
      ),
    );

    final List<dynamic> recapQs = revision['recapQuestions'] ?? [];
    for (final q in recapQs) {
      _insertQuestionBatch(batch, parentId, 'revision', q, batch, db);
    }
  }

  static void _insertQuizQuestionsBatch(
    Batch batch,
    AppDatabase db,
    String parentId,
    String parentType,
    Map<String, dynamic>? quiz,
  ) {
    if (quiz == null) return;
    final List<dynamic> questions = quiz['questions'] ?? [];
    for (final q in questions) {
      _insertQuestionBatch(batch, parentId, parentType, q, batch, db);
    }
  }

  static void _insertQuestionBatch(
    Batch batch,
    String parentId,
    String parentType,
    Map<String, dynamic> q,
    Batch b,
    AppDatabase db,
  ) {
    b.insert(
      db.questions,
      QuestionsCompanion.insert(
        id: q['id'] as String,
        parentId: parentId,
        parentType: parentType,
        questionText: q['questionText'] as String,
        options: jsonEncode(q['options']),
        correctOptionIndex: q['correctOptionIndex'] as int,
        explanation: Value(q['explanation'] as String?),
      ),
    );
  }
}
