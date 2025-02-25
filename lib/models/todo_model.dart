class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
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
      'isCompleted': isCompleted ? 1 : 0
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}