part of 'filtered_todos_bloc.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class CalculateFilteredTodosEvent extends FilteredTodosEvent {
  final List<Todo> filteredTodos;
  const CalculateFilteredTodosEvent({
    required this.filteredTodos,
  });

  @override
  String toString() => 'SetFilteredTodosEvent(dilteredTodos: $filteredTodos)';
  @override
  List<Object> get props => [filteredTodos];
}

class SetFilteredTodosEvent extends FilteredTodosEvent {
  final List<Todo> todos;
  final Filter filter;
  final String searchTerm;
  const SetFilteredTodosEvent({
    required this.todos,
    required this.filter,
    required this.searchTerm,
  });

  @override
  List<Object> get props => [todos, filter, searchTerm];

  @override
  String toString() =>
      'SetFilteredTodosEvent(todos: $todos, filter: $filter, searchTerm: $searchTerm)';
}
