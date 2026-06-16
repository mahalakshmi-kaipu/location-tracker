import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/location_model.dart';

class LocalStorageProvider {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'location_tracker_v4.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT,
            accuracy REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE settings(
            key TEXT PRIMARY KEY,
            value INTEGER
          )
        ''');
        await db.insert('settings', {'key': 'isTracking', 'value': 0});
      },
    );
  }

  Future<int> insertLocation(LocationModel location) async {
    final db = await database;
    return await db.insert('locations', location.toJson());
  }

  Future<List<LocationModel>> getAllLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('locations', orderBy: 'timestamp DESC');
    return List.generate(maps.length, (i) => LocationModel.fromJson(maps[i]));
  }

  Future<void> clearAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }

  Future<void> setTrackingState(bool isTracking) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': 'isTracking', 'value': isTracking ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> getTrackingState() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['isTracking'],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] == 1;
    }
    return false;
  }
}
