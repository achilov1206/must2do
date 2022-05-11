part of 'category_list_bloc.dart';

enum CategoryListStatus { initial, loading, loaded, error }

class CategoryListState extends Equatable {
  final List<Category> categories;
  final CategoryListStatus categoryListStatus;
  final CustomError error;
  const CategoryListState({
    required this.categories,
    required this.categoryListStatus,
    required this.error,
  });

  factory CategoryListState.initial() {
    return const CategoryListState(
      categories: [],
      categoryListStatus: CategoryListStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [categories];

  @override
  String toString() =>
      'CategoryListState(categories: $categories, categoryListStatus: $categoryListStatus, error: $error)';

  CategoryListState copyWith({
    List<Category>? categories,
    CategoryListStatus? categoryListStatus,
    CustomError? error,
  }) {
    return CategoryListState(
      categories: categories ?? this.categories,
      categoryListStatus: categoryListStatus ?? this.categoryListStatus,
      error: error ?? this.error,
    );
  }
}
