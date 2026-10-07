import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskListViewModel extends ChangeNotifier{
  final TaskRepository _repository = TaskRepository();

  List<Task> tasks = [];
  bool isLoading = false;
  String? error;
  Task? taskSearch;

  Future<void> load() async{
    isLoading = true;
    error = null;
    notifyListeners();
    try{
    tasks = await _repository.getTasks();
    }catch(e){
      error = 'Could not load tasks. Check your connection and try again';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> searchTask(String title) async{
    tasks = await _repository.getTasks();
    // print('THIS IS A LIST LENGTH!!!!!!!!!!!');
    // print(tasks.length);
    if(title.isNotEmpty){
      for(var task in tasks){

        if(task.title.contains(title)){
          taskSearch = task;
        }
        ///throw Exception('Task does not exist');
      }
      notifyListeners;
    }
    
    
  }

  Future<void> addTask(String title, String? description,DateTime? dueDate, Priority priority) async{
    try{
    await _repository.addTask(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      );
      await load();
    }catch(e){
      error = 'Could not add task.Check your connection and try again';
      notifyListeners();
    }
  }

  Future<void> toggle(Task task) async{
    try{
    await _repository.toggleTask(task); 
    await load();
    }catch(e){
      error = 'Could not check task';
      notifyListeners();
    }
     }

     Future<void> delete(int id) async{
      try{
      await _repository.deleteTask(id);
      await load();
      }catch(e){
        error = 'Could not delete task';
        notifyListeners();
      }
     }

     Future<void> update(Task task) async{
      try{
      await _repository.updateTask(task);
      await load();
      }catch(e){
        error = 'Could not update task';
        notifyListeners();
        }
     }

     void clearError(){
      error = null;
      notifyListeners();
     }
}