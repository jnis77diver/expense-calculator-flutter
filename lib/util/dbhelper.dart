import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

// this is how you create a singleton
class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblTodo = 'todo';
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  // this is a named constructor which is empty;
  DbHelper._internal();

  // in unnamed constructor, return the object we created above
  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.toMap());
    return result; // if returns 0, something went wrong, otherwise will return the id of the record
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblTodo"));
    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),
        where: "$colId = ?", whereArgs: [todo.id]);
    return result; // if returns 0, something went wrong, otherwise will return the id of the record
  }

  Future<int> deleteTodo(String id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblTodo WHERE $colId = $id");
    return result;
  }
}
