import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/category_model.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc() : super(CategoryListState.initial()) {
    on<AddCategoryEvent>((event, emit) {
      final newCategory = Category(title: event.title, icon: event.icon);
      final newCategories = [...state.categories, newCategory];
      emit(state.copyWith(categories: newCategories));
    });
    on<EditCategoryEvent>((event, emit) {
      final newCategories = state.categories.map((Category cat) {
        if (cat.id == event.id) {
          return Category(
            id: event.id,
            title: event.title,
            icon: event.icon,
          );
        }
        return cat;
      }).toList();
      emit(state.copyWith(categories: newCategories));
    });
    on<RemoveCategoryEvent>((event, emit) {
      final newCategories = state.categories
          .where((Category cat) => cat.id != event.category.id)
          .toList();
      emit(state.copyWith(categories: newCategories));
    });
  }
}
