part of 'todo_list_bloc.dart';

enum FilteredTodo { all, completed, notCompleted }

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

class GetTodosEvent extends TodoListEvent {
  final String? catId;
  const GetTodosEvent({
    this.catId,
  });

  @override
  String toString() => 'GetTodosEvent(catId: $catId)';
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
  final bool isCompleted;

  const EditTodoEvent({
    required this.id,
    required this.newTitle,
    required this.newCatId,
    this.newDescription,
    required this.newDateTime,
    required this.isCompleted,
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

class CountCompetedTaskByCategory extends TodoListEvent {
  final String catId;
  const CountCompetedTaskByCategory({required this.catId});

  @override
  String toString() => 'CountCompetedTaskByCategory(catId: $catId)';

  @override
  List<Object> get props => [catId];
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

class RemoveTodosWhereByCatIdEvent extends TodoListEvent {
  final String id;
  const RemoveTodosWhereByCatIdEvent({
    required this.id,
  });

  @override
  String toString() => 'RemoveTodosWhereCatID(id: $id)';

  @override
  List<Object> get props => [id];
}
