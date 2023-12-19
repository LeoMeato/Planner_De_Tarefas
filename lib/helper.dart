import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model.dart';

class Helper {
  Database? _db;

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "planta.db");

    Database db = await openDatabase(path, version: 1, onCreate: _onCreateDb);

    return db;
  }

  void _onCreateDb(Database db, int version) {
    String sql1 = """
    CREATE TABLE if not exists task(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    board_id INTEGER NOT NULL,
    title VARCHAR NOT NULL,
    note TEXT NOT NULL,
    date VARCHAR NOT NULL,
    startTime VARCHAR NOT NULL,
    endTime VARCHAR NOT NULL,
    isCompleted INTEGER,
    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(board_id) REFERENCES task_board(id)
);""";
    String sql2 = """
CREATE TABLE if not exists task_board(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    color INTEGER NOT NULL
);""";
    String sql3 = """CREATE TABLE if not exists user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
);
    """;

    db.execute(sql1);
    db.execute(sql2);
    db.execute(sql3);
  }

  Future<Database?> get db async {
    _db ??= await initDb();

    return _db;
  }

  Future<int> insert(String tableName, Model t) async {
    var database = await db;

    int result = await database!.insert(tableName, t.toMap());

    return result;
  }



  Future<int> update(String tableName, Model t) async {
    var database = await db;

    int result = await database!
        .update(tableName, t.toMap(), where: "id=?", whereArgs: [t.id]);

    return result;
  }

  Future<int> updateTask(String tableName, Model t, int id) async {
    var database = await db;

    int result = await database!
        .update(tableName, t.toMap(), where: "id=?", whereArgs: [id]);

    return result;
  }

  Future<int> delete(String tableName, int id) async {
    var database = await db;

    int result =
        await database!.delete(tableName, where: "id=?", whereArgs: [id]);

    return result;
  }

  Future<List> get(String tableName) async {
    var database = await db;

    String sql = "SELECT * FROM $tableName;";

    List results = await database!.rawQuery(sql);

    return results;
  }

  select(sql) async {
    var database = await db;

    List results = await database!.rawQuery(sql);

    return results;
  }

  tmp() async {
    var database = await db;
    String sql1 = """
    CREATE TABLE if not exists task(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    board_id INTEGER NOT NULL,
    title VARCHAR NOT NULL,
    note TEXT NOT NULL,
    date VARCHAR NOT NULL,
    startTime VARCHAR NOT NULL,
    endTime VARCHAR NOT NULL,
    isCompleted INTEGER,
    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(board_id) REFERENCES task_board(id)
);""";
    String sql2 = """
CREATE TABLE if not exists task_board(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    color INTEGER NOT NULL
);""";
    String sql3 = """CREATE TABLE if not exists user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
);
    """;

    database!.execute(sql1);
    database!.execute(sql2);
    database!.execute(sql3);
  }
}
/*

class TaskBoardHelper {
  static final tableName = "task_board";
  static Database? _db;
  static final TaskBoardHelper _taskBoardHelper = TaskBoardHelper._internal();

  factory TaskBoardHelper() {
    return _taskBoardHelper;
  }

  TaskBoardHelper._internal();

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "task_board.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;

  }

  void _onCreateDb(Database db, int version) {
    String sql = """
    CREATE TABLE task_board(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    color INTEGER NOT NULL
);
    """;

    db.execute(sql);

  }

  Future<Database?> get db async {

    _db ??= await initDb();

    return _db;
  }

  Future<int> insert(Task_Board task) async {
    var database = await db;
    print("Insert Task");

    int result = await database!.insert(
      tableName,
      task.toMap()
    );

    return result;
  }

  Future<int> update(Task_Board task) async {
    var database = await db;

    int result = await database!.update(
      tableName,
      task.toMap(),
      where: "id=?",
      whereArgs: [task.id]
    );

    return result;
  }

  Future<int> delete(int id) async {
    var database = await db;

    int result = await database!.delete(
      tableName,
      where: "id=?",
      whereArgs: [id]
    );

    return result;
  }

  get() async {
    var database = await db;

    String sql = "SELECT * FROM $tableName;";

    List results = await database!.rawQuery(sql);

    return results;
  }
}*/