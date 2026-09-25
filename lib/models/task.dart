enum Priority{low, medium, high}

class Task{
  final int? id;
  final String title;
  // final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final Priority priority;

  Task(
    {
      this.id,
      required this.title,
       this.dueDate,
      // this.description,
       this.createdAt,
      this.isCompleted = false,
      this.priority = Priority.medium,
      });

    factory Task.fromJson(Map<String,dynamic> json){
      try{
      return Task(
        id: json['id'],
        title: json['title'] as String? ?? '',
        dueDate: json['dueDate'] !=  null ? DateTime.tryParse(json['dueDate'] as String) : null,
        // description: json['description'] as String? ?? 'null',
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String): null,
        isCompleted: json['isCompleted'] ?? false,
        priority: _parsePriority(json['priority'] as int?),
      );

      }catch(e){
        print('fromJson FAILED for: $json');
        print('Error: $e');
        rethrow;
      };
    }

    Map<String, dynamic> toJson(){
      return {
        if(id != null)
        'id': id,
        'title': title,
        if(dueDate != null)'dueDate': dueDate!.toIso8601String(),
        // 'description': description,
        if(createdAt != null)'createdAt': createdAt!.toIso8601String(),
        'isCompleted': isCompleted,
        'priority': priority.index,
      };
    }
}

Priority _parsePriority(int? value){
  switch(value){
    case 0: return Priority.low;
    case 1: return Priority.medium;
    case 2:  return Priority.high;
    default: return Priority.medium;
  }
}