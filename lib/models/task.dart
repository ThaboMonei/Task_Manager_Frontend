enum Priority { low, medium, high }

class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final Priority priority;
  final bool isSynced;

  Task({
    this.id,
    required this.title,
    this.dueDate,
    this.description,
    this.createdAt,
    this.isCompleted = false,
    this.priority = Priority.medium,
    this.isSynced = false, 
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json['id'] as int?,
        title: json['title'] as String? ?? '',
        dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'] as String) : null,
        description: json['description'] as String?,
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
        // Using common variations in C# JSON keys (isCompleted vs isComplete)
        isCompleted: json['isCompleted'] ?? json['isComplete'] ?? false,
        priority: _parsePriority(json['priority'] as int?),
        isSynced: true, 
      );
    } catch (e) {
      print('fromJson FAILED for: $json');
      print('Error: $e');
      rethrow;
    }
  }
  
  // Standard conversion for SQLite local storage
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  // CRITICAL FOR C#: Use this specifically when sending data via HTTP POST/PUT to .NET API
  Map<String, dynamic> toApiJson({bool includeId = false}) {
    return {
      if (includeId && id != null) 'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  Task copyWith({int? id, bool? isSynced, bool? isCompleted, String? title, String? description, DateTime? dueDate, Priority? priority}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

Priority _parsePriority(int? value) {
  switch (value) {
    case 0: return Priority.low;
    case 1: return Priority.medium;
    case 2: return Priority.high;
    default: return Priority.medium;
  }
}
