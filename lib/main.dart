import 'dart:io';

import 'package:Planner_De_Tarefas/helper.dart';
import 'package:Planner_De_Tarefas/login.dart';
import 'package:Planner_De_Tarefas/model.dart';
import 'package:Planner_De_Tarefas/pesquisa.dart';
import 'package:Planner_De_Tarefas/planner.dart';
import 'package:Planner_De_Tarefas/tarefas_concluidas.dart';
import 'package:Planner_De_Tarefas/tarefas_recentes.dart';
import 'package:Planner_De_Tarefas/testes.dart';
import 'package:flutter/material.dart';
import 'package:Planner_De_Tarefas/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if(Platform.isLinux || Platform.isWindows){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MaterialApp(
    title: 'Planner de Tarefas',
    initialRoute: "/",
    routes: {
      Login.routeName: (context) => Login(),
      //Home.routeName: (context) => Home(),
      Planner.routeName: (context) => Planner(),
      Pesquisa.routeName: (context) => Pesquisa(),
      TarefasRecentes.routeName: (context) => TarefasRecentes(),
      TarefasConcluidas.routeName: (context) => TarefasConcluidas(),
    },
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}