import 'package:flutter/foundation.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskDetailsViewModel extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  String title = '';
  String? description;
  DateTime? dueDate;
  Priority priority = Priority.medium;
  bool isSaving = false;
  String? error;
  Task? _editing;
  bool get isEditing => _editing != null;

  void init(Task? task){
    _editing = task;
    if(task != null){
      title = task.title;
      description = task.description;
      dueDate = task.dueDate;
      priority = task.priority;
    }
    
    notifyListeners();
  }

  void setTitle(String v){title = v; notifyListeners();}
  void setDescription(String v){description = v.isEmpty ? null : v; notifyListeners();}
  void setDueDate(DateTime? v){dueDate = v; notifyListeners();}
  void setPriority(Priority v){priority = v; notifyListeners();}

  Future<bool> save() async{
    isSaving = true;
    error = null;
    notifyListeners();

    try{
      if(_editing == null){
        await _repository.addTask(
          title: title,
          description: description,
          dueDate : dueDate,
          priority: priority,
           );
        }else{
          final updated = Task(
            id: _editing!.id,
            title: title,
            description: description,
            isCompleted: _editing!.isCompleted,
            dueDate: dueDate,
            priority: priority,
            createdAt: _editing!.createdAt,
          );
          await _repository.updateTask(updated);
        }

        isSaving = false;
        notifyListeners();
        return true;
    }catch(e){
      error = 'Could not save task. Try again';
      isSaving = false;
      notifyListeners();
      return false;
          }
  }
}