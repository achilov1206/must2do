part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class GetTodos extends TodoListEvent {}

class GetTodo extends TodoListEvent {
  final Todo todo;
  const GetTodo({
    required this.todo,
  });
}

class AddTodoEvent extends TodoListEvent {
  final String todoCatId;
  final String todoTitle;
  final String? todoDescription;
  final DateTime dateTime;
  const AddTodoEvent({
    required this.todoTitle,
    required this.todoCatId,
    this.todoDescription,
    required this.dateTime,
  });

  @override
  List<Object> get props => [todoTitle, todoCatId, dateTime];

  @override
  String toString() {
    return 'AddTodoEvent(todoTitle: $todoTitle, todoCatId: $todoCatId, todoDescription: $todoDescription, dateTime: $dateTime)';
  }
}

class EditTodoEvent extends TodoListEvent {
  final int id;
  final String newTitle;
  final String newCatId;
  final String? newDescription;
  final DateTime newDateTime;
  const EditTodoEvent({
    required this.id,
    required this.newTitle,
    required this.newCatId,
    this.newDescription,
    required this.newDateTime,
  });

  @override
  List<Object> get props => [id, newTitle, newCatId, newDateTime];

  @override
  String toString() {
    return 'EditTodoEvent(id: $id, newTitle: $newTitle, newCatId: $newCatId, newDescription: $newDescription, newDateTime: $newDateTime)';
  }
}

class ToggleTodoEvent extends TodoListEvent {
  final Todo todo;
  const ToggleTodoEvent({
    required this.todo,
  });

  @override
  String toString() => 'ToggleTodoEvent(todo: $todo)';

  @override
  List<Object> get props => [todo];
}

class RemoveTodoEvent extends TodoListEvent {
  final Todo todo;
  const RemoveTodoEvent({
    required this.todo,
  });

  @override
  String toString() => 'RemoveTodoEvent(todo: $todo)';

  @override
  List<Object> get props => [todo];
}
