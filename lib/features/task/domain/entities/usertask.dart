import 'package:task_manager/features/task/domain/entities/priority.dart';

class UserTask {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;  

  UserTask({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });


  factory UserTask.fromJson(Map<dynamic, dynamic> map, String id) {
    return UserTask(
      id: id,
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: _priorityFromString(map['priority']), 
    );
  }

  // Convert enum to string for storage in Firestore or other databases
  static String _priorityToString(Priority priority) {
    return priority.toString().split('.').last;
  }

  // Convert string to enum for reading from Firestore or other databases
  static Priority _priorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        throw ArgumentError('Invalid priority value');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': _priorityToString(priority),  // Storing as string
    };
  }

  // Copy method to create a modified copy of UserTask
  UserTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
  }) {
    return UserTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}



