import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final List<Todo> initialTodos;

  FilteredTodosBloc({
    required this.initialTodos,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
    on<SetFilteredTodosEvent>(setFilteredTodos);
  }
  void setFilteredTodos(event, emit) {
    List<Todo> _filteredTodos;
    switch (event.filter) {
      case Filter.active:
        _filteredTodos =
            event.todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos =
            event.todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = event.todos;
    }

    if (event.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) =>
              todo.description!.toLowerCase().contains(event.searchTerm))
          .toList();
    }
    emit(state.copyWith(filteredTodos: _filteredTodos));
  }
}
