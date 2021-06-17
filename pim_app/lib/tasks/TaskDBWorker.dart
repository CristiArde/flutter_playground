import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import "../utils.dart" as utils;
import 'TaskModel.dart';

class TaskDBWorker {
  static final TaskDBWorker _instance = new TaskDBWorker._internal();
  static late final Future<Database>? _database;
  static late final _initDBMemoizer;

  TaskDBWorker._internal() {
    _initDBMemoizer = AsyncMemoizer<Database>();
  }

  static TaskDBWorker get instance => _instance;

  Future<Database> get database async =>
      _database ??
      await _initDBMemoizer.runOnce(() async {
        return await _initDB();
      });

  Future<Database> _initDB() async {
    print("## Tasks TasksDBWorker.init()");
    String path = join(utils.docsDir!.path, "tasks.db");
    print("## tasks TasksDBWorker.init(): path = $path");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS tasks ("
          "id INTEGER PRIMARY KEY,"
          "description TEXT,"
          "dueDate TEXT,"
          "completed TEXT"
          ")");
    });
  }

  /// Create a Task from a Map.
  Task taskFromMap(Map inMap) {
    print("## Tasks TasksDBWorker.taskFromMap(): inMap = $inMap");

    Task task = Task();
    task.id = inMap["id"];
    task.description = inMap["description"];
    task.dueDate = inMap["dueDate"];
    task.complete = inMap["completed"];

    print("## Tasks TasksDBWorker.taskFromMap(): task = $task");

    return task;
  }

  /* End taskFromMap(); */

  /// Create a Map from a Task.
  Map<String, dynamic> taskToMap(Task inTask) {
    print("## tasks TasksDBWorker.taskToMap(): inTask = $inTask");

    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inTask.id;
    map["description"] = inTask.description;
    map["dueDate"] = inTask.dueDate;
    map["completed"] = inTask.complete;

    print("## tasks TasksDBWorker.taskToMap(): map = $map");

    return map;
  }

  /// Create a task.
  ///
  /// @param  inTask The Task object to create.
  /// @return        Future.
  Future create(Task task) async {
    print("## Tasks TasksDBWorker.create(): inTask = $task");

    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM tasks");
    var id = val.first["id"];
    if (id == null) {
      id = 1;
    }
    // Insert into table.
    return await db.rawInsert("INSERT INTO tasks (id, description, dueDate, completed) VALUES (?, ?, ?, ?)", [id, task.description, task.dueDate, task.complete]);
  }

  /// Get a specific task.
  ///
  /// @param  inID The ID of the task to get.
  /// @return      The corresponding Task object.
  Future<Task> get(int id) async {
    print("## Tasks TasksDBWorker.get(): inID = $id");

    Database db = await database;
    var rec = await db.query("tasks", where: "id = ?", whereArgs: [id]);

    print("## Tasks TasksDBWorker.get(): rec.first = $rec.first");

    return taskFromMap(rec.first);
  }

  /// Get all tasks.
  ///
  /// @return A List of Task objects.
  Future<List> getAll() async {
    print("## Tasks TasksDBWorker.getAll()");

    Database db = await database;
    var recs = await db.query("tasks");
    var list = recs.isNotEmpty ? recs.map((m) => taskFromMap(m)).toList() : [];

    print("## Tasks TasksDBWorker.getAll(): list = $list");

    return list;
  }

  /* End getAll(). */

  /// Update a task.
  ///
  /// @param  inTask The task to update.
  /// @return        Future.
  Future update(Task task) async {
    print("## Tasks TasksDBWorker.update(): inTask = $task");

    Database db = await database;
    return await db.update("tasks", taskToMap(task), where: "id = ?", whereArgs: [task.id]);
  }

  /* End update(). */

  /// Delete a task.
  ///
  /// @param  inID The ID of the task to delete.
  /// @return      Future.
  Future delete(int id) async {
    print("## Taasks TasksDBWorker.delete(): inID = $id");

    Database db = await database;
    return await db.delete("Tasks", where: "id = ?", whereArgs: [id]);
  }
}
