import '../models/category_dao.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryDao catDao;

  const CategoryRepository({required this.catDao});

  Future<int> insertCategory(Category category) {
    return catDao.insertCategory(category);
  }

  Future<Category> getCategory(int id) {
    return catDao.getCategory(id);
  }

  Future<List> getCategories() async {
    List categories = await catDao.getCategories();
    return categories;
  }

  Future<int> deleteCategory(int id) {
    return catDao.deleteCategory(id);
  }

  Future<int> updateCategory(Category cat) {
    return catDao.updateCategory(cat);
  }
}
