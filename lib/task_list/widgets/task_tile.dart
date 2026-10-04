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

void _showDescription(BuildContext context){
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(task.title),
      content: SingleChildScrollView(
        child: Text(task.description ?? ''),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context){
  final hasDescription = task.description != null && task.description!.trim().isNotEmpty;
  return ListTile(
    onTap: onTap, 
    tileColor: Colors.grey[200],
    leading: Checkbox(
      value: task.isCompleted,
      onChanged: (_) => onToggle(),
    ),
    title: Row(
      children: [
        Expanded(
          child:  Text(
          task.title,
          style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    ),
  ),
  if(hasDescription)
  TextButton(
    child: const Text('view'),
    onPressed: () => _showDescription(context),
  ),
      ],
    ),
    subtitle: task.dueDate != null ? Text('Due: ${task.dueDate!.toString().split(' ')[0]}') 
    : null,
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onDelete,
      )
    );
}
}