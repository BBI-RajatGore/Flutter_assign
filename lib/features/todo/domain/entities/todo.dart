import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart'; 

@HiveType(typeId: 0) 
class Todo extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  Todo({
    required this.id,
    required this.title,
    required this.description,
  });


  Todo copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id, 
      title: title ?? this.title, 
      description: description ?? this.description, 
    );
  }

  @override
  List<Object?> get props => [id, title, description];
}

