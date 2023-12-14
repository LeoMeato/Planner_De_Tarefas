import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model.dart';

abstract class Helper {
  late final tableName;
  Database? _db;

  Helper(this.tableName);

  initDb() async {
    final dbPath = await getDatabasesPath();
    print(tableName);
    final path = join(dbPath, tableName + ".db");

    Database db = await openDatabase(path, version: 1, onCreate: _onCreateDb);

    return db;
  }

  void _onCreateDb(Database db, int version);

  Future<Database?> get db async {
    
    _db ??= await initDb();

    return _db;
  }

  Future<int> insert(Table t) async {
    var database = await db;

    int result = await database!.insert(tableName, t.toMap());

    return result;
  }

  Future<int> update(Table t) async {
    var database = await db;

    int result = await database!
        .update(tableName, t.toMap(), where: "id=?", whereArgs: [t.id]);

    return result;
  }

  Future<int> delete(int id) async {
    var database = await db;

    int result =
        await database!.delete(tableName, where: "id=?", whereArgs: [id]);

    return result;
  }

  Future<List> get() async {
    
    var database = await db;
    
    String sql = "SELECT * FROM $tableName;";

    List results = await database!.rawQuery(sql);

    return results;
  }
}

class TaskHelper extends Helper {
  TaskHelper() : super("task");
  void _onCreateDb(Database db, int version) {
    String sql = """
    CREATE TABLE task(
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
);
    """;

    db.execute(sql);
  }
}

class TaskBoardHelper extends Helper {
  TaskBoardHelper() : super("task_board");
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
}

class UserHelper extends Helper {
  UserHelper() : super("task");
  void _onCreateDb(Database db, int version) {
    String sql = """
    CREATE TABLE user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
);
    """;

    db.execute(sql);
  }
}
