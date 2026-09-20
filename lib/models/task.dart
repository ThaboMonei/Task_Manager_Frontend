class Task{
  final int? id;
  final String? title;
  final String? description;
  final bool isComplete;
  final DateTime? dueDate;
  final DateTime? createdAt;

  Task(
    {
      this.id,
      required this.title,
       this.dueDate,
      this.description,
       this.createdAt,
      this.isComplete = false
      });

    factory Task.fromJson(Map<String,dynamic> json){
      return Task(
        id: json['id'],
        title: json['title'] as String? ?? '',
        dueDate: json['dueDate'] !=  null ? DateTime.parse(json['dueDate'] as String) : null,
        description: json['description'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createAt'] as String): null,
        isComplete: json['isComplete'] ?? false
      );
    }

    Map<String, dynamic> toJson(){
      return {
        if(id != null)
        'id': id,
        'title': title,
        if(dueDate != null)'dueDate': dueDate!.toIso8601String(),
        'description': description,
        if(createdAt != null)'createdAt': createdAt!.toIso8601String(),
        'isComplete': isComplete,
      };
    }
}