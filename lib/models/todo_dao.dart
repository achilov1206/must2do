import '../db/database.dart';
import './todo_model.dart';

class TodoDao {
  final dataBase = DB();

  //Insert Todo to DB
  Future<int> insertTodo(Todo todo) async {
    final dbProvider = await dataBase.db;
    var result;
    try {
      result = await dbProvider.insert(todoTableName, todo.toMap());
    } catch (e) {
      return 0;
    }
    return result;
  }

  //Get one Todo by ID from DB
  Future<Todo> getTodo(int id) async {
    final dbProvider = await dataBase.db;
    var result = await dbProvider.query(
      todoTableName,
      columns: TodoFields.columns,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
    return Todo.fromMap(result[0]);
  }

  //Get all Todo from DB
  Future<List> getTodos() async {
    final dbProvider = await dataBase.db;
    var result = await dbProvider.query(
      todoTableName,
      columns: TodoFields.columns,
      orderBy: '${TodoFields.dateTime} DESC',
    );
    return result.map((e) => Todo.fromMap(e)).toList();
  }

  //Delete Todo by id
  Future<int> deleteTodo(int id) async {
    final dbProvider = await dataBase.db;
    int r = await dbProvider.delete(
      todoTableName,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
    return r;
  }

  //Update Todo
  Future<int> updateTodo(Todo todo) async {
    final dbProvider = await dataBase.db;
    var r = await dbProvider.update(
      todoTableName,
      todo.toMap(),
      where: "${TodoFields.id} = ?",
      whereArgs: [todo.id],
    );
    return r;
  }

  //Close DB connection
  Future close() async {
    final dbProvider = await dataBase.db;
    dbProvider.close();
  }
}
