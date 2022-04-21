import '../models/todo_dao.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final todoDao = TodoDao();

  Future<int> insertTodo(Todo todo) {
    return todoDao.insertTodo(todo);
  }

  Future<Todo> getTodo(int id) {
    return todoDao.getTodo(id);
  }

  Stream<List> getTodos() {
    return Stream.fromFuture(todoDao.getTodos());
  }

  Future<int> deleteTodo(int id) {
    return todoDao.deleteTodo(id);
  }

  Future<int> updateTodo(Todo todo) {
    return todoDao.updateTodo(todo);
  }
}
