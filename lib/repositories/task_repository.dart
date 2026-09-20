import '../models/task.dart';
import '../services/task_api_service.dart';


class TaskRepository{
  final ApiService _apiService = ApiService();

  Future<Task> addTask(String title) async {
    final newTask = Task(
      title: title
    );

    try{
      final createdTask = await _apiService.addTask(newTask);
      return createdTask;
    }catch(e){
      print('API failed');
      return newTask;
    }
  }
}