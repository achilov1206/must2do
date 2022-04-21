part of 'todo_list_bloc.dart';

class TodoListState extends Equatable {
  final Map<String, List<Todo>> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return const TodoListState(todos: {});
  }

  @override
  List<Object?> get props => [todos];

  @override
  String toString() => 'TodoListState(todos: $todos)';

  TodoListState copyWith({
    Map<String, List<Todo>>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}
