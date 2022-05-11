import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:collection';
import 'package:table_calendar/src/shared/utils.dart' as tCalendar;
import '../../repositories/todo_repository.dart';
import '../../models/custom_error.dart';
import '../../models/todo_model.dart';

part 'calendar_todo_state.dart';

class CalendarTodoCubit extends Cubit<CalendarTodoState> {
  final TodoRepository todoRepository;
  CalendarTodoCubit({
    required this.todoRepository,
  }) : super(CalendarTodoState.initial());

  // Future<void> getTodo(DateTime dateTime) async {
  //   try {
  //     final List<Todo> todos =
  //         await todoRepository.getTodosByDate(dateTime) as List<Todo>;
  //     return emit(state.copyWith(
  //       todos: todos,
  //       calendarTodoStatus: CalendarTodoStatus.loaded,
  //     ));
  //   } on CustomError catch (e) {
  //     return emit(
  //       state.copyWith(
  //         calendarTodoStatus: CalendarTodoStatus.error,
  //         error: e,
  //       ),
  //     );
  //   }
  // }

  void setDateTime(DateTime dateTime) {
    return emit(state.copyWith(dateTime: dateTime));
  }

  Future<LinkedHashMap> getTodos() async {
    Map<DateTime, List<Todo>> todosMap = {};
    try {
      final todos = await todoRepository.getTodos();
      for (Todo todo in todos) {
        DateTime datetime = todo.dateTime;
        if (todosMap.containsKey(datetime)) {
          todosMap[datetime]!.add(todo);
        } else {
          todosMap.addAll({
            datetime: [todo]
          });
        }
      }
    } catch (e) {
      rethrow;
    }
    final linkedHashTodos = LinkedHashMap<DateTime, List<Todo>>(
      equals: tCalendar.isSameDay,
    )..addAll(todosMap);
    return linkedHashTodos;
  }
}
