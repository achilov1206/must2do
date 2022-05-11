part of 'active_todo_count_cubit.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;
  const ActiveTodoCountState({required this.activeTodoCount});

  factory ActiveTodoCountState.initial(int initialActiveTodoCount) {
    return ActiveTodoCountState(activeTodoCount: initialActiveTodoCount);
  }

  @override
  List<Object?> get props => [activeTodoCount];

  @override
  String toString() =>
      'ActiveTodoCountState(activeTodoCount: $activeTodoCount)';

  ActiveTodoCountState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }
}
