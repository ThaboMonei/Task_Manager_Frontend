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
  return Column(
  children: [
    ListTile(
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
  Column(
    children:[
  Chip(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    label:Text(task.priority.name.toUpperCase()),
    backgroundColor: task.priority.name == 'low' 
    ? Colors.yellow :  task.priority.name == 'medium'  
    ? Colors.orange :  task.priority.name == 'high'
    ? Colors.red : Colors.orange,
    ),

  if(hasDescription)
  TextButton(
    
    onPressed: () => _showDescription(context),
    style: TextButton.styleFrom(
      fixedSize: const Size(1,1),
    ),
    child: const Text('view'),
  ),
      ],
    ),
    
      ]
    ),
    subtitle: task.dueDate != null ? Text('Due: ${task.dueDate!.toString().split(' ')[0]}') 
    : null,
    trailing: IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onDelete,
      
      ),
  ),

     SizedBox(height: 12),
  ],
  ); 
}
}