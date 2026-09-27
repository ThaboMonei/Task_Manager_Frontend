import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskListViewModel extends ChangeNotifier{
  final TaskRepository _repository = TaskRepository();

  List<Task> tasks = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async{
    isLoading = true;
    error = null;
    notifyListeners();
    try{
    tasks = await _repository.getTasks();
    }catch(e){
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, DateTime? dueDate, Priority priority) async{
    await _repository.addTask(
      title: title,
      dueDate: dueDate,
      priority: priority,
      );
      await load();
  }

  Future<void> toggle(Task task) async{
    await _repository.toggleTask(task); 
    await load();
     }

     Future<void> delete(int id) async{
      await _repository.deleteTask(id);
      await load();
     }

     Future<void> update(Task task) async{
      await _repository.updateTask(task);
      await load();
     }
}