import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:Planner_De_Tarefas/pesquisa.dart';
import 'package:Planner_De_Tarefas/planner.dart';
import 'package:Planner_De_Tarefas/tarefas_concluidas.dart';
import 'package:Planner_De_Tarefas/tarefas_recentes.dart';
import 'package:flutter/material.dart';
import 'package:Planner_De_Tarefas/helper.dart';
import 'package:Planner_De_Tarefas/model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Planner_De_Tarefas/login.dart';

var list = ["Amarelo", "Laranja", "Vermelho", "Azul", "Verde", "Rosa"];

class Home extends StatefulWidget {
  const Home({required this.userId, super.key});
  final int userId;

  static const routeName = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> boards = [];
  var boardsObj = [];

  Helper helper = Helper();

  TextEditingController _controllerBoardName = TextEditingController();

  int color = 0;
  @override
  void initState() {
    helper.initDb();
    InicializarOBJ();
    super.initState();
  }

  void InicializarOBJ() async {
    await helper.tmp();
    var vr = await helper.get("task_board");
    for (var v in vr) {
      Task_Board tb = Task_Board.fromMap(v);
      boardsObj.add(tb);
    }
    setState(() {});
  }

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    int userId = widget.userId;
    boards = [];
    MaterialColor c;
    for (var v in boardsObj) {
      switch (v.color) {
        case 0:
          c = Colors.yellow;
          break;
        case 1:
          c = Colors.orange;
          break;
        case 2:
          c = Colors.red;
          break;
        case 3:
          c = Colors.blue;
          break;
        case 4:
          c = Colors.green;
          break;
        case 5:
          c = Colors.pink;
          break;
        default:
          c = Colors.yellow;
      }
      boards.add(GestureDetector(
        child: Card(
          shadowColor: Colors.black12,
          color: c,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            height: 125,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(v.name), Text("Total: ${v.qtdTasks}")],
                )),
          ),
        ),
        onTap: () {
          print(v.id);
          Navigator.pushNamed(context, Planner.routeName,
              arguments: Id(v.id, id2: userId));
        },
      ));
    }

    getQtd() async {
      for (var v in boardsObj) {
        String sql = """
        SELECT count(*) FROM task
        WHERE task.user_id = ${userId} AND task.board_id = ${v.id};
""";
        var l = await helper.select(sql);
        int qtd = 0;

        qtd = l[0]["count(*)"];

        v.qtdTasks = qtd;
      }
      setState(() {});
    }

    getQtd();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Colors.purple,
            ),
            onTap: () {
              //helper.insert("task", Task("titleB", userId, 1, "note", "21/12/2023", "10:00", "11:00"));
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: Text("Add board"),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          height: 120,
                          child: Column(
                            children: [
                              TextField(
                                  controller: _controllerBoardName,
                                  decoration:
                                      InputDecoration(labelText: "Board name"),
                                  onChanged: (text) {}),
                              DropdownButton<String>(
                                isExpanded: true,
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 3,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  dropdownValue = value!;
                                  setState(() {});
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                _controllerBoardName.text = "";
                                Navigator.pop(context);
                              },
                              child: Text("Cancelar")),
                          TextButton(
                              onPressed: () {
                                switch (dropdownValue) {
                                  case "Amarelo":
                                    color = 0;
                                    break;
                                  case "Laranja":
                                    color = 1;
                                    break;
                                  case "Vermelho":
                                    color = 2;
                                    break;
                                  case "Azul":
                                    color = 3;
                                    break;
                                  case "Verde":
                                    color = 4;
                                    break;
                                  case "Rosa":
                                    color = 5;
                                    break;
                                }
                                Task_Board tb = Task_Board(
                                    _controllerBoardName.text, color);

                                helper.insert("task_board", tb);
                                boardsObj = [];
                                InicializarOBJ();
                                _controllerBoardName.text = "";
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Criar")),
                        ],
                      );
                    });
                  });
            },
          ),
          PopupMenuButton(
              icon:
                  Icon(Icons.menu), //don't specify icon if you want 3 dot menu
              color: Colors.purple,
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "Deslogar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        "Pesquisar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text(
                        "Tarefas Recentes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 3,
                      child: Text(
                        "Tarefas Concluídas",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
              onSelected: (item) {
                switch (item) {
                  case 0:
                    Navigator.pop(context);
                    break;
                  case 1:
                    Navigator.pushNamed(context, Pesquisa.routeName,
                        arguments: Id(userId));
                    break;
                  case 2:
                    Navigator.pushNamed(context, TarefasRecentes.routeName,
                        arguments: Id(userId));
                    break;
                  case 3:
                    Navigator.pushNamed(context, TarefasConcluidas.routeName,
                        arguments: Id(userId));
                    break;
                }
              }),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: boards),
        ),
      ),
    );
  }
}
