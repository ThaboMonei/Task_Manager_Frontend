import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_list/task_list_mobile_view.dart';
import 'task_list/task_list_view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main(){
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }
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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          overscroll: false,
        ),
        home: const TaskListMobileView(),
        );
    }
  }