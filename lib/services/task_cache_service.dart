import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DataBaseService {
  static Database? _database;
  static const String _tableName = "tasks";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Task_app2.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title TEXT NOT NULL,
          description TEXT,
          isComplete INTEGER NOT NULL,
          dueDate TEXT,
          priority INTEGER NOT NULL,
          createdAt TEXT,
          isSynced INTEGER NOT NULL DEFAULT 0 
        )
      ''');
    });
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return maps.map((map) => Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
      description: map['description'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      isCompleted: map['isComplete'] == 1,
      priority: Priority.values[map['priority'] as int],
      isSynced: map['isSynced'] == 1, 
    )).toList();
  }

  Future<List<Task>> getUnsyncedTasks() async {
    final db = await database;
    final maps = await db.query(_tableName, where: 'isSynced = 0');
    return maps.map((map) => Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
      description: map['description'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      isCompleted: map['isComplete'] == 1,
      priority: Priority.values[map['priority'] as int],
      isSynced: false,
    )).toList();
  }

  Future<bool> isTaskUnsynced(int id) async {
    final db = await database;
    final maps = await db.query(_tableName, where: 'id = ? AND isSynced = 0', whereArgs: [id]);
    return maps.isNotEmpty;
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    
    final Map<String, dynamic> row = {
      'title': task.title,
      'dueDate': task.dueDate?.toIso8601String(),
      'description': task.description,
      'isComplete': task.isCompleted ? 1 : 0,
      'priority': task.priority.index,
      'createdAt': task.createdAt?.toIso8601String(),
      'isSynced': task.isSynced ? 1 : 0,
    };

    if (task.id != null) {
      row['id'] = task.id;
    }

    await db.insert(
      _tableName,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'title': task.title,
        'isComplete': task.isCompleted ? 1 : 0,
        'priority': task.priority.index,
        'description': task.description,
        'isSynced': task.isSynced ? 1 : 0, 
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> updateOfflineTaskId(int tempId, Task serverTask) async {
    final db = await database;
    // Safely discard the temporary client increment record
    await db.delete(_tableName, where: 'id = ?', whereArgs: [tempId]);
    // Save the official server mapping configuration
    await insertTask(serverTask);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    try {
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Database error: $e');
    }
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
