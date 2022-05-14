import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/todo_repository.dart';

import './create_category_page.dart';
import './tasks_page.dart';
import '../../utils/error_dialog.dart';
import '../../blocs/block.dart';
import '../../models/category_model.dart';
import '../../widgets/category_card.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topCenter,
          child: BlocBuilder<CategoryListBloc, CategoryListState>(
            builder: (context, state) {
              if (state.categoryListStatus == CategoryListStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.categoryListStatus == CategoryListStatus.error) {
                errorDialog(context, state.error);
              }
              context.watch<CategoryListBloc>().add(GetCategoriesEvent());
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  const CatgoryCard(
                    Category(title: 'All tasks', icon: Icons.list),
                    routeName: TasksPage.routeName,
                  ),
                  ...state.categories.map((Category cat) {
                    return CatgoryCard(
                      cat,
                      routeName: TasksPage.routeName,
                      byCategoryId: true,
                    );
                  }),
                  const CatgoryCard(
                    Category(title: 'Add List', icon: Icons.add),
                    iconColor: Colors.green,
                    titleColor: Colors.black,
                    routeName: CreateCategoryPage.routeName,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
