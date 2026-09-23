import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DataBaseService{
  static Database? _database;
  static const String _tableName = "tasks";

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Task_app2.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async{
      await db.execute('''
    CREATE TABLE $_tableName(
    id INTEGER PRIMARY KEY,
    task TEXT NOT NULL,
    isComplete INTEGER NOT NULL,
    priority INTEGER NOT NULL
    )
''');
    },
    );
  }

Future<List<Task>> getAllTasks() async{
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(_tableName);
  return maps.map((map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate'] as String) : null,
    description: map['description'],
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    isComplete: map['isComplete'] == 1,
    priority: Priority.values[map['priority'] as int],
  )).toList();
}

Future<void> insertTask(Task task) async{
  final db = await database;
  await db.insert(_tableName,
  {
    'id': task.id,
    'title': task.title,
    'dueDate': task.dueDate?.toIso8601String(),
    'description': task.description,
    'isComplete': task.isComplete ? 1 : 0,
    'priority': task.priority.index,
    'createdAt': task.createdAt?.toIso8601String(),
  },
  conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateTask(Task task) async{
  final db = await database;
  await db.update(_tableName,{'title': task.title, 'isComplete': task.isComplete ? 1 : 0,'priority': task.priority.index},where: 'id = ?',whereArgs: [task.id],
  );
}

Future<void> deleteTask(int id) async{
  final db = await database;
  await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
}

Future<void> clearAll() async{
  final db = await database;
  await db.delete(_tableName);
}

}
