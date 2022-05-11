import './custom_error.dart';

import '../db/database.dart';
import './category_model.dart';

class CategoryDao {
  final dataBase = DB();

  //Insert category to DB
  Future<int> insertCategory(Category category) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.insert(categoryTableName, category.toMap());
      return result;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'category_dao/insertCategory',
      );
    }
  }

  //Get one category by ID from DB
  Future<Category> getCategory(int id) async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        categoryTableName,
        columns: CategoryFields.columns,
        where: '${CategoryFields.id} = ?',
        whereArgs: [id],
      );
      return Category.fromMap(result[0]);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'category_dao/getCategory',
      );
    }
  }

  //Get all categories from DB
  Future<List> getCategories() async {
    try {
      final dbProvider = await dataBase.db;
      var result = await dbProvider.query(
        categoryTableName,
        columns: CategoryFields.columns,
      );
      return result.map((e) => Category.fromMap(e)).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'category_dao/getCategories',
      );
    }
  }

  //Delete category by id
  Future<int> deleteCategory(int id) async {
    try {
      final dbProvider = await dataBase.db;
      int r = await dbProvider.delete(
        categoryTableName,
        where: '${CategoryFields.id} = ?',
        whereArgs: [id],
      );
      return r;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'category_dao/deleteCategory',
      );
    }
  }

  //Update category
  Future<int> updateCategory(Category cat) async {
    try {
      final dbProvider = await dataBase.db;
      var r = await dbProvider.update(
        categoryTableName,
        cat.toMap(),
        where: "${CategoryFields.id} = ?",
        whereArgs: [cat.id],
      );
      return r;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'category_dao/updateCategory',
      );
    }
  }

  //Close DB connection
  Future close() async {
    final dbProvider = await dataBase.db;
    dbProvider.close();
  }
}
