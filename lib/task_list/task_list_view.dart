
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
    appBar: AppBar( 
      title:const Text('Tasks'),
      actions:[
       IconButton(
      
         icon: const Icon(Icons.add),
    onPressed: () async{
      final added = await Navigator.push(
        context, 
      MaterialPageRoute(
        builder: (_) => const TaskDetailsView(),
      ),
      );
      if(added == true) vm.load();
    },
   
    ),
      ]
      ),
    body:Column( 
      children: [
        Padding(
          padding: const .all(8.0),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller){
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: (){
                  
                },
                onChanged: (_){
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (context, SearchController controller){
              final query = controller.text;

                if(query.isEmpty){
                  return [const Center(child: Text('Type a title to search'))];
                }
                print(query);
                vm.searchTask(query);

                return [ 
                  ListTile(
                  tileColor: Colors.grey[150],
                  title: Text('${vm.taskSearch?.title}'),
                  subtitle: Text(vm.taskSearch?.description ?? ''),
                  onTap: (){},
                ),
                ];
            },
            ),
            
        ),

       Expanded(
        child: vm.isLoading 
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
       ),
      
      ],
    ),
    );

 }
}


