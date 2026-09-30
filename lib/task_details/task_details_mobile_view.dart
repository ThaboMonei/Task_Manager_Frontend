import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_details_view.dart';

class TaskDetailsMobileView extends StatelessWidget{
  final Task? task;
  const TaskDetailsMobileView({super.key, this.task});

  @override
  Widget build(BuildContext context) => TaskDetailsView();
}