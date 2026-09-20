import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';


class ApiService {
final String _baseUrl = ApiConfig.baseUrl;

//get /api/tasks
Future<List<Task>> fetchTasks() async{
  final response = await http.get(Uri.parse('$_baseUrl/tasks'));
  if(response.statusCode == 200){
    final List<dynamic> body = jsonDecode(response.body);
    return body.map((item) => Task.fromJson(item)).toList();
  }
  throw Exception('Failed to load tasks');
}

  // post /api/tasks
  Future<Task> createTask(Task task) async {
    final url = Uri.parse('$_baseUrl/tasks');
    final response = await http.post(url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(task.toJson()));
    
    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
