import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'due_date_field.dart';

class TaskForm extends StatelessWidget{
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? dueDate;
  final ValueChanged<DateTime?> onDueDateChanged;
  final Priority priority;
  final ValueChanged<Priority> onPriorityChanged;
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;

  const TaskForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.priority,
    required this.onPriorityChanged,
    required this.onSubmit,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context){
    return Form(
      key: formKey,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            validator: (value){
              if(value == null || value.trim().isEmpty){
                return 'Title is required';
              }
              if(value.trim().length < 3 ){
                return '3 characters required';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            )
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description(optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
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
            child: const Text('Create Task'),
          ),
        ],
      ),
    ),
    );
  }
}
