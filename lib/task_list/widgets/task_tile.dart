import 'package:flutter/material.dart';
import '../../models/task.dart';

class TaskTile extends StatelessWidget{
final Task task;
final VoidCallback onToggle;
final VoidCallback onDelete;
final VoidCallback onTap;

const TaskTile({
  super.key,
  required this.task,
  required this.onToggle,
  required this.onDelete,
  required this.onTap,
});

@override
Widget build(BuildContext context){
  return ListTile(
    onTap: onTap, 
    leading: Checkbox(
      value: task.isCompleted,
      onChanged: (_) => onToggle(),
    ),
    title: Text(
      task.title,
      style: TextStyle(
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    ),
    subtitle: task.dueDate != null ? Text('Due: ${task.dueDate!.toLocal().toString().split('')[0]}') 
    : null,
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onDelete,
      )
    );
}
}