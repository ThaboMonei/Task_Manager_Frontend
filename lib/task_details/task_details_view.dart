import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/task.dart";
import "task_details_view_model.dart";
import "widgets/task_form.dart";

class TaskDetailsView extends StatelessWidget {
  final Task? task;
  const TaskDetailsView({super.key, this.task});

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create:(_) => TaskDetailsViewModel(),
      child: const _TaskDetailsBody(),
    );
  }
}

class _TaskDetailsBody extends StatefulWidget{
  const _TaskDetailsBody();

  @override
  State<_TaskDetailsBody> createState() => _TaskDetailsBodyState();
}

class _TaskDetailsBodyState extends State<_TaskDetailsBody>{
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(_initialized) return;
    final vm = context.read<TaskDetailsViewModel>();
    _titleController.text = vm.title;
    _descriptionController.text = vm.description ?? '';
    _initialized = true;
  }

  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    try{
    if(!_formKey.currentState!.validate()) return;
    }catch(e){
      print('The error on submit: $e');
    }
    final vm = context.read<TaskDetailsViewModel>();
    vm.setTitle(_titleController.text.trim());
    vm.setDescription(_descriptionController.text.trim());

    final ok = await vm.save();
    if(!mounted) return;

    if(ok) Navigator.pop(context, true);
   }

   @override
   Widget build(BuildContext context){
    final vm = context.watch<TaskDetailsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(vm.isEditing ? 'Edit Task' : 'New Task')),
      body: TaskForm(
        formKey: _formKey,
        titleController: _titleController,
        descriptionController: _descriptionController,
        dueDate: vm.dueDate,
        onDueDateChanged: vm.setDueDate,
        priority: vm.priority,
        onPriorityChanged: vm.setPriority,
        onSubmit: _submit,
      ),
    );
   }
}