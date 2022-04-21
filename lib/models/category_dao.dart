import '../db/database.dart';
import './category_model.dart';

class CategoryDao {
  final dataBase = DB();

  //Insert category to DB
  Future<int> insertCategory(Category category) async {
    final dbProvider = await dataBase.db;
    var result;
    try {
      result = await dbProvider.insert(categoryTableName, category.toMap());
    } catch (e) {
      result = 0;
    }
    return result;
  }

  //Get one category by ID from DB
  Future<Category> getCategory(int id) async {
    final dbProvider = await dataBase.db;
    var result = await dbProvider.query(
      categoryTableName,
      columns: CategoryFields.columns,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
    return Category.fromMap(result[0]);
  }

  //Get all categories from DB
  Future<List> getCategories() async {
    final dbProvider = await dataBase.db;
    var result = await dbProvider.query(
      categoryTableName,
      columns: CategoryFields.columns,
    );
    return result.map((e) => Category.fromMap(e)).toList();
  }

  //Delete category by id
  Future<int> deleteCategory(int id) async {
    final dbProvider = await dataBase.db;
    int r = await dbProvider.delete(
      categoryTableName,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
    return r;
  }

  //Update category
  Future<int> updateCategory(Category cat) async {
    final dbProvider = await dataBase.db;
    var r = await dbProvider.update(
      categoryTableName,
      cat.toMap(),
      where: "${CategoryFields.id} = ?",
      whereArgs: [cat.id],
    );

    return r;
  }

  //Close DB connection
  Future close() async {
    final dbProvider = await dataBase.db;
    dbProvider.close();
  }
}
