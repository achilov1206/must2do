import './custom_error.dart';

import '../db/database.dart';
import './todo_model.dart';

class TodoDao {
  final dataBase = DB();

  //Insert Todo to DB
  Future<int> insertTodo(Todo todo) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.insert(todoTableName, todo.toMap());
      return result;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/inserTodo',
      );
    }
  }

  // //Get one Todo by ID from DB
  // Future<Todo> getTodo(int id) async {
  //   try {
  //     final dbProvider = await dataBase.db;
  //     var result = await dbProvider.query(
  //       todoTableName,
  //       columns: TodoFields.columns,
  //       where: '${TodoFields.id} = ?',
  //       whereArgs: [id],
  //     );
  //     return Todo.fromMap(result[0]);
  //   } catch (e) {
  //     throw CustomError(
  //       code: 'Exception',
  //       message: e.toString(),
  //       plugin: 'todo_dao/getTodo',
  //     );
  //   }
  // }

  Future<List> getTodosByCategoryId(String id) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        todoTableName,
        columns: TodoFields.columns,
        orderBy: '${TodoFields.dateTime} DESC',
        where: 'categoryId = ?',
        whereArgs: [id],
      );
      return result.map((e) => Todo.fromMap(e)).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/getTodosByCategoryId',
      );
    }
  }

  Future<List> getTodosByDate(DateTime dateTime) async {
    int date = dateTime.millisecondsSinceEpoch;
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        todoTableName,
        columns: TodoFields.columns,
        orderBy: '${TodoFields.dateTime} DESC',
        where: 'dateTime = ?',
        whereArgs: [date],
      );
      return result.map((e) => Todo.fromMap(e)).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/getTodosByDate',
      );
    }
  }

  //Get all Todo from DB
  Future<List> getTodos() async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        todoTableName,
        columns: TodoFields.columns,
        orderBy: '${TodoFields.dateTime} DESC',
      );
      await dbProvider.close();
      return result.map((e) => Todo.fromMap(e)).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/getTodos',
      );
    }
  }

  Future<int> countTodoByCategoryId(String id) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        todoTableName,
        columns: TodoFields.columns,
        where: 'categoryId = ? and completed = ?',
        whereArgs: [id, 0],
      );
      return result.length;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/countTodoByCategoryId',
      );
    }
  }

  //Get new todos where DateTime.now() >= datetime
  Future<List> getTodosTillDate(DateTime dateTime) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        todoTableName,
        columns: TodoFields.columns,
        orderBy: '${TodoFields.dateTime} ASC',
        where: 'dateTime >= ?',
        whereArgs: [dateTime.millisecondsSinceEpoch],
      );
      return result.map((e) => Todo.fromMap(e)).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/getNewTodos',
      );
    }
  }

  //Delete Todo by id
  Future<int> deleteTodo(int id) async {
    try {
      final dbProvider = await dataBase.db;
      int r = await dbProvider.delete(
        todoTableName,
        where: '${TodoFields.id} = ?',
        whereArgs: [id],
      );
      return r;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/deleteTodo',
      );
    }
  }

  //Delete Todo by id
  Future<int> deleteTodosWhereCatId(String id) async {
    try {
      final dbProvider = await dataBase.db;
      int r = await dbProvider.delete(
        todoTableName,
        where: '${TodoFields.categoryId} = ?',
        whereArgs: [id],
      );
      return r;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'deleteTodoWhereCatId/deleteTodo',
      );
    }
  }

  //Update Todo
  Future<int> updateTodo(Todo todo) async {
    try {
      final dbProvider = await dataBase.db;
      var r = await dbProvider.update(
        todoTableName,
        todo.toMap(),
        where: "${TodoFields.id} = ?",
        whereArgs: [todo.id],
      );
      return r;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'todo_dao/updateTodo',
      );
    }
  }

  //Close DB connection
  Future close() async {
    final dbProvider = await dataBase.db;
    dbProvider.close();
  }
}
