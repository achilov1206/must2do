import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../../repositories/todo_repository.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  final String catId;
  final TodoRepository todoRepository;
  ActiveTodoCountCubit({
    required this.catId,
    required this.todoRepository,
  }) : super(ActiveTodoCountState.initial(0)) {
    countTodo();
  }

  Future<void> countTodo() async {
    final currentActiveTodoCount =
        await todoRepository.countTodoByCategoryId(catId);
    return emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
  }
}
