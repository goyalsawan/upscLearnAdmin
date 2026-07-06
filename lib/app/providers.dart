import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_helper.dart';
import '../data/models.dart';
import '../data/repositories/content_repository.dart';
import '../ui/view_models/admin_view_model.dart';

/// Preloaded Subject list provider, overridden in main.dart
final subjectsProvider = Provider<List<Subject>>((ref) {
  throw UnimplementedError('subjectsProvider must be overridden');
});

/// Database Helper provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

/// Content Repository provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return ContentRepository(dbHelper);
});

/// Admin ViewModel provider (ChangeNotifier)
final adminViewModelProvider = ChangeNotifierProvider<AdminViewModel>((ref) {
  final contentRepository = ref.watch(contentRepositoryProvider);
  final subjects = ref.watch(subjectsProvider);
  return AdminViewModel(contentRepository, subjects);
});
