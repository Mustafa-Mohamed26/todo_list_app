import 'package:flutter/material.dart';

class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;
  String category;
  DateTime? deadline;
  TimeOfDay? time;
  int priority;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
    required this.deadline,
    required this.time,
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
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'priority': priority,
    };
  }

  /// Converts the Todo Map into a object representation, which is useful for
  /// using the data in the application
  factory Todo.fromMap(Map<String, dynamic> map) {
    TimeOfDay? time;
    if (map['time'] != null) {
      final timeParts = (map['time'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      category: map['category'] ?? '',
      deadline:
          map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      time: time,
      priority: map['priority'] ?? 1,
    );
  }

  /// Converts the deadline DateTime to a formatted string
  String get formattedDeadline {
    if (deadline == null) return '';
    return "${deadline!.year}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}";
  }

  /// Converts the deadline DateTime to a formatted string with abbreviated month name
  String get formattedDeadlineWithMonthName {
    if (deadline == null) return 'No deadline';
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = monthNames[deadline!.month - 1];
    return '$monthName ${deadline!.day}, ${deadline!.year}';
  }

  /// Converts the time to a formatted string
  String get formattedTime {
    if (time == null) return '';
    final hour = time!.hour.toString().padLeft(2, '0');
    final minute = time!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
