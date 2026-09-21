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
    String path = join(await getDatabasesPath(), 'Task_app.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async{
      await db.execute('''
    CREATE TABLE $_tableName(
    id INTEGER PRIMARY KEY,
    task TEXT NOT NULL,
    isComplete INTEGER NOT NULL
    )
''');
    },
    );
  }

Future<List<Task>> getAllTasks() async{
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(_tableName);
  return maps.map((map) => Task(
    id: map['id'],
    title: map['title'],
    dueDate: map['dueDate'],
    description: map['description'],
    createdAt: map['createdAt'],
    isComplete: map['isComplete'],
  )).toList();
}

Future<void> insertTask(Task task) async{
  final db = await database;
  await db.insert(_tableName,
  {
    'id': task.id,
    'title': task.title,
    'dueDate': task.dueDate,
    'description': task.description,
    'isComplete': task.isComplete,
  },
  conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateTask(Task task) async{
  final db = await database;
  await db.update(_tableName,{'title': task.title, 'isComplete': task.isComplete ? 1 : 0},where: 'id = ?',whereArgs: [task.id],
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
