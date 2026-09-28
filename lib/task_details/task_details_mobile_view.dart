import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'widgets/task_form.dart';
import '../task_list/task_list_view_model.dart';


class TaskDetailsMobileView extends StatefulWidget{
  final Task? task;
  const TaskDetailsMobileView({super.key,this.task});

  @override
  State<TaskDetailsMobileView> createState() => _TaskDetailsMobileViewState();
}

class _TaskDetailsMobileViewState extends State<TaskDetailsMobileView>{
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repository = TaskRepository();
  final _formKey = GlobalKey<FormState>();

  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  bool _isSaving = false;

@override
void initState(){
  super.initState();
  if(widget.task != null){
    _titleController.text = widget.task!.title;
    _descriptionController.text = widget.task!.description ?? '';
    _dueDate = widget.task!.dueDate;
    _priority = widget.task!.priority;
  }
}

  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    if(!_formKey.currentState!.validate()){
      return;
    }
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final desc = description.isEmpty ? null : description;
    if(_isSaving) return ;
    setState(() => _isSaving = true);

    final vm = context.read<TaskListViewModel>();

  try{
    if(widget.task == null){
    await vm.addTask(
       title,
       desc,
      _dueDate,
      _priority,
    );
    }else{
      final updated = Task(
        id: widget.task!.id,
        title: title,
        description: desc,
        isCompleted: widget.task!.isCompleted,
        dueDate: _dueDate,
        priority: _priority,
        createdAt: widget.task!.createdAt,
      );
      await vm.update(updated);
    }

    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.task == null ? 'Task added' : 'Task updated')),
    );
    Navigator.pop(context, true);
  }catch(e){
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: $e')),
      );
      setState(() => _isSaving = false);
  }
  }
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title: Text(widget.task == null ? 'New Task' : 'Edit Task'), ),
        body: TaskForm(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          dueDate: _dueDate,
          onDueDateChanged: (d) => setState(() => _dueDate = d),
          priority: _priority,
          onPriorityChanged: (p) => setState(() => _priority = p),
          onSubmit: _submit,
        ),
      );
    }
  }
