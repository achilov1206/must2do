import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './create_category_page.dart';
import './tasks_page.dart';
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
    }) {
      return InkWell(
        splashColor: Colors.green,
        onTap: () {
          if (routeName != null) {
            Navigator.pushNamed(context, routeName);
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
                  style: TextStyle(
                    color: titleColor ?? Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  '9 tasks',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
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
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  categoryCard(
                    Category(title: 'All tasks', icon: Icons.list),
                    routeName: TasksPage.routeName,
                  ),
                  ...state.categories.map((Category cat) {
                    return categoryCard(cat);
                  }),
                  categoryCard(
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
