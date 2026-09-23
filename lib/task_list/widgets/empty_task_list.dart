import 'package:flutter/material.dart';

class EmptyTaskList extends StatelessWidget{
  const EmptyTaskList({super.key});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('No tasks yet',
          style: TextStyle(fontSize:18,color: Colors.grey)),
        ]
      ),
    );
  }
}
