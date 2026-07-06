import 'package:flutter/foundation.dart' show kIsWeb;
import 'database.dart';
import 'database_seeder.dart';

/// Database helper inside upsc_admin_dashboard to manage the SQLite database lifecycle.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static AppDatabase? _database;

  DatabaseHelper._init();

  static set testDatabase(AppDatabase? db) => _database = db;

  Future<AppDatabase?> get database async {
    if (kIsWeb) return null; // No native SQLite support on Web browser
    if (_database != null) return _database!;
    
    final db = AppDatabase();
    _database = db;
    
    // Seed initial content if database was just created
    try {
      final subjectsList = await db.select(db.subjects).get();
      if (subjectsList.isEmpty) {
        await DatabaseSeeder.seedInitial(db);
      }
    } catch (_) {}
    
    return _database!;
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
