import 'package:flutter/material.dart';
import 'package:planner_de_tarefas/helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> boards = [];

  TaskBoardHelper tbh = TaskBoardHelper();

  TextEditingController _controllerBoardName = TextEditingController();

  TextEditingController _controllerBoardColor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    @override
  void initState() {
    super.initState();
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
                              boards.add(Card(
                                shadowColor: Colors.black12,
                                color: Colors.blue,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  height: 125,
                                  child: Text(_controllerBoardName.text),
                                ),
                              ));
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
