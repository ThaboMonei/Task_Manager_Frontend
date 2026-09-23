import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'due_date_field.dart';

class TaskForm extends StatelessWidget{
  final TextEditingController titleController;
  final DateTime? dueDate;
  final ValueChanged<DateTime?> onDueDateChanged;
  final Priority priority;
  final ValueChanged<Priority> onPriorityChanged;
  final VoidCallback onSubmit;

  const TaskForm({
    super.key,
    required this.titleController,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.priority,
    required this.onPriorityChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            )
          ),
          const SizedBox(height: 16),
          DueDateField(
            value: dueDate,
            onChanged: onDueDateChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Priority>(
            value: priority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
            ),
            items: Priority.values
            .map((p) => DropdownMenuItem(
              value: p,
              child: Text(p.name),
            )).toList(),
            onChanged: (v){
              if (v != null) onPriorityChanged(v);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
