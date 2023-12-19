import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:Planner_De_Tarefas/helper.dart';
import 'package:Planner_De_Tarefas/model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

var list = ["Amarelo", "Laranja", "Vermelho", "Azul", "Verde", "Rosa"];

class Planner extends StatefulWidget {
  const Planner({super.key});

  static const routeName = "/planner";

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  void initState() {
    helper.initDb();
    InicializarOBJ();
    super.initState();
  }

  int userID = 1;
  int boardID = 1;

  List<Widget> empty = [];
  List<Widget> tasks = [];
  var tasksObj = [];

  Helper helper = Helper();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerNote = TextEditingController();
  TextEditingController _controllerStart = TextEditingController();
  TextEditingController _controllerEnd = TextEditingController();
  TextEditingController _controllerDelete = TextEditingController();
  TextEditingController _controllerCompleted = TextEditingController();

  String dropdownValue = list.first;
  int color = 0;
  List<dynamic> totalList = [];

  void InicializarOBJ() async {
    await helper.tmp();
    var vr = await helper.get("task");
    for (var v in vr) {
      Task tb = Task.fromMap(v);
      if (tb.user_id == userID && tb.board_id == boardID) {
        tasksObj.add(tb);
      }
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Id;
    int taskBoardId = args.id;
    int userId = args.id2;
    tasks = [];

    for (var v in tasksObj) {
      String dataDia =
          "${_focusedDay.day}/${_focusedDay.month}/${_focusedDay.year}";
      print(dataDia);
      var cor = Color.fromARGB(255, 219, 90, 90);
      if (v.date == dataDia) {
        cor = Color.fromARGB(255, 86, 98, 209);
      }
      if (v.isCompleted == 1) {
        cor = Colors.green;
      }
      tasks.add(
        GestureDetector(
          child: Card(
            shadowColor: Colors.black12,
            color: cor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 120,
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.title),
                      Text("Note: ${v.note}"),
                      Text("Date: ${v.date}"),
                      Text("Start: ${v.startTime}"),
                      Text("End: ${v.endTime}")
                    ],
                  )),
            ),
          ),
          onTap: () {
            _controllerName.text = v.title;
            _controllerDate.text = v.date;
            _controllerEnd.text = v.endTime;
            _controllerNote.text = v.note;
            _controllerStart.text = v.startTime;

            if (v.isCompleted == 1) {
              _controllerCompleted.text = "1";
            } else {
              _controllerCompleted.text = "0";
            }
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Update Task"),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 370,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: _controllerName,
                              decoration:
                                  InputDecoration(labelText: "Task name"),
                              onChanged: (text) {},
                              //       style: TextStyle(fontSize: 13),
                            ),
                            TextField(
                              controller: _controllerNote,
                              decoration: InputDecoration(labelText: "Note"),
                              onChanged: (text) {},
                              //       style: TextStyle(fontSize: 13),
                            ),
                            TextField(
                              controller: _controllerDate,
                              decoration: InputDecoration(
                                  labelText: "Date (DD/MM/YYYY)"),
                              onChanged: (text) {},
                              //       style: TextStyle(fontSize: 13),
                            ),
                            TextField(
                              controller: _controllerStart,
                              decoration: InputDecoration(
                                  labelText: "Start Time (HH:MM)"),
                              onChanged: (text) {},
                              //       style: TextStyle(fontSize: 13),
                            ),
                            TextField(
                              controller: _controllerEnd,
                              decoration: InputDecoration(
                                  labelText: "End Time (HH:MM)"),
                              onChanged: (text) {},
                              //       style: TextStyle(fontSize: 13),
                            ),
                            TextField(
                              controller: _controllerCompleted,
                              decoration: InputDecoration(
                                  labelText: "Completed(1) or Not(0)"),
                              onChanged: (text) {},
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _controllerName.text = "";
                            _controllerDate.text = "";
                            _controllerNote.text = "";
                            _controllerEnd.text = "";
                            _controllerStart.text = "";
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            helper.delete("task", v.id);
                            tasksObj = [];
                            InicializarOBJ();
                            _controllerName.text = "";
                            _controllerDate.text = "";
                            _controllerNote.text = "";
                            _controllerEnd.text = "";
                            _controllerStart.text = "";
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("Remove")),
                      TextButton(
                          onPressed: () {
                            if (_controllerCompleted.text == "1") {
                              v.isCompleted = 1;
                            } else {
                              v.isCompleted = 0;
                            }
                            Task t = Task(
                                _controllerName.text,
                                userID,
                                boardID,
                                _controllerNote.text,
                                _controllerDate.text,
                                _controllerStart.text,
                                _controllerEnd.text,
                                isCompleted: v.isCompleted);

                            //helper.insert("task", Task("title", userId, 1, "note", "date", "startTime", "endTime"));
                            helper.updateTask("task", t, v.id);
                            tasksObj = [];
                            InicializarOBJ();
                            _controllerName.text = "";
                            _controllerDate.text = "";
                            _controllerNote.text = "";
                            _controllerEnd.text = "";
                            _controllerStart.text = "";
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text("Update")),
                    ],
                  );
                });
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back, color: Colors.purple,),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Task",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              child: Icon(
                Icons.add,
                color: Colors.purple,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Add Task"),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 300,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _controllerName,
                                  decoration:
                                      InputDecoration(labelText: "Task name"),
                                  onChanged: (text) {},
                                  //       style: TextStyle(fontSize: 13),
                                ),
                                TextField(
                                  controller: _controllerNote,
                                  decoration:
                                      InputDecoration(labelText: "Notes"),
                                  onChanged: (text) {},
                                  //      style: TextStyle(fontSize: 13),
                                ),
                                TextField(
                                  controller: _controllerDate,
                                  decoration: InputDecoration(
                                      labelText: "Date (DD/MM/YYYY)"),
                                  onChanged: (text) {},
                                  //     style: TextStyle(fontSize: 13),
                                ),
                                TextField(
                                  controller: _controllerStart,
                                  decoration: InputDecoration(
                                      labelText: "Start Time (HH:MM)"),
                                  onChanged: (text) {},
                                  //  style: TextStyle(fontSize: 13),
                                ),
                                TextField(
                                  controller: _controllerEnd,
                                  decoration: InputDecoration(
                                      labelText: "End Time (HH:MM)"),
                                  onChanged: (text) {},
                                  //     style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                _controllerName.text = "";
                                _controllerDate.text = "";
                                _controllerNote.text = "";
                                _controllerEnd.text = "";
                                _controllerStart.text = "";
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar")),
                          TextButton(
                              onPressed: () {
                                Task t = Task(
                                    _controllerName.text,
                                    userID,
                                    boardID,
                                    _controllerNote.text,
                                    _controllerDate.text,
                                    _controllerStart.text,
                                    _controllerEnd.text,
                                    isCompleted: 0);

                                //helper.insert("task", Task("title", userId, 1, "note", "date", "startTime", "endTime"));
                                helper.insert("task", t);
                                print(t);
                                print("adicionou");
                                tasksObj = [];
                                InicializarOBJ();
                                _controllerName.text = "";
                                _controllerDate.text = "";
                                _controllerNote.text = "";
                                _controllerEnd.text = "";
                                _controllerStart.text = "";
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Criar")),
                        ],
                      );
                    });
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: empty +
              [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      print(_selectedDay);
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                )
              ] +
              tasks,
        ),
      ),
    );
  }
}
