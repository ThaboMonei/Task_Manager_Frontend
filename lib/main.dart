import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list/task_list_mobile_view.dart';
import 'task_list/task_list_view_model.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create:(_) => TaskListViewModel()..load(),
    child: MyApp()),
  );
  }

  class MyApp extends StatelessWidget{
    const MyApp({super.key});

    @override
    Widget build(BuildContext context){
      return MaterialApp(
        title: 'Task App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const TaskListMobileView(),
        );
    }
  }