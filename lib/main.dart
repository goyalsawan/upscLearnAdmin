import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/providers.dart';
import 'data/database_helper.dart';
import 'data/repositories/content_repository.dart';
import 'ui/dashboard/admin_dashboard_view.dart';
import 'ui/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Boot and initialize all database helper, repository, and view model instances
  final dbHelper = DatabaseHelper.instance;
  final contentRepository = ContentRepository(dbHelper);
  final subjects = await contentRepository.getAllSubjects();

  runApp(
    ProviderScope(
      overrides: [
        subjectsProvider.overrideWithValue(subjects),
      ],
      child: const MyApp(),
    ),
  );
}

/// The main application widget for the admin control panel.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminViewModel = ref.watch(adminViewModelProvider);

    return MaterialApp(
      title: 'upscLearn Admin Panel',
      theme: AppTheme.darkTheme, // Custom dark theme for visual hierarchy
      debugShowCheckedModeBanner: false,
      home: AdminDashboardView(viewModel: adminViewModel),
    );
  }
}
