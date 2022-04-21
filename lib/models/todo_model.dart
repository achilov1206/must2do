import 'dart:convert';
import 'package:equatable/equatable.dart';

enum Filter {
  all,
  active,
  completed,
}

const String todoTableName = 'todo';

//DataBase fileds name
class TodoFields {
  static const List<String> columns = [
    id,
    categoryId,
    title,
    description,
    dateTime,
    completed,
  ];
  static const String id = 'id';
  static const String categoryId = 'categoryId';
  static const String title = 'title';
  static const String description = 'description';
  static const String dateTime = 'dateTime';
  static const String completed = 'completed';
}

class Todo extends Equatable {
  final int? id;
  final String categoryId;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool completed;

  const Todo({
    this.id,
    required this.categoryId,
    required this.title,
    required this.dateTime,
    this.description,
    this.completed = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        completed,
        dateTime,
        categoryId,
      ];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({TodoFields.id: id});
    result.addAll({TodoFields.categoryId: categoryId});
    result.addAll({TodoFields.title: title});
    result.addAll({TodoFields.description: description});
    result.addAll({TodoFields.dateTime: dateTime.millisecondsSinceEpoch});
    result.addAll({TodoFields.completed: completed == false ? 0 : 1});
    return result;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map[TodoFields.id],
      categoryId: map[TodoFields.categoryId],
      title: map[TodoFields.title],
      description: map[TodoFields.description] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map[TodoFields.dateTime]),
      completed: map[TodoFields.completed] == 0 ? false : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Todo(id: $id, categoryId: $categoryId, title: $title, description: $description, dateTime: $dateTime, completed: $completed)';
  }
}
