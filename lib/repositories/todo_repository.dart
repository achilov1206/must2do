import '../models/todo_dao.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final TodoDao todoDao;
  TodoRepository({required this.todoDao});

  Future<int> insertTodo(Todo todo) {
    return todoDao.insertTodo(todo);
  }

  Future<List> getTodosTillDate(DateTime dateTime) async {
    List todos = await todoDao.getTodosTillDate(dateTime);
    return todos;
  }

  Future<List> getTodosByCategoryId(String id) async {
    List todos = await todoDao.getTodosByCategoryId(id);
    return todos;
  }

  Future<List> getTodosByDate(DateTime dateTime) async {
    List todos = await todoDao.getTodosByDate(dateTime);
    return todos;
  }

  Future<List> getTodos() async {
    List todos = await todoDao.getTodos();
    return todos;
  }

  Future<int> countTodoByCategoryId(String id) {
    return todoDao.countTodoByCategoryId(id);
  }

  Future<int> deleteTodo(int id) {
    return todoDao.deleteTodo(id);
  }

  Future<int> deleteTodosWhereCatId(String id) {
    return todoDao.deleteTodosWhereCatId(id);
  }

  Future<int> editTodo(Todo todo) {
    return todoDao.updateTodo(todo);
  }
}
