class Task{
  final int? id;
  final String title;
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
        title: json['title'],
        dueDate: json['dueDate'],
        description: json['description'],
        createdAt: json['createdAt'],
        isComplete: json['isComplete'] ?? false
      );
    }

    Map<String, dynamic> toJson(){
      return {
        if(id != null)
        'id': id,
        'title': title,
        'dueDate': dueDate,
        'description': description,
        'createdAt': createdAt,
        'isComplete': isComplete,
      };
    }
}