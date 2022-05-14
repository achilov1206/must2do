import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:table_calendar/src/shared/utils.dart' as t_calendar;
import '../../models/todo_model.dart';
import '../../models/custom_error.dart';
import '../../repositories/todo_repository.dart';
part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository todoRepository;
  TodoListBloc({required this.todoRepository})
      : super(TodoListState.initial()) {
    on<GetTodosEvent>(getTodos);

    on<ToggleTodoEvent>((event, emit) async {
      await todoRepository.editTodo(
        Todo(
          id: event.todo.id,
          categoryId: event.todo.categoryId,
          title: event.todo.title,
          dateTime: event.todo.dateTime,
          description: event.todo.description,
          completed: !event.todo.completed,
        ),
      );
      add(const GetTodosEvent());
    });
    on<AddTodoEvent>((event, emit) async {
      final newTodo = Todo(
        categoryId: event.todoCatId,
        title: event.todoTitle,
        dateTime: event.dateTime,
        description: event.todoDescription,
      );
      await todoRepository.insertTodo(newTodo);
      add(const GetTodosEvent());
    });
    on<EditTodoEvent>((event, emit) async {
      await todoRepository.editTodo(
        Todo(
          id: event.id,
          categoryId: event.newCatId,
          title: event.newTitle,
          dateTime: event.newDateTime,
          description: event.newDescription,
          completed: event.isCompleted,
        ),
      );
      add(const GetTodosEvent());
    });
    on<RemoveTodoEvent>((event, emit) {
      emit(state.copyWith(todoListStatus: TodoListStatus.loading));
      todoRepository.deleteTodo(event.todo.id!);
      add(const GetTodosEvent());
    });
    on<RemoveTodosWhereByCatIdEvent>(((event, emit) {
      emit(state.copyWith(todoListStatus: TodoListStatus.loading));
      todoRepository.deleteTodosWhereCatId(event.id);
      add(const GetTodosEvent());
    }));
  }

  Future<void> getTodos(event, emit) async {
    //emit(state.copyWith(todoListStatus: TodoListStatus.loading));
    try {
      List todosData;
      // get new todos for all categories if cat id is not given
      // else get todos by catId for given category
      if (event.catId == null) {
        DateTime _dt = DateTime.now();
        todosData = await todoRepository.getTodosTillDate(DateTime(
          _dt.year,
          _dt.month,
          _dt.day,
        ));
      } else {
        todosData = await todoRepository.getTodosByCategoryId(event.catId);
      }

      //conver todos list to Map = {'date': [Todos()...],...}
      Map<DateTime, List<Todo>> todosMap = {};
      for (Todo todo in todosData) {
        if (todosMap.containsKey(todo.dateTime)) {
          todosMap[todo.dateTime]!.add(todo);
        } else {
          todosMap.addAll({
            todo.dateTime: [todo]
          });
        }
      }
      if (todosMap.isEmpty) {
        return emit(state.copyWith(
          todos: {},
          todoListStatus: TodoListStatus.empty,
        ));
      }
      return emit(state.copyWith(
        todos: todosMap,
        todoListStatus: TodoListStatus.loaded,
      ));
    } on CustomError catch (e) {
      return emit(
        state.copyWith(todoListStatus: TodoListStatus.error, error: e),
      );
    }
  }
}
