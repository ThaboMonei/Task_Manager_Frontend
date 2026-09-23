import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'widgets/empty_task_list.dart';
import 'widgets/task_tile.dart';
import '../task_details/task_details_mobile_view.dart';

class TaskListMobileView extends StatefulWidget{
  const TaskListMobileView({super.key});

  @override
  State<TaskListMobileView> createState() => _TaskListMobileViewState();
}

class _TaskListMobileViewState extends State<TaskListMobileView>{
 final TaskRepository _repository = TaskRepository();
 List<Task> _tasks =[];
 bool _isLoading = true;

 @override
 void initState(){
  super.initState();
  _loadTasks();
 }

 Future<void> _loadTasks() async{
  setState(() => _isLoading = true);
  try{
  final tasks = await _repository.getTasks();
  setState((){
    _tasks = tasks;
    _isLoading = false;
  });
 }catch(e, stack){
  print('LOAD ERROR: $e');
  print(stack);
  setState(() => _isLoading = false);
 }
 }

 Future<void> _openAddTask() async{
  final added = await Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (_) => const TaskDetailsMobileView(),
    ),
  );
  if(added == true) _loadTasks();
 }

 Future<void> _toggle(Task task) async{
  await _repository.toggleTask(task);
  _loadTasks();
 }

 Future<void> _delete(int id) async{
  await _repository.deleteTask(id);
  _loadTasks();
 }

 @override
 Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(title: const Text('Tasks')),
    body: _isLoading 
      ? const Center(child: CircularProgressIndicator())
      : _tasks.isEmpty
      ? const EmptyTaskList()
      : ListView.builder(itemCount: _tasks.length,
      itemBuilder: (context, i){
        final task = _tasks[i];
        return TaskTile(
          task: task,
          onToggle: () => _toggle(task),
          onDelete: () => _delete(task.id!),
          onTap: () {},
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: _openAddTask,
    child: const Icon(Icons.add)),
  );
 }
}