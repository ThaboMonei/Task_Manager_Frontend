enum Priority{low, medium, high}

class Task{
  final int? id;
  final String title;
  // final String? description;
  final bool isComplete;
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
      this.isComplete = false,
      this.priority = Priority.medium,
      });

    factory Task.fromJson(Map<String,dynamic> json){
      return Task(
        id: json['id'],
        title: json['title'] as String? ?? '',
        dueDate: json['dueDate'] !=  null ? DateTime.tryParse(json['dueDate'] as String) : null,
        // description: json['description'] as String? ?? 'null',
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createAt'] as String): null,
        isComplete: json['isComplete'] ?? false,
        priority: _parsePriority(json['priority'] as int?),
      );
    }

    Map<String, dynamic> toJson(){
      return {
        if(id != null)
        'id': id,
        'title': title,
        if(dueDate != null)'dueDate': dueDate!.toIso8601String(),
        // 'description': description,
        if(createdAt != null)'createdAt': createdAt!.toIso8601String(),
        'isComplete': isComplete,
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