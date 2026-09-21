import '../models/task.dart';
import '../services/task_api_service.dart';
import '../services/task_cache_service.dart';


class TaskRepository{
  final ApiService _apiService = ApiService();
  final DataBaseService _dbService = DataBaseService();

  Future<List<Task>> getTasks() async {
    try{
      final remoteTasks = await _apiService.fetchTasks();

  await _dbService.clearAll();
  for(var task in remoteTasks){
    await _dbService.insertTask(task);
  }
      return remoteTasks;
    }catch(e){
      print('API failed'); 
      return _dbService.getAllTasks();
    }
  }

  Future<Task> addTask(String title) async {
    final newTask = Task(title: title);
    try{
      final createdTask = await _apiService.createTask(newTask);
      return createdTask;
    }catch(e){
      print('API failed');
      return newTask;
    }
  }

  Future<void> toggleTask(Task task) async{
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      description: task.description,
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

  Future<void> deleteTodo(int id) async{
    try{
      await _apiService.deleteTask(id);
    }catch(e){
      await _dbService.deleteTask(id);
    }
  }
}