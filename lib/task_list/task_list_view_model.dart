import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskListViewModel{
  final TaskRepository _repository = TaskRepository();

  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> load() async{
    isLoading = true;
    tasks = await _repository.getTasks();
    isLoading = false;
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
}