import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:flutter/material.dart';

class Planner extends StatefulWidget {
  const Planner({super.key});

  static const routeName = "/planner";

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Id;
    int taskBoardId = args.id;
    return Scaffold(body: Center(child: Text("$taskBoardId")),);
  }
}
