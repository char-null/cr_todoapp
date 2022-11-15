import 'dart:io';
import 'package:cr_todoapp/src/model/todo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String tablename = 'todo';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        isCompleted TEXT,
        writedDate TEXT
        )''');
  }

  Future<List<Todo>> getTodo() async {
    Database db = await instance.database;
    var todo = await db.query(tablename);
    List<Todo> todolist =
        todo.isNotEmpty ? todo.map((c) => Todo.fromJson(c)).toList() : [];
    return todolist;
  }

  // Future<List<Todo>> getJobofDay(DateTime day) async {
  //   Database db = await instance.database;
  //   var job = await db.query(tablename,
  //       where: 'uploaddate=?',
  //       whereArgs: [DateFormat.yMMMMd('ko').format(day)]);
  //   List<Job> jobList =
  //       job.isNotEmpty ? job.map((e) => Job.fromMap(e)).toList() : [];
  //   return jobList;
  // }

  Future<int> addTodo(Todo todo) async {
    Database db = await instance.database;
    return await db.insert('todo', todo.toJson());
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete('todo', where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateTodo(Todo todo, int id) async {
    Database db = await instance.database;
    return await db
        .update('todo', todo.toJson(), where: 'id=?', whereArgs: [id]);
  }

  // Future<int> updatecloseJob(Job job, int? index) async {
  //   Database db = await instance.database;
  //   return await db
  //       .update('job', job.toMap(), where: 'id=?', whereArgs: [index]);
  // }
}
