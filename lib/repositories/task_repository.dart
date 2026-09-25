import '../models/task.dart';
import '../services/task_api_service.dart';
import '../services/task_cache_service.dart';


class TaskRepository{
  final ApiService _apiService = ApiService();
  final DataBaseService _dbService = DataBaseService();

  Future<List<Task>> getTasks() async {
    try{
      final remoteTasks = await _dbService.getAllTasks();

  await _dbService.clearAll();
  for(var task in remoteTasks){
    await _dbService.insertTask(task);
  }
      return remoteTasks;
    }catch(e){
      print('API failed: $e'); 
      return _dbService.getAllTasks();
    }
  }

  Future<Task> addTask({
    required String title,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    }) async {
    final newTask = Task(title: title, dueDate: dueDate, priority: priority,);
    try{
      final createdTask = await _apiService.createTask(newTask);
      return createdTask;
    }catch(e){
      print('API failed, saving locally: $e');
      final localTask = Task(
        id: DateTime.now().millisecondsSinceEpoch * -1,
        title: title,
      );
      await _dbService.insertTask(localTask);
      return newTask;
    }
  }

  Future<void> toggleTask(Task task) async{
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      // description: task.description,
      createdAt: task.createdAt,
      isComplete: task.isComplete,
    );
    try{
      await _apiService.updateTask(updatedTask);
    }catch(e){
      print('API update failed: $e');
    }
    await _dbService.updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async{
    try{
      await _apiService.deleteTask(id);
    }catch(e){
      await _dbService.deleteTask(id);
    }
  }
}