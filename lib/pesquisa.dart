import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:Planner_De_Tarefas/helper.dart';
import 'package:Planner_De_Tarefas/model.dart';
import 'package:flutter/material.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  static const routeName = "/pesquisa";

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  TextEditingController _controllerPesquisa = TextEditingController();
  var tasksObj = [];
  List<Widget> tasks = [];
  Helper helper = Helper();

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerEnd = TextEditingController();
  TextEditingController _controllerNote = TextEditingController();
  TextEditingController _controllerStart = TextEditingController();
  TextEditingController _controllerCompleted = TextEditingController();


  atualizaObj(String txt, int uid) async {
    String sql = """
    SELECT * FROM task
    WHERE task.user_id = ${uid} AND task.date = '$txt';
""";
    var l = await helper.select(sql);
    tasksObj = [];
    for (var v in l) {
      tasksObj.add(Task.fromMap(v));
    }
  }

  atualiza(txt, uid) async {
      await atualizaObj(txt, uid);
      tasks = [];
    for (var v in tasksObj) {
      print("aqui");
      tasks.add(GestureDetector(
        child: Container(
          height: 50,
          //color: Colors.amber[600],
          child: Center(
              child: Text('${v.title} ${v.date} ${v.startTime}-${v.endTime}', style: TextStyle(fontSize: 15),)),
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
                            atualiza(txt, uid);
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
                                v.user_id,
                                v.board_id,
                                _controllerNote.text,
                                _controllerDate.text,
                                _controllerStart.text,
                                _controllerEnd.text,
                                isCompleted: v.isCompleted);

                            helper.updateTask("task", t, v.id);
                            tasksObj = [];
                            atualiza(txt, uid);
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
      ));
    }
    setState(() {
      
    });
    }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Id;
    int userId = args.id;
    

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Pesquisa",
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.purple,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              TextField(
                  controller: _controllerPesquisa,
                  decoration: InputDecoration(
                    labelText: "Data",
                    hintText: "DD/MM/YYYY",
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (text) {
                    atualiza(text, userId);
                    setState(() {
                      
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: tasks,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
