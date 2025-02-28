class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;
  String category;
  DateTime? deadline;
  int priority;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.deadline,
    required this.priority,
  });

  /// Converts the Todo object into a Map representation, which is useful for
  /// storing in a database. The keys represent the column names and the values
  /// are the corresponding field values. The `isCompleted` field is converted
  /// to an integer (1 for true, 0 for false).

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'deadline': deadline?.toIso8601String(),
      'priority': priority,
    };
  }

  /// Converts the Todo Map into a object representation, which is useful for
  /// using the data in the application
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      category: map['category'],
      deadline:
          map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      priority: map['priority'],
    );
  }
}
