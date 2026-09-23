import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'widgets/task_form.dart';


class TaskDetailsMobileView extends StatefulWidget{
  const TaskDetailsMobileView({super.key});

  @override
  State<TaskDetailsMobileView> createState() => _TaskDetailsMobileViewState();
}

class _TaskDetailsMobileViewState extends State<TaskDetailsMobileView>{
  final _titleController = TextEditingController();
  final _repository = TaskRepository();

  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  bool _isSaving = false;

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    final title = _titleController.text.trim();
    if(title.isEmpty || _isSaving) return ;

    setState(() => _isSaving = true);

    await _repository.addTask(
      title: title,
      dueDate: _dueDate,
      priority: _priority,
    );

    if(!mounted) return;
    Navigator.pop(context, true);
  }
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title: const Text('New Task'), ),
        body: TaskForm(
          titleController: _titleController,
          dueDate: _dueDate,
          onDueDateChanged: (d) => setState(() => _dueDate = d),
          priority: _priority,
          onPriorityChanged: (p) => setState(() => _priority = p),
          onSubmit: _submit,
        ),
      );
    }
  }
