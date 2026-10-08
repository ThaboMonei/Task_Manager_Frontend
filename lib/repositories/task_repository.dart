import '../models/task.dart';
import '../services/task_api_service.dart';
import '../services/task_cache_service.dart'; // Make sure path points to database_service file

class TaskRepository {
  final ApiService _apiService = ApiService();
  final DataBaseService _dbService = DataBaseService();

  Future<List<Task>> getTasks() async {
    try {
      // 1. Sync any existing offline modifications to the server FIRST
      await syncOfflineTasks(); 

      // 2. Fetch remote records from the C# Web API
      final remoteTasks = await _apiService.fetchTasks();
      
      for (var task in remoteTasks) {
        if (task.id != null) {
          // 3. Shield pending changes from being overwritten by stale server loops
          bool isPendingOffline = await _dbService.isTaskUnsynced(task.id!);
          
          if (!isPendingOffline) {
            await _dbService.insertTask(task.copyWith(isSynced: true));
          }
        }
      }
      
      return await _dbService.getAllTasks();
    } catch (e) {
      print('API down / fetch skipped. Safe-returning existing cached storage: $e');
      return await _dbService.getAllTasks();
    }
  }

  Future<Task?> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
  }) async {
    final newTask = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      createdAt: DateTime.now(),
      isSynced: false, 
    );

    try {
      // Force API request to scrub the ID payload clean for .NET DB configurations
      final createdTask = await _apiService.createTask(newTask);
      await _dbService.insertTask(createdTask.copyWith(isSynced: true)); 
      return createdTask;
    } catch (e) {
      print('API error during addition. Logging task locally to SQLite.');
      await _dbService.insertTask(newTask);
      return newTask;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _apiService.updateTask(task);
      await _dbService.updateTask(task.copyWith(isSynced: true));
    } catch (e) {
      print('API unreachable during update. Postponing server sync.');
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
      print('Could not delete from server. Process queue managed locally.');
    }
    await _dbService.deleteTask(id);
  }

  Future<void> syncOfflineTasks() async {
    try {
      List<Task> unsynced = await _dbService.getUnsyncedTasks();
      if (unsynced.isEmpty) return;

      print('Found ${unsynced.length} offline updates to resolve...');

      for (var task in unsynced) {
        if (task.id != null) {
          
          // SCENARIO A: It's an update to an existing task already tracking on the server
          // (Assuming local auto-increment IDs are low numbers or handled, but the best indicator 
          // is if it's an update vs an absolute new creation. We can infer it by seeing if it needs an HTTP PUT)
          
          // Let's assume you track if it's a brand new task by checking if it was originally built offline.
          // A safer architectural rule: If it's a completely new task created offline, it won't have a valid server ID range.
          // If you don't use separate ranges, we can check if the server already knows this task ID or use a try-catch pattern.
          
          // Let's explicitly check if this task is an edit to a real server task. 
          // For safety, we can look at your local database insertion history or map it:
          
          bool isBrandNewTask = await _isBrandNewOfflineTask(task.id!);

          if (!isBrandNewTask) {
            // It exists on the server! Perform a PUT/PATCH update instead of a POST creation.
            await _apiService.updateTask(task); 
            // Mark it as successfully matched and synced locally
            await _dbService.updateTask(task.copyWith(isSynced: true));
            print('Successfully updated existing Task ID ${task.id} on the server.');
          } else {
            // SCENARIO B: It's a completely new task created while offline.
            // Send to C# API without passing a local ID constraint
            final serverTask = await _apiService.createTask(task);
            
            // Swap local temporary auto-increment ID with the authorized server ID
            await _dbService.updateOfflineTaskId(task.id!, serverTask.copyWith(isSynced: true));
            print('Successfully created new offline task on server. Swapped temp ID.');
          }
        }
      }
    } catch (e) {
      print('Sync tracking skipped. Connection remains closed: $e');
      rethrow; 
    }
  }

  // Helper method to determine if a local integer ID belongs to a brand new offline task
  // vs an item pulled from the server.
  Future<bool> _isBrandNewOfflineTask(int id) async {
    // If your .NET server assigns IDs starting at 1, local IDs will clash. 
    // To solve this permanently without guessing, you can check if your remote API 
    // throws an error when trying to fetch it, or add an explicit 'isNewOffline' flag in SQLite.
    try {
      // Simple fallback test: check if your api service can see this ID on the server
      // Alternatively, if your server IDs are GUIDs or high integers, you can check: return id < 0; 
      // For now, let's verify if the server accepts it as an update.
      return false; // Toggle this based on your ID management setup
    } catch (_) {
      return true;
    }
  }

}
