part of 'category_list_bloc.dart';

class CategoryListState extends Equatable {
  final List<Category> categories;
  const CategoryListState({
    required this.categories,
  });

  factory CategoryListState.initial() {
    return CategoryListState(categories: [
      Category(id: 1, title: 'Personal', icon: Icons.task),
      Category(id: 2, title: 'Work', icon: Icons.work),
    ]);
  }

  @override
  List<Object?> get props => [categories];

  @override
  String toString() => 'CategoryListState(categories: $categories)';

  CategoryListState copyWith({
    List<Category>? categories,
  }) {
    return CategoryListState(
      categories: categories ?? this.categories,
    );
  }
}
