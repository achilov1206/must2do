import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../models/todo_model.dart';
import '../../repositories/todo_repositories.dart';
part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository _todoRepository = TodoRepository();
  TodoListBloc() : super(TodoListState.initial()) {
    on<GetTodos>((event, emit) async {
      await emit.forEach<List>(
        _todoRepository.getTodos(),
        onData: (todos) {
          Map<String, List<Todo>> todosMap = {};
          for (Todo todo in todos) {
            String dateLabel = DateFormat("dd-MMM").format(todo.dateTime);
            if (todosMap.containsKey(dateLabel)) {
              todosMap[dateLabel]!.add(todo);
            } else {
              todosMap.addAll({
                dateLabel: [todo]
              });
            }
          }
          //{'date':[], 'date':[]}
          //[{date:[]}, {date:[]}]
          return state.copyWith(todos: todosMap);
        },
        onError: (_, __) => state.copyWith(todos: {}),
      );
    });
    on<ToggleTodoEvent>((event, emit) async {
      await _todoRepository.updateTodo(
        Todo(
          id: event.todo.id,
          categoryId: event.todo.categoryId,
          title: event.todo.title,
          dateTime: event.todo.dateTime,
          description: event.todo.description,
          completed: !event.todo.completed,
        ),
      );
      add(GetTodos());
    });
    on<AddTodoEvent>((event, emit) async {
      final newTodo = Todo(
        categoryId: event.todoCatId,
        title: event.todoTitle,
        dateTime: event.dateTime,
        description: event.todoDescription,
      );
      await _todoRepository.insertTodo(newTodo);
    });
    on<EditTodoEvent>((event, emit) {
      // final newTodos = state.todos.map((Todo todo) {
      //   if (todo.id == event.id) {
      //     return Todo(
      //       id: event.id,
      //       title: event.newTitle,
      //       categoryId: event.newCatId,
      //       description: event.newDescription,
      //       dateTime: event.newDateTime,
      //       completed: todo.completed,
      //     );
      //   }
      //   return todo;
      // }).toList();
      // emit(state.copyWith(todos: newTodos));
    });
    on<RemoveTodoEvent>((event, emit) {
      // final newTodos =
      //     state.todos.where((Todo t) => t.id != event.todo.id).toList();
      // emit(state.copyWith(todos: newTodos));
    });
  }
}
