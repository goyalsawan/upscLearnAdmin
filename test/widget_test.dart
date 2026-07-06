import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:upsc_admin_dashboard/main.dart';
import 'package:upsc_admin_dashboard/app/providers.dart';
import 'package:upsc_admin_dashboard/data/database.dart';
import 'package:upsc_admin_dashboard/data/database_helper.dart';
import 'package:upsc_admin_dashboard/data/repositories/content_repository.dart';
import 'package:upsc_admin_dashboard/data/models.dart';
import 'package:upsc_admin_dashboard/ui/view_models/admin_view_model.dart';
import 'package:upsc_admin_dashboard/ui/dashboard/admin_dashboard_view.dart';

void main() {
  testWidgets('Admin dashboard loads and displays metrics', (WidgetTester tester) async {
    // Set simulated viewport sizes to prevent mock constraints overflows
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final db = AppDatabase.executor(NativeDatabase.memory());
    DatabaseHelper.testDatabase = db;

    final dbHelper = DatabaseHelper.instance;
    final contentRepository = ContentRepository(dbHelper);
    final List<Subject> subjects = [];
    
    final viewModel = AdminViewModel(contentRepository, subjects);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subjectsProvider.overrideWithValue(subjects),
          databaseHelperProvider.overrideWithValue(dbHelper),
          contentRepositoryProvider.overrideWithValue(contentRepository),
          adminViewModelProvider.overrideWith((ref) => viewModel),
        ],
        child: const MyApp(),
      ),
    );

    // Allow async loading to trigger
    await tester.pump();

    // Verify visual presence of dashboard elements
    expect(find.byType(AdminDashboardView), findsOneWidget);
    expect(find.text('Console Dashboard'), findsOneWidget);
    expect(find.text('Syllabus Visualizer'), findsOneWidget);

    await db.close();
  });
}
