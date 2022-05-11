part of 'category_list_bloc.dart';

abstract class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends CategoryListEvent {}

class AddCategoryEvent extends CategoryListEvent {
  final String title;
  final IconData icon;
  const AddCategoryEvent({
    required this.title,
    required this.icon,
  });

  @override
  String toString() => 'AddCategoryEvent(title: $title, icon: $icon)';

  @override
  List<Object> get props => [title, icon];
}

class EditCategoryEvent extends CategoryListEvent {
  final int id;
  final String title;
  final IconData icon;
  const EditCategoryEvent({
    required this.id,
    required this.title,
    required this.icon,
  });

  @override
  String toString() => 'EditCategoryEvent(id: $id, title: $title, icon: $icon)';

  @override
  List<Object> get props => [id, title, icon];
}

class RemoveCategoryEvent extends CategoryListEvent {
  final Category category;
  const RemoveCategoryEvent({
    required this.category,
  });

  @override
  String toString() => 'RemoveCategoryEvent(category: $category)';

  @override
  List<Object> get props => [category];
}
