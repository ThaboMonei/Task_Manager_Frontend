import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_details_view.dart';

class TaskDetailsDesktopView extends StatelessWidget{
  final Task? task;
  const TaskDetailsDesktopView({super.key,this.task});

  @override
  Widget build(BuildContext context) => TaskDetailsView(task: task);
}