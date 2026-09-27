import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/empty_task_list.dart';
import 'widgets/task_tile.dart';
import '../task_details/task_details_mobile_view.dart';
import 'task_list_view_model.dart';



class TaskListMobileView extends StatelessWidget{
  const TaskListMobileView({super.key});

@override
 Widget build(BuildContext context){
  final vm = context.watch<TaskListViewModel>();
  return Scaffold(
    appBar: AppBar(title: const Text('Tasks')),
    body: vm.isLoading 
      ? const Center(child: CircularProgressIndicator())
      : vm.tasks.isEmpty
      ? const EmptyTaskList()
      : ListView.builder(itemCount: vm.tasks.length,
      itemBuilder: (context, i){
        final task = vm.tasks[i];
        return TaskTile(
          task: task,
          onToggle: () => vm.toggle(task),
          onDelete: () => vm.delete(task.id!),
          onTap: () async{
            final changed = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:(_) => TaskDetailsMobileView(task: task),
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
        builder: (_) => const TaskDetailsMobileView(),
      ),
      );
      if(added == true) vm.load();
    },
    child: const Icon(Icons.add)),
  );
 }
}
