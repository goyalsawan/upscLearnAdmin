import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/repositories/content_repository.dart';
import '../data/models.dart';
import '../ui/view_models/admin_view_model.dart';
import 'app_dependencies.dart';

/// Orchestrates the sequential startup sequence of the admin dashboard application.
class AppBootstrapper {
  AppBootstrapper._();

  /// Runs asynchronous startup processes (database open, repositories setup,
  /// initial data loading) and returns the completed [AppDependencies] container.
  static Future<AppDependencies> initialize() async {
    // 1. Ensure Flutter bindings are ready
    WidgetsFlutterBinding.ensureInitialized();

    // 2. Initialize DatabaseHelper singleton
    final dbHelper = DatabaseHelper.instance;

    // 3. Setup repositories
    final contentRepository = ContentRepository(dbHelper);

    // 4. Load initial content subjects (from cache on Web, from SQLite on Native)
    List<Subject> subjects = [];
    try {
      subjects = await contentRepository.getAllSubjects();
    } catch (e) {
      print('Database loader initialization failed, starting with empty subjects: $e');
    }

    // 5. Initialize view model singletons
    final adminViewModel = AdminViewModel(contentRepository, subjects);

    return AppDependencies(
      contentRepository: contentRepository,
      adminViewModel: adminViewModel,
      subjects: subjects,
    );
  }
}
