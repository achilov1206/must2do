import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:must2do/models/custom_error.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/category_model.dart';
import '../../repositories/category_repository.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final CategoryRepository categoryRepository;

  CategoryListBloc({required this.categoryRepository})
      : super(CategoryListState.initial()) {
    on<GetCategoriesEvent>(getCategories);
    on<AddCategoryEvent>((event, emit) async {
      final newCategory = Category(title: event.title, icon: event.icon);
      await categoryRepository.insertCategory(newCategory);
      add(GetCategoriesEvent());
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

  Future<void> getCategories(event, emit) async {
    emit(state.copyWith(categoryListStatus: CategoryListStatus.loading));
    try {
      List catData = await categoryRepository.getCategories();
      if (catData.isNotEmpty) {
        return emit(state.copyWith(
          categoryListStatus: CategoryListStatus.loaded,
          categories: catData as List<Category>,
        ));
      }
    } on CustomError catch (e) {
      return emit(
        state.copyWith(categoryListStatus: CategoryListStatus.error, error: e),
      );
    }
  }
}
