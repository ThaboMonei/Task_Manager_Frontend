class Task{
  final String title;
  final String? description;
  final bool isComplete;
  final DateTime dueDate;
  final DateTime createdAt;

  Task(
    {
      required this.title,
      required this.dueDate,
      this.description,
      required this.createdAt,
      this.isComplete = false
      });
}