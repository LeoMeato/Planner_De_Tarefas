import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:flutter/material.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  static const routeName = "/pesquisa";

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  TextEditingController _controllerPesquisa = TextEditingController();
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
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
                controller: _controllerPesquisa,
                decoration: InputDecoration(labelText: "Data", hintText: "DD/MM/YYYY", icon: Icon(Icons.search),),
                onChanged: (text) {})
          ],
        ),
      ),
    );
  }
}
