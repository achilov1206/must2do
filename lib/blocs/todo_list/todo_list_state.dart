part of 'todo_list_bloc.dart';

enum TodoListStatus { initial, loading, loaded, empty, error }

class TodoListState extends Equatable {
  final Map<String, List<Todo>> todos;
  final TodoListStatus todoListStatus;
  final CustomError error;
  const TodoListState({
    required this.todos,
    required this.todoListStatus,
    required this.error,
  });

  factory TodoListState.initial() {
    return const TodoListState(
      todos: {},
      todoListStatus: TodoListStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [todos, todoListStatus, error];

  @override
  String toString() =>
      'TodoListState(todos: $todos, todoListStatus: $todoListStatus, error: $error)';

  TodoListState copyWith({
    Map<String, List<Todo>>? todos,
    TodoListStatus? todoListStatus,
    CustomError? error,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
      todoListStatus: todoListStatus ?? this.todoListStatus,
      error: error ?? this.error,
    );
  }
}
