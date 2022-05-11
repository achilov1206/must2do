part of 'calendar_todo_cubit.dart';

enum CalendarTodoStatus { initial, loading, loaded, empty, error }

class CalendarTodoState extends Equatable {
  final DateTime dateTime;
  const CalendarTodoState({
    required this.dateTime,
  });

  factory CalendarTodoState.initial() {
    return CalendarTodoState(
      dateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
  }

  @override
  List<Object> get props => [dateTime];

  @override
  String toString() => 'TodoListState(dateTime: $dateTime)';

  CalendarTodoState copyWith({
    DateTime? dateTime,
  }) {
    return CalendarTodoState(
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
