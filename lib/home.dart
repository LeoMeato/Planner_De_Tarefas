import 'package:flutter/material.dart';
import 'package:planner_de_tarefas/helper.dart';
import 'package:planner_de_tarefas/model.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> boards = [];
  var boardsObj = [];

  TaskBoardHelper tbh = TaskBoardHelper();

  TextEditingController _controllerBoardName = TextEditingController();

  TextEditingController _controllerBoardColor = TextEditingController();
  @override
  void initState() {
    super.initState();
    InicializarOBJ();
  }

  void InicializarOBJ() async {
    var vr = await tbh.get();
    print("aqui");
    for (var v in vr) {
      Task_Board tb = Task_Board.fromMap(v);
      boardsObj.add(tb);
    }
  }

  @override
  Widget build(BuildContext context) {
    boards = [];
    for (var v in boardsObj) {
      boards.add(Card(
        shadowColor: Colors.black12,
        color: Colors.blue,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: 125,
          child: Text(v.name),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Task Board",
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
                    _controllerBoardName.text = "";
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
                            TextField(
                                controller: _controllerBoardColor,
                                decoration: InputDecoration(
                                    labelText:
                                        "Board color (ainda não faz nada)"),
                                onChanged: (text) {}),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancelar")),
                        TextButton(
                            onPressed: () {
                              Task_Board tb =
                                  Task_Board(_controllerBoardName.text, 0);
                              boardsObj.add(tb);
                              tbh.insert(tb);
                              _controllerBoardName.text = "";
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text("Criar")),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: boards,
        ),
      ),
    );
  }
}
