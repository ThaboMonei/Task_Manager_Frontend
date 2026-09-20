import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';


class ApiService {
  // GET /api/products
  Future<Task> addTask(Task task) async {
    final url = Uri.parse('${ApiConfig.baseUrl}api/tasks');
    final response = await http.post(url);
    
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
