import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/utils/markdown_parser.dart';

/// ViewModel managing state operations for the UPSC Content Administration dashboard,
/// including visualizer data, source ingestion lists, simulated LLM generators,
/// draft reviews, and SQLite/JSON databases compilation exports.
class AdminViewModel extends ChangeNotifier {
  final ContentRepository _contentRepository;

  List<Subject> _subjects = [];
  List<IngestedSource> _ingestedSources = [];
  IngestedSource? _selectedSource;
  bool _isLoading = false;

  // Editing existing content states
  bool _isEditingExisting = false;
  String? _editingLessonId;
  String? _editingModuleId;

  // Draft Editor Values (state of current active review)
  String _editorLessonName = '';
  String _editorLessonDescription = '';
  int _editorReadingTime = 5;
  String _editorLessonContent = '';
  List<QuizQuestion> _editorQuestions = [];
  List<RevisionCard> _editorRevisionCards = [];

  AdminViewModel(this._contentRepository, this._subjects);

  List<Subject> get subjects => _subjects;
  List<IngestedSource> get ingestedSources => _ingestedSources;
  IngestedSource? get selectedSource => _selectedSource;
  bool get isLoading => _isLoading;
  bool get isEditingExisting => _isEditingExisting;
  String? get editingModuleId => _editingModuleId;
  String get activeEditorKey => _isEditingExisting ? (_editingLessonId ?? '') : (_selectedSource?.id ?? '');

  // Editor Getters
  String get editorLessonName => _editorLessonName;
  String get editorLessonDescription => _editorLessonDescription;
  int get editorReadingTime => _editorReadingTime;
  String get editorLessonContent => _editorLessonContent;
  List<QuizQuestion> get editorQuestions => _editorQuestions;
  List<RevisionCard> get editorRevisionCards => _editorRevisionCards;

  // Editor Setters
  void updateEditorLessonName(String val) {
    _editorLessonName = val;
    notifyListeners();
  }

  void updateEditorLessonDescription(String val) {
    _editorLessonDescription = val;
    notifyListeners();
  }

  void updateEditorReadingTime(int val) {
    _editorReadingTime = val;
    notifyListeners();
  }

  void updateEditorLessonContent(String val) {
    _editorLessonContent = val;
    notifyListeners();
  }

  void updateEditorQuestions(List<QuizQuestion> val) {
    _editorQuestions = val;
    notifyListeners();
  }

  void updateEditorRevisionCards(List<RevisionCard> val) {
    _editorRevisionCards = val;
    notifyListeners();
  }

  /// Initial load of the visual tree from database content repository.
  Future<void> loadSyllabus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _subjects = await _contentRepository.getAllSubjects();
    } catch (e) {
      print('Failed to load syllabus: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ingests a new URL source and triggers simulated LLM extraction.
  void ingestUrl(String url) {
    final newId = 'url_${DateTime.now().millisecondsSinceEpoch}';
    final source = IngestedSource(
      id: newId,
      type: IngestedSourceType.url,
      name: url,
      content: 'Ingested web content from address: $url',
      status: IngestionStatus.pending,
    );

    _ingestedSources.add(source);
    notifyListeners();
    
    _runLlmSimulation(source);
  }

  /// Ingests a new local text/PDF file source and triggers simulated LLM extraction.
  void ingestFile(String fileName, String fileText) {
    final newId = 'file_${DateTime.now().millisecondsSinceEpoch}';
    final source = IngestedSource(
      id: newId,
      type: IngestedSourceType.file,
      name: fileName,
      content: fileText,
      status: IngestionStatus.pending,
    );

    _ingestedSources.add(source);
    notifyListeners();

    _runLlmSimulation(source);
  }

  /// Selects a drafted source for editing and review on the approval board.
  void selectSource(IngestedSource source) {
    _selectedSource = source;
    _isEditingExisting = false;
    _editingLessonId = null;
    _editingModuleId = null;
    
    // Seed draft editors
    _editorLessonName = source.draftedLesson?.name ?? '';
    _editorLessonDescription = source.draftedLesson?.description ?? '';
    _editorReadingTime = source.draftedLesson?.readingTimeMinutes ?? 5;
    _editorLessonContent = source.draftedLesson?.content ?? '';
    _editorQuestions = List.from(source.draftedQuestions);
    _editorRevisionCards = List.from(source.draftedRevisionCards);

    notifyListeners();
  }

  /// Approves the current active draft and commits it to the SQLite database tables.
  Future<void> approveActiveDraft(String moduleId) async {
    final source = _selectedSource;
    if (source == null) return;

    _isLoading = true;
    notifyListeners();

    final generated = MarkdownCardParser.parseMarkdownToCards(_editorLessonContent, _editorLessonName);
    final cards = generated.map((c) => LessonCard(
      heading: c['heading']!,
      body: c['body']!,
    )).toList();

    final approvedLesson = Lesson(
      id: source.draftedLesson?.id ?? 'lesson_${DateTime.now().millisecondsSinceEpoch}',
      name: _editorLessonName,
      description: _editorLessonDescription,
      readingTimeMinutes: _editorReadingTime,
      cards: cards,
    );

    try {
      // 1. Commit changes to Content Database Repository
      await _contentRepository.insertApprovedContent(
        moduleId: moduleId,
        lesson: approvedLesson,
        questions: _editorQuestions,
        revisionCards: _editorRevisionCards,
      );

      // 2. Set source status to approved
      final index = _ingestedSources.indexWhere((s) => s.id == source.id);
      if (index != -1) {
        _ingestedSources[index] = source.copyWith(
          status: IngestionStatus.approved,
          draftedLesson: approvedLesson,
          draftedQuestions: _editorQuestions,
          draftedRevisionCards: _editorRevisionCards,
        );
      }

      _selectedSource = null;
      
      // 3. Reload visualizer tree from database
      await loadSyllabus();
    } catch (e) {
      print('Draft approval failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Rejects the active draft, marking it rejected in the feed queue.
  void rejectActiveDraft() {
    final source = _selectedSource;
    if (source == null) return;

    final index = _ingestedSources.indexWhere((s) => s.id == source.id);
    if (index != -1) {
      _ingestedSources[index] = source.copyWith(status: IngestionStatus.rejected);
    }
    _selectedSource = null;
    notifyListeners();
  }

  /// Simulates LLM text extraction, summarizing references into lessons and MCQs.
  Future<void> _runLlmSimulation(IngestedSource source) async {
    _isLoading = true;
    notifyListeners();

    // Mock network/processing delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final sourceText = source.content;
    String generatedTitle = 'Current Affairs Topic';
    String generatedContent = '';
    
    // Smart parsing helper to extract realistic UPSC notes based on keywords
    if (sourceText.toLowerCase().contains('unacademy') || sourceText.toLowerCase().contains('drishti') || sourceText.toLowerCase().contains('url')) {
      generatedTitle = 'Preamble and Judicial Review Scope';
      generatedContent = '''# Preamble and Judicial Review Scope

Judicial review is a core mechanism under the Indian Constitution, reinforcing the rule of law and preserving the federal balance.

## 1. Preamble as part of Judicial Review
In the historic **Kesavananda Bharati Case (1973)**, the Supreme Court declared that the Preamble serves as a guiding light for constitutional interpretation, outlining the Basic Structure of the Constitution which is immune to legislative destruction under Article 368.

## 2. Constitutional Anchors
- **Article 13**: Declares any law void that infringes upon Fundamental Rights.
- **Article 32**: Right to Constitutional Remedies in the Supreme Court.
- **Article 226**: Power of High Courts to issue writs.

## 3. Key Judicial Pronouncements
- **L. Chandra Kumar Case (1997)**: Declared judicial review under Article 32/226 as an essential, non-amendable feature of the basic structure.
- **Minerva Mills Case (1980)**: Emphasized that the Constitution is supreme, and Parliament cannot strip courts of review jurisdiction under the guise of amending power.''';
    } else {
      generatedTitle = 'Fundamental Duties & Citizen Obligations';
      generatedContent = '''# Fundamental Duties & Citizen Obligations

The Fundamental Duties serve as a constant reminder to every citizen that while the Constitution specifically confers fundamental rights, it also requires duties of civil behavior.

## 1. Constitutional Genesis
- **Swaran Singh Committee**: Recommended the inclusion of duties in 1976.
- **42nd Constitutional Amendment Act, 1976**: Inserted **Part IV-A** and **Article 51-A** with 10 duties.
- **86th Amendment Act, 2002**: Added the 11th duty (obligation of parents to provide education to children aged 6 to 14).

## 2. Important Key Duties
*   Abide by the Constitution, respect the National Flag and National Anthem.
*   Protect the sovereignty, unity, and integrity of India.
*   Safeguard public property and abjure violence.
*   Develop scientific temper, humanism, and the spirit of inquiry.''';
    }

    final generated = MarkdownCardParser.parseMarkdownToCards(generatedContent, generatedTitle);
    final cards = generated.map((c) => LessonCard(
      heading: c['heading']!,
      body: c['body']!,
    )).toList();

    final mockLesson = Lesson(
      id: 'lesson_llm_${DateTime.now().millisecondsSinceEpoch}',
      name: generatedTitle,
      description: 'Ingested and summarized by LLM Engine from: ${source.name}',
      readingTimeMinutes: 6,
      cards: cards,
    );

    final mockQs = [
      QuizQuestion(
        id: 'q_llm_1_${DateTime.now().millisecondsSinceEpoch}',
        questionText: 'Which constitutional amendment added the Fundamental Duties to the Indian Constitution?',
        options: ['42nd Amendment', '44th Amendment', '86th Amendment', '73rd Amendment'],
        correctOptionIndex: 0,
        explanation: 'The 42nd Constitutional Amendment Act of 1976 added Part IV-A and Article 51-A containing 10 Fundamental Duties on the recommendation of the Swaran Singh Committee.',
      ),
      QuizQuestion(
        id: 'q_llm_2_${DateTime.now().millisecondsSinceEpoch}',
        questionText: 'In which landmark judgment did the Supreme Court explicitly declare that Judicial Review is a basic feature of the Constitution?',
        options: ['Shankari Prasad Case', 'Golaknath Case', 'L. Chandra Kumar Case', 'Minerva Mills Case'],
        correctOptionIndex: 2,
        explanation: 'In the L. Chandra Kumar v. Union of India (1997) case, the Supreme Court declared that the power of judicial review vested in High Courts (Art 226) and the Supreme Court (Art 32) is an integral part of the basic structure.',
      )
    ];

    final mockRevisionCards = [
      RevisionCard(
        heading: 'Swaran Singh Committee & 42nd Amendment',
        body: 'Fundamental Duties were recommended by the **Swaran Singh Committee** and added by the **42nd Amendment Act, 1976** as Part IV-A with Article 51-A containing 10 duties.',
        tip: 'The 86th Amendment (2002) added the 11th duty on child education.',
      ),
      RevisionCard(
        heading: 'Judicial Review & Basic Structure',
        body: 'In **L. Chandra Kumar Case (1997)**, the Supreme Court declared that judicial review under **Article 32 and 226** is an integral, non-amendable part of the **Basic Structure** of the Constitution.',
        tip: 'Article 13 voids any law infringing Fundamental Rights.',
      ),
      RevisionCard(
        heading: 'Minerva Mills & Parliamentary Limits',
        body: 'In **Minerva Mills Case (1980)**, the Supreme Court held that Parliament cannot strip courts of review jurisdiction under Article 368. The Constitution remains supreme over legislative power.',
      ),
    ];

    // Update source with generated LLM drafts
    final index = _ingestedSources.indexWhere((s) => s.id == source.id);
    if (index != -1) {
      _ingestedSources[index] = source.copyWith(
        status: IngestionStatus.pending,
        draftedLesson: mockLesson,
        draftedQuestions: mockQs,
        draftedRevisionCards: mockRevisionCards,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Compiles the database state into a valid JSON string (representing polity_content.json).
  String compileJsonDatabase() {
    final Map<String, dynamic> output = {
      'subjects': _subjects.map((sub) => sub.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(output);
  }

  /// Compiles and writes the JSON database directly to the project's asset directories,
  /// updating the mobile application and admin panel data stores.
  Future<bool> writeAndSyncJsonDatabase() async {
    if (kIsWeb) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final jsonDb = compileJsonDatabase();
      
      final List<String> targetPaths = [
        '/Users/sawantech/Desktop/Data/projects/upscLearn/assets/polity_content.json',
        '/Users/sawantech/Desktop/Data/projects/upsc_admin_dashboard/assets/polity_content.json',
      ];

      bool success = true;
      for (final path in targetPaths) {
        try {
          final file = File(path);
          final parentDir = file.parent;
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }
          await file.writeAsString(jsonDb);
        } catch (e) {
          print('Failed to write to $path: $e');
          success = false;
        }
      }

      // Also try relative paths as fallback/backup
      final List<String> relativePaths = [
        'assets/polity_content.json',
        '../upscLearn/assets/polity_content.json',
      ];
      for (final path in relativePaths) {
        try {
          final file = File(path);
          final parentDir = file.parent;
          if (await parentDir.exists()) {
            await file.writeAsString(jsonDb);
          }
        } catch (_) {}
      }

      return success;
    } catch (e) {
      print('Sync JSON database failed: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Loads an existing lesson into the editor workspace for manual / LLM editing.
  void selectExistingLesson(Lesson lesson, String moduleId) {
    _selectedSource = null;
    _isEditingExisting = true;
    _editingLessonId = lesson.id;
    _editingModuleId = moduleId;

    // Seed draft editors
    _editorLessonName = lesson.name;
    _editorLessonDescription = lesson.description;
    _editorReadingTime = lesson.readingTimeMinutes;
    _editorLessonContent = lesson.content;
    
    // Clear questions/revision cards during edit or mock reload
    _editorQuestions = [];
    _editorRevisionCards = [];

    notifyListeners();
  }

  /// Cancels the current editing session.
  void cancelEditing() {
    _isEditingExisting = false;
    _editingLessonId = null;
    _editingModuleId = null;
    _selectedSource = null;
    notifyListeners();
  }

  /// Simulates LLM text refinement to enhance lesson material, structure, and questions.
  Future<void> refineLessonWithLlm() async {
    _isLoading = true;
    notifyListeners();

    // Mock network processing delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Refined lesson text modification
    _editorLessonContent = '$_editorLessonContent\n\n## Refined In-Depth Analysis (LLM Enhanced)\n- **Context and Chronology**: This constitutional pillar must be read alongside relevant democratic conventions.\n- **Syllabus Key Insight**: Focus on structural features and fundamental landmark cases to build analytical arguments in civil services answers.';
    
    // Generate new mock practice questions based on the lesson text
    _editorQuestions = [
      QuizQuestion(
        id: 'q_refined_1_${DateTime.now().millisecondsSinceEpoch}',
        questionText: 'Which statement aligns with the refined in-depth analysis?',
        options: ['It is a justiciable check', 'It limits the basic structure', 'It was introduced in Kesavananda Bharati', 'It is non-justiciable'],
        correctOptionIndex: 0,
        explanation: 'The refined analysis reinforces that the constitutional pillar acts as a justiciable check and balances the rule of law.',
      )
    ];

    _editorRevisionCards = [
      RevisionCard(
        heading: 'Structural Context',
        body: 'The refined analysis emphasizes **structural features** and landmark constitutional cases as key building blocks for civil services answers.',
        tip: 'Focus on chronological case law timelines for maximum syllabus coverage.',
      ),
      RevisionCard(
        heading: 'Syllabus Mapping',
        body: 'Map each constitutional provision to its corresponding **landmark judgment** and amendment. This analytical framework is highly rewarded in UPSC mains answers.',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  /// Saves the active manually edited lesson back to the database.
  Future<void> saveExistingLessonEdit() async {
    final lessonId = _editingLessonId;
    final moduleId = _editingModuleId;
    if (lessonId == null || moduleId == null) return;

    _isLoading = true;
    notifyListeners();

    // Dynamically split edited markdown content into cards
    final generated = MarkdownCardParser.parseMarkdownToCards(_editorLessonContent, _editorLessonName);
    final cards = generated.map((c) => LessonCard(
      heading: c['heading']!,
      body: c['body']!,
    )).toList();

    final updatedLesson = Lesson(
      id: lessonId,
      name: _editorLessonName,
      description: _editorLessonDescription,
      readingTimeMinutes: _editorReadingTime,
      cards: cards,
    );

    try {
      await _contentRepository.insertApprovedContent(
        moduleId: moduleId,
        lesson: updatedLesson,
        questions: _editorQuestions,
        revisionCards: _editorRevisionCards,
      );

      // Reset editing flags
      _isEditingExisting = false;
      _editingLessonId = null;
      _editingModuleId = null;

      // Reload visualizer tree
      await loadSyllabus();
    } catch (e) {
      print('Failed to save existing lesson edit: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
