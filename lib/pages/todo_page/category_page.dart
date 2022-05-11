import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/todo_repository.dart';

import './create_category_page.dart';
import './tasks_page.dart';
import '../../utils/error_dialog.dart';
import '../../blocs/block.dart';
import '../../models/category_model.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget categoryCard(
      Category cat, {
      Color? iconColor,
      Color? titleColor,
      String? routeName,
      bool byCategoryId = false,
    }) {
      return SizedBox(
        width: 180,
        height: 230,
        child: InkWell(
          splashColor: Colors.green,
          onTap: () {
            if (routeName != null) {
              if (byCategoryId == true) {
                Navigator.pushNamed(
                  context,
                  routeName,
                  arguments: {
                    'byCategoryId': byCategoryId,
                    'cat': cat,
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  routeName,
                );
              }
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat.icon,
                    size: 80,
                    color: iconColor ?? Colors.black54,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    cat.title,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      color: titleColor ?? Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (byCategoryId == true)
                    BlocConsumer<TodoListBloc, TodoListState>(
                      builder: (context, state) {
                        return BlocProvider(
                          create: (context) => ActiveTodoCountCubit(
                            catId: cat.id.toString(),
                            todoRepository: context.read<TodoRepository>(),
                          ),
                          child: BlocBuilder<ActiveTodoCountCubit,
                              ActiveTodoCountState>(
                            builder: (context, state) {
                              context.read<ActiveTodoCountCubit>().countTodo();
                              String output =
                                  state.activeTodoCount > 1 ? 'tasks' : 'task';
                              return Text(
                                '${state.activeTodoCount.toString()} $output left',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      listener: (context, state) {},
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                  categoryCard(
                    const Category(title: 'All tasks', icon: Icons.list),
                    routeName: TasksPage.routeName,
                  ),
                  ...state.categories.map((Category cat) {
                    return categoryCard(
                      cat,
                      routeName: TasksPage.routeName,
                      byCategoryId: true,
                    );
                  }),
                  categoryCard(
                    const Category(title: 'Add List', icon: Icons.add),
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
