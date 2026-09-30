
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/empty_task_list.dart';
import 'widgets/task_tile.dart';
import '../task_details/task_details_view.dart';
import 'task_list_view_model.dart';
import '/models/task.dart';



class TaskListView extends StatelessWidget{
  const TaskListView({super.key});

Future<void> _confirmDelete(BuildContext context, Task task) async{
  final ok = await showDialog<bool>(context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Delete task'),
    content: Text('Delete "${task.title}"?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(ctx, false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(ctx, true),
        child: const Text('Delete'),
      ),
    ],
  ),
  );
  if(ok == true && context.mounted){
    await context.read<TaskListViewModel>().delete(task.id!);
  }
}

@override
 Widget build(BuildContext context){
  final vm = context.watch<TaskListViewModel>();
  return Scaffold(
    appBar: AppBar(title: const Text('Tasks')),
    body: vm.isLoading 
      ? const Center(child: CircularProgressIndicator())
      : vm.tasks.isEmpty
      ? const EmptyTaskList()
      : ListView.builder(
        itemCount: vm.tasks.length,
      itemBuilder: (context, i){
        final task = vm.tasks[i];
        return TaskTile(
          task: task,
          onToggle: () => vm.toggle(task),
          onDelete: () => _confirmDelete(context,task),
          onTap: () async{
            final changed = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:(_) => TaskDetailsView(task: task),
              ),
            );
             if(changed == true) vm.load();
          },       
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () async{
      final added = await Navigator.push(
        context, 
      MaterialPageRoute(
        builder: (_) => const TaskDetailsView(),
      ),
      );
      if(added == true) vm.load();
    },
    child: const Icon(Icons.add)),
  );
 }
}


