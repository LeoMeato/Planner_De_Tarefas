class Task extends Table{
  late String title;
  int? isCompleted;
  late int user_id;
  late int board_id;
  late String note;
  late String date;
  late String startTime;
  late String endTime;

  Task(this.title, this.user_id, this.board_id, this.note, this.date,
      this.startTime, this.endTime,
      {isCompleted = 0});

  Task.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.isCompleted = map["isCompleted"];
    this.user_id = map["user_id"];
    this.board_id = map["board_id"];
    this.note = map["note"];
    this.date = map["date"];
    this.startTime = map["startTime"];
    this.endTime = map["endTime"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "isCompleted": this.isCompleted,
      "user_id": this.user_id,
      "board_id": this.board_id,
      "note": this.note,
      "date": this.date,
      "startTime": this.startTime,
      "endTime": this.endTime
    };

    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}

class Task_Board extends Table{
  late String name;
  late int color;

  Task_Board(this.name, this.color);

  Task_Board.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.color = map["color"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": this.name, "color": this.color};

    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}

class User extends Table {
  late String name;
  late String email;
  late String password;

  User(this.name, this.email, this.password);

  User.fromMap(Map map) {
    this.id = map["id"];
    this.name = map["name"];
    this.email = map["email"];
    this.password = map["password"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email,
      "password": this.password
    };

    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}

abstract class Table {
  int? id;
  Map<String, dynamic> toMap();
}
