import '../models/category_dao.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final catDao = CategoryDao();

  Future<int> insertCategory(Category category) {
    return catDao.insertCategory(category);
  }

  Future<Category> getCategory(int id) {
    return catDao.getCategory(id);
  }

  Stream<List> getCategories() {
    return Stream.fromFuture(catDao.getCategories());
  }

  Future<int> deleteCategory(int id) {
    return catDao.deleteCategory(id);
  }

  Future<int> updateCategory(Category cat) {
    return catDao.updateCategory(cat);
  }
}
