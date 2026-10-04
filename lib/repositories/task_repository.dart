import '../models/task.dart';
import '../services/task_api_service.dart';
import '../services/task_cache_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final DataBaseService _dbService = DataBaseService();

Future<List<Task>> getTasks() async {
  try {
    await syncOfflineTasks(); 
    final remoteTasks = await _apiService.fetchTasks();
    for (var task in remoteTasks) {
      await _dbService.insertTask(task);
    }
  
    return await _dbService.getAllTasks();
  } catch (e) {
    print('API failed: using cache: $e'); 
    return await _dbService.getAllTasks();
  }
}



  Future<Task?> addTask({
    //Parameter values to create the task
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
  }) async {
    //Task to be created using parameter values
    final newTask = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      createdAt: DateTime.now(),
      isSynced: false, 
    );

    try {
      final createdTask = await _apiService.createTask(newTask);
      await _dbService.insertTask(createdTask); // Saves with server ID and isSynced = true
      return createdTask;
    } catch (e) {
      print('API down during add. Saving locally as unsynced.');
      //Saving locally without backend
      await _dbService.insertTask(newTask);
      return newTask;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _apiService.updateTask(task);
      await _dbService.updateTask(task.copyWith(isSynced: true));
    } catch (e) {
      print('API down during update. Saving modification locally.');
      await _dbService.updateTask(task.copyWith(isSynced: false));
    }
  }

  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask); 
  }

  Future<void> deleteTask(int id) async {
    try {
      if (id > 0) {
        await _apiService.deleteTask(id);
      }
    } catch (e) {
      print('Could not delete from server. Item removed locally.');
    }
    await _dbService.deleteTask(id);
  }


  Future<void> syncOfflineTasks() async {
  try {
    List<Task> unsynced = await _dbService.getUnsyncedTasks();
    if (unsynced.isEmpty) return;

    print('Found ${unsynced.length} pending items to sync...');

    for (var task in unsynced) {
            if (task.id != null && !task.isSynced) {
        final cleanOfflineTask = Task(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          priority: task.priority,
          createdAt: task.createdAt,
          isCompleted: task.isCompleted,
        );

        final serverTask = await _apiService.createTask(cleanOfflineTask);
        
        await _dbService.updateOfflineTaskId(task.id!, serverTask);
      }
    }
  } catch (e) {
    print('Sync cycle skipped. Backend is still down: $e');
  }
}
}
