import 'package:flutter/material.dart';
import 'package:flutter_empty_state/flutter_empty_state.dart';
import 'repositories/task_repository.dart';
import 'models/task.dart';
import 'services/task_api_service.dart';

void main()  async {
  print('hello');
  final api = ApiService();
  final tasks = await api.fetchTasks();
  print(tasks);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task app',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const HomePage(title: 'Task List'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final TaskRepository _repository = TaskRepository();
final TextEditingController _controller = TextEditingController();

@override
void initState(){
  super.initState();
}

//add function
Future<void> _addTask() async {
  if(_controller.text.trim().isEmpty) {
    print("You did not imput text");
  }
  final task = _controller.text.trim();
  _controller.clear();
  await _repository.addTask(task);
}

  @override
  Widget build(BuildContext context) {
    List<String> _tasks = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
             const Text('''           Empty List
No currently added tasks.'''
),
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    children: [
      Expanded(
        child:TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Add a new task...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: _addTask,
        color: Colors.black,
        iconSize: 40,
      ),
    ],
  ),
),
            
             SizedBox(height: 20),
            FloatingActionButton.extended(
        onPressed: null,
        label: const Text('Add Task'),
      ),
          ],
        ),
        
      ),
      
    );
  }
}
