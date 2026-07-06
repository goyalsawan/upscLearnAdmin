import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:upsc_admin_dashboard/data/database.dart';
import 'package:upsc_admin_dashboard/data/database_helper.dart';
import 'package:upsc_admin_dashboard/data/repositories/content_repository.dart';
import 'package:upsc_admin_dashboard/data/models.dart';
import 'package:upsc_admin_dashboard/ui/view_models/admin_view_model.dart';

void main() {
  group('AdminViewModel Tests', () {
    late AppDatabase db;
    late DatabaseHelper dbHelper;
    late ContentRepository contentRepository;
    late String originalAdminFileContent;
    late String originalAppFileContent;
    late bool adminFileExisted;
    late bool appFileExisted;

    setUp(() async {
      db = AppDatabase.executor(NativeDatabase.memory());
      DatabaseHelper.testDatabase = db;
      dbHelper = DatabaseHelper.instance;
      contentRepository = ContentRepository(dbHelper);

      final adminFile = File('assets/polity_content.json');
      adminFileExisted = await adminFile.exists();
      if (adminFileExisted) {
        originalAdminFileContent = await adminFile.readAsString();
      }

      final appFile = File('../upscLearn/assets/polity_content.json');
      appFileExisted = await appFile.exists();
      if (appFileExisted) {
        originalAppFileContent = await appFile.readAsString();
      }
    });

    tearDown(() async {
      await db.close();

      // Restore original files to avoid Git pollution
      final adminFile = File('assets/polity_content.json');
      if (adminFileExisted) {
        await adminFile.writeAsString(originalAdminFileContent);
      } else if (await adminFile.exists()) {
        await adminFile.delete();
      }

      final appFile = File('../upscLearn/assets/polity_content.json');
      if (appFileExisted) {
        await appFile.writeAsString(originalAppFileContent);
      } else if (await appFile.exists()) {
        await appFile.delete();
      }
    });

    test('compileJsonDatabase outputs valid JSON structure', () {
      final subject = const Subject(
        id: 'polity',
        name: 'Indian Polity',
        description: 'Constitution',
        iconName: 'gavel',
        units: [],
      );
      final viewModel = AdminViewModel(contentRepository, [subject]);
      final jsonStr = viewModel.compileJsonDatabase();
      expect(jsonStr, contains('"id": "polity"'));
      expect(jsonStr, contains('"name": "Indian Polity"'));
    });

    test('writeAndSyncJsonDatabase writes compiled JSON data to target files', () async {
      final subject = const Subject(
        id: 'polity_test',
        name: 'Polity Test Subject',
        description: 'Test Description',
        iconName: 'gavel',
        units: [],
      );
      final viewModel = AdminViewModel(contentRepository, [subject]);

      // Execute writeAndSyncJsonDatabase
      final success = await viewModel.writeAndSyncJsonDatabase();
      expect(success, isTrue);

      final adminFile = File('assets/polity_content.json');
      final appFile = File('../upscLearn/assets/polity_content.json');

      expect(await adminFile.exists(), isTrue);
      expect(await appFile.exists(), isTrue);

      final content = await adminFile.readAsString();
      expect(content, contains('Polity Test Subject'));
      expect(content, contains('polity_test'));
    });
  });
}
