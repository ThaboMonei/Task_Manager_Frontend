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
      print('API failed: using cache: $e'); 
      return await _dbService.getAllTasks();
    }
  }

  Future<Task?> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    }) async {
    final newTask = Task(title: title,description: description, dueDate: dueDate, priority: priority,);
    
      final createdTask = await _apiService.createTask(newTask);
      await _dbService.insertTask(createdTask);
      return createdTask;
  
  }

  //update task
  Future<void> updateTask(Task task) async {
      await _apiService.updateTask(task);
    await _dbService.updateTask(task);
  }

  Future<void> toggleTask(Task task) async{
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      description: task.description,
      createdAt: task.createdAt,
      isCompleted: !task.isCompleted,
      priority: task.priority,
    );
    
      await _apiService.updateTask(updatedTask);
    await _dbService.updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async{
    if(id > 0){
      await _apiService.deleteTask(id);
    }
      await _dbService.deleteTask(id);
    
  }
}